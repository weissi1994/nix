{
  description = "Ion's NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs at the same time.
    # See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # `outputs` are all the build result of the flake.
  #
  # A flake can have many use cases and different types of outputs.
  #
  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  #
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, nix-formatter-pack, home-manager, ... }@inputs:
  let
    inherit (self) outputs;

    # NixOs (Workstation)
    mkHome = { hostname, username, desktop ? null, platform ? "x86_64-linux" }: inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit self inputs outputs desktop hostname platform username stateVersion;
      };
      modules = [ ./home ];
    };

    # Helper function for generating host configs
    mkHost = { hostname, username, desktop ? null, installer ? null, offline_installer ? null, platform ? "x86_64-linux", hm ? false, os_disk ? null, os_layout ? "btrfs", data_disks ? [], data_layout ? "btrfs", roles ? [] }: inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self inputs outputs desktop offline_installer hostname platform username os_disk os_layout data_disks data_layout stateVersion;
      };
      modules = [
        ./hosts
      ] ++ (inputs.nixpkgs.lib.optionals (installer != null) [ installer ])
        ++ (inputs.nixpkgs.lib.optionals (roles != []) roles)
        ++ (inputs.nixpkgs.lib.optionals (hm == true) [
          home-manager.nixosModules.home-manager
          {
            # home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home;

            home-manager.extraSpecialArgs = {
              inherit self inputs outputs desktop hostname platform username stateVersion;
            };
          }
        ]);
    };

    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  in
  {
    overlays = import ./overlays { inherit inputs; };

    # nix fmt
    formatter = forAllSystems (system:
      nix-formatter-pack.lib.mkFormatter {
        pkgs = nixpkgs.legacyPackages.${system};
        config.tools = {
          alejandra.enable = false;
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
        };
      }
    );

    # Devshell for bootstrapping; acessible via 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in import ./shell.nix { inherit pkgs; }
    );

    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in import ./pkgs { inherit pkgs; }
    );

    homeConfigurations = {
      # Only homemanager (for non-nixos systems)
      #  - home-manager switch -b backup --flake .#ion@terro
      "ion@generic" = mkHome { hostname = "generic"; username = "ion"; };
    };

    nixosConfigurations = {
      # Workstations
      #  - sudo nixos-install --no-root-password --flake ".#$TARGET_HOST"
      #  - sudo nixos-rebuild switch --flake ".#$TARGET_HOST"
      terro   = mkHost { hostname = "terro"; username = "ion"; desktop = "sway"; hm = true; os_disk = "/dev/disk/by-id/wwn-0x5002538e4084d7cc"; };
      bean    = mkHost { hostname = "bean";  username = "ion"; desktop = "sway"; hm = true; os_disk = "/dev/disk/by-id/nvme-eui.5cd2e42a8140cf60"; };
      # Copy this line for new hosts
      generic = mkHost { hostname = "generic"; username = "ion"; hm = true; os_disk = "/dev/vda"; };
      # ISOs (for initial installation and testing)
      #  - nix build .#nixosConfigurations.iso.config.formats.iso
      #  - nix build .#nixosConfigurations.iso.config.formats.install-iso
      #  - nix build .#nixosConfigurations.iso.config.formats.vm
      #  - nix build .#nixosConfigurations.iso.config.formats.docker
      #  See https://github.com/nix-community/nixos-generators
      #  for more options
      #  
      #  Add `offline_installer = "<TARGET_HOST>";` 
      #  to bundle a pre-compiled system into the iso
      installer-sway     = mkHost { hostname = "installer"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "sway"; };
      installer-pantheon = mkHost { hostname = "installer"; username = "nixos"; installer = nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"; desktop = "pantheon"; };

      # NixOs Servers managed by this flake 
      # TODO: define mkServer which takes roles, like pxe webserver etc
      # Disk config and co via hostname
      # plow = import ./servers/pxe.nix;
      # rock = import ./servers/hetzner.nix;
      xeus = mkHost {
        hostname = "xeus";
        username = "ion";
        hm = false;
        os_disk = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S21PNXAG526571M";
        roles = [
          ./servers/pxe.nix
        ];
      };
    };
  };
}

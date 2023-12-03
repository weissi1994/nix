{ inputs, lib, config, pkgs, ... }:
let
   # Fallback PXE-Boot system config
   sys = inputs.nixos.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ];
        config = {
          services.openssh = {
            enable = true;
            openFirewall = true;

            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc4BKHvvS9dAiVOAEH5jD1vbVE9Ceb1xArQ6wrW19e0bhIbaZ4K5mC8SLMNhSbN85LwcsE6rhwFuT9wwVLWO7Htcrzo0ymTnG6aIrPg7BVQNgHhRAAgxvCgBcQ5QxzCcPcJAExxy4rA+yDrrqpHE6is3FTgz7/HSUHHJE5zqGKxdTdlg+33LHoqDWH0w3ftFzC2PguVPH02a9Fq4MkbYCyA/aO9FLXR03y6qK8HuEQFnHddQqhNs/2PjbPb7kYY5AZyGpqIFMYsFlO1JaqZh/nXUNcS/oM63Cl7nuInwU/4Jx9zGSrH9FqTeClqeyJLS5hn/kNGeQZDHOCzeowOzVvsCApkoQJXS2WBzD7fmCRjJ110sPrgIiB+D+3pESmsU808rSa4QEwEBnVGJEq4UmyV5Ev8oSZpXgVFCpxmHq/78fbFAAcX3JhbejQWdaMahcm4OWkuGkdT3zhxgMomO28f1dUUIXsfx9NwJ14Du8afJIz+gDs3r6Ktb5Q8g6PDSzZ8mMgwKvP7rydHgjOe4yAR8N3KpqFLnokxCEOcvNuQiv3LhQ0agFuFcWMmHP+GmVgpJQRqv1rueufONFaKsaPSn9q0Od6CjmEVE8FRwsrreB479gbe5HNhGeFjMdRjLksFER3nF8XgTOhdzVs/Bixn4P7ZoseNbcJymSqJW8sxQ== cardno:13 338 635"
          ];
        };
      })
    ];
  };

  build = sys.config.system.build;
in 
{
  # deployment.targetHost = "1.2.3.4";
  deployment.targetEnv = "libvirtd";
  deployment.libvirtd.headless = true;

  # iPXE Boot server 
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true;
    # kernel = "https://boot.netboot.xyz";

    mode = "boot";
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";
    debug = true;
  };
}

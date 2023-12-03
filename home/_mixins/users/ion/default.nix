{ config, lib, hostname, pkgs, username, ... }: {
  home = {
    file.".face".source = ./face.png;
    file.".ssh/id_rsa_priv_yubikey.pub".source = ./id_rsa_priv_yubikey.pub;
    # file.".ssh/authorized_keys".source = ./id_rsa_priv_yubikey.pub;
    file.".ssh/config".text = "
      Host *
        CanonicalizeHostname yes
        CanonicalizeMaxDots 0
        CanonicalizeFallbackLocal no
        StrictHostKeyChecking no
        CanonicalDomains n0de.biz lan
        HashKnownHosts no
        IdentitiesOnly yes
        ForwardAgent yes
        ControlMaster auto
        ControlPersist 30m
        ServerAliveInterval 20
        ServerAliveCountMax 2
        AddKeysToAgent yes
        ControlPath ~/.ssh/sessions/%C
        PubkeyAcceptedKeyTypes +ssh-rsa
        IdentityFile ~/.ssh/id_rsa_priv_yubikey.pub

      Host git.n0de.biz
        ProxyCommand /usr/bin/cloudflared access ssh --hostname %h

      Host ssh.n0de.biz
        ProxyCommand /usr/bin/cloudflared access ssh --hostname %h
        User daniel

      Host home
        User daniel
        Port 2222
        HostName 192.168.1.101

      Host xeus
        User daniel
        Port 22
        HostName 192.168.1.110

      Host homenet
        User root
        Port 22
        HostKeyAlgorithms +ssh-rsa
        PreferredAuthentications password
        PubkeyAuthentication no
        HostName 192.168.1.1

      Host terro
        User ion
        Port 22
        HostKeyAlgorithms +ssh-rsa
        PreferredAuthentications password
        PubkeyAuthentication no
        HostName 192.168.1.101

      Host bean
        User ion
        Port 22
        HostKeyAlgorithms +ssh-rsa
        PreferredAuthentications password
        PubkeyAuthentication no
        HostName 192.168.1.107

      Host homeassistant
        User hassio
        Port 22
        PreferredAuthentications password
        PubkeyAuthentication no
        HostName homeassistant.lan

      Host github.com
        User git
        IdentitiesOnly yes
        ForwardAgent no

      Host gitlab.n0de.biz
        Port 2222
        User git
        IdentitiesOnly yes
        ForwardAgent no
    ";
    # A Modern Unix experience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages = with pkgs; [
      asciinema # Terminal recorder
      black # Code format Python
      bmon # Modern Unix `iftop`
      breezy # Terminal bzr client
      butler # Terminal Itch.io API client
      chafa # Terminal image viewer
      chroma # Code syntax highlighter
      clinfo # Terminal OpenCL info
      curlie # Terminal HTTP client
      dconf2nix # Nix code from Dconf files
      debootstrap # Terminal Debian installer
      diffr # Modern Unix `diff`
      difftastic # Modern Unix `diff`
      dogdns # Modern Unix `dig`
      dua # Modern Unix `du`
      duf # Modern Unix `df`
      du-dust # Modern Unix `du`
      entr # Modern Unix `watch`
      fast-cli # Terminal fast.com
      fd # Modern Unix `find`
      fish
      glow # Terminal Markdown renderer
      gping # Modern Unix `ping`
      hexyl # Modern Unix `hexedit`
      httpie # Terminal HTTP client
      hyperfine # Terminal benchmarking
      iperf3 # Terminal network benchmarking
      iw # Terminal WiFi info
      jpegoptim # Terminal JPEG optimizer
      jiq # Modern Unix `jq`
      lazygit # Terminal Git client
      libva-utils # Terminal VAAPI info
      lurk # Modern Unix `strace`
      mdp # Terminal Markdown presenter
      moar # Modern Unix `less`
      mtr # Modern Unix `traceroute`
      netdiscover # Modern Unix `arp`
      nethogs # Modern Unix `iftop`
      nixpkgs-review # Nix code review
      nodePackages.prettier # Code format
      nurl # Nix URL fetcher
      nyancat # Terminal rainbow spewing feline
      optipng # Terminal PNG optimizer
      procs # Modern Unix `ps`
      python310Packages.gpustat # Terminal GPU info
      quilt # Terminal patch manager
      ripgrep # Modern Unix `grep`
      rustfmt # Code format Rust
      shellcheck # Code lint Shell
      shfmt # Code format Shell
      speedtest-go # Terminal speedtest.net
      tldr # Modern Unix `man`
      tokei # Modern Unix `wc` for code
      vdpauinfo # Terminal VDPAU info
      wavemon # Terminal WiFi monitor
      yq-go # Terminal `jq` for YAML
      yubikey-manager
      # Fonts
      fira-code
      fira-go
      victor-mono
      joypixels
      font-awesome
      liberation_ttf
      noto-fonts-emoji
      source-serif
      ubuntu_font_family
      work-sans
    ];
    sessionVariables = {
      PAGER = "moar";
      EDITOR = "nvim";
    };
  };
  programs = {
    gpg = {
      enable = true;
      publicKeys = [{
        source = ./gpg.pub;
        trust = "ultimate";
      }];
      # scdaemonSettings = {
      #   disable-ccid = true;
      #   pcsc-shared = true;
      # };
    };
    git = {
      userEmail = "ion@n0de.biz";
      userName = "ion";
      signing = {
        key = "A239E341B9CB8257";
        signByDefault = true;
      };
      aliases = {
        squash-all = "!f(){ git reset $(git commit-tree HEAD^{tree} \"$@\");};f";
      };
    };
    lazygit = {
      enable = true;
      settings = {
       gui.theme = {
          lightTheme = false;
          activeBorderColor = [ "blue" "bold" ];
          inactiveBorderColor = [ "black" ];
          selectedLineBgColor = [ "default" ];
        };
      };
    };
  };

  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.ssh/sessions 0755 ${username} users - -"
  ];
}

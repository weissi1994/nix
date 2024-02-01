{ config, hostname, pkgs, lib, ... }:
{
  home.file.".config/greeter.sh".source = ./files/greeter.sh;

  home.packages = with pkgs; [
    figlet # For greeter script
    cava   # for cli equealizer #unixporn
    unstable.eza    # nice ls
  ];

  programs.fish = {
    enable = true;
    loginShellInit = builtins.readFile ./files/fish/config.fish;
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
    shellAliases = {
      l = "exa -lahF --color=always --icons --sort=size --group-directories-first";
      ls = "exa -lhF --color=always --icons --sort=size --group-directories-first";
      lst = "exa -lahFT --color=always --icons --sort=size --group-directories-first";
      nt = "vim \"+ObsidianWorkspace Private\" +ObsidianToday ~/notes/TODO.md";

      trip = "sudo trip --tui-theme-colors settings-dialog-bg-color=Black,help-dialog-bg-color=Black";

      vimup = "nvim --headless \"+Lazy! update\" +qa";
      nvim = "nvim -u ~/.config/nvim/init.lua";
      vim = "nvim";
      lg = "lazygit";
      ag = "rg";
      ufwlog = "journalctl -k | grep \"IN=.*OUT=.*\" | less";
      sshold = "ssh -c 3des-cbc,aes256-cbc -oKexAlgorithms=+diffie-hellman-group1-sha1 ";
      colour = "grc -es --colour=auto";
      as = "colour as";
      configure = "colour ./configure";
      diff = "colour diff";
      docker = "colour docker";
      gcc = "colour gcc";
      stat = "colour stat";
      head = "colour head";
      ifconfig = "colour ifconfig";
      ld = "colour ld";
      make = "colour make";
      mount = "colour mount";
      netstat = "colour netstat";
      ping = "colour ping";
      ps = "colour ps";
      tcpdump = "sudo grc -es --colour=on tcpdump";
      ss = "colour ss";
      tail = "colour tail";
      traceroute = "colour traceroute";
      kernlog = "sudo journalctl -xe -k -b | less";
      syslog = "sudo journalctl -xef";

      # Git aliases
      gb = "git branch";
      gbc = "git checkout -b";
      gbs = "git show-branch";
      gbS = "git show-branch -a";
      gc = "git commit --verbose";
      gca = "git commit --verbose --all";
      gcm = "g3l -m";
      gcf = "git commit --amend --reuse-message HEAD";
      gcF = "git commit --verbose --amend";
      gcR = "git reset \"HEAD^\"";
      gcs = "git show";
      gdi = "git status --porcelain --short --ignored | sed -n \"s/^!! //p\"";
      gia = "git add";
      giA = "git add --patch";
      giu = "git add --update";
      gid = "git diff --no-ext-diff --cached";
      giD = "git diff --no-ext-diff --cached --word-diff";
      gir = "git reset";
      giR = "git reset --patch";
      gix = "git rm -r --cached";
      giX = "git rm -rf --cached";
      gld = "ydiff -ls -w0 --wrap";
      glc = "git shortlog --summary --numbered";
      gm = "git merge";
      gmc = "git merge --continue";
      gmC = "git merge --no-commit";
      gmF = "git merge --no-ff";
      gma = "git merge --abort";
      gmt = "git mergetool";
      gp = "git push";
      gptst = "git push -o ci.variable=\"ALWAYS_RUN_TEST=true\"";
      gpmr = "push -o merge_request.create -o merge_request.target=development";
      gpmrm = "push -o merge_request.create -o merge_request.target=development -o merge_request.merge_when_pipeline_succeeds";
      gpf = "git push --force";
      gpa = "git push --all";
      gpA = "git push --all && git push --tags";
      gpc = "git push --set-upstream origin \"$(git-branch-current 2> /dev/null)\"";
      gpp = "git pull origin \"$(git-branch-current 2> /dev/null)\" && git push origin \"$(git-branch-current 2> /dev/null)\"";
      gwd = "git diff --no-ext-diff";
      gwD = "git diff --no-ext-diff --word-diff";
      gwr = "git reset --soft";
      gwR = "git reset --hard";
      gwc = "git clean -n";
      gwC = "git clean -f";
      gwx = "git rm -r";
      gwX = "git rm -rf";

      wgup = "wg-quick up ~/.config/wireguard/wg-home.conf";
      wgdown = "wg-quick down ~/.config/wireguard/wg-home.conf";
    };
    functions = {
      # Note taking
      n = {
        body = ''
          set filename (if set -q $argv[1]; echo $argv[1]; else; echo 'TODO'; end)
          nvim "+ObsidianWorkspace Private" ~/notes/$filename.md $argv[2..-1]
        '';
      };

      # SSH with kitty helpers
      s = {
        wraps = "ssh";
        body = "kitten ssh $argv";
      };

      restart-dockers = {
        body = ''
        sudo systemctl list-units --output json | jq -r '.[]|select(.unit | startswith("podman-")) | select(.unit | startswith("podman-prune") | not) | select(.unit | startswith("podman-gitlab") | not) | select(.unit | startswith("podman-traefik") | not) | .unit' | xargs sudo systemctl restart
        sudo systemctl restart podman-gitlab.service;
        sudo systemctl restart podman-traefik.service;
        '';
      };

      # Repo helper
      sync-dotfiles = {
        body = ''
          if test -d ~/dev/nix
            cd ~/dev/nix
            git pull
            cd -
          else
            git clone git@gitlab.n0de.biz:daniel/nix.git ~/dev/nix
          end
        '';
      };
      sync-keystore = {
        body = ''
          gopass sync
          if test ! $status -eq 0
            gopass clone git@gitlab.n0de.biz:daniel/keystore.git
            gopass-jsonapi configure
          end
          gopass cat ssh/id_ed25519_sk > ~/.ssh/id_ed25519_sk
          gopass cat ssh/id_ed25519_sk_backup > ~/.ssh/id_ed25519_sk_backup
        '';
      };
      sync-repos = "sync-dotfiles; sync-keystore";
      upd = "sudo nixos-rebuild switch --flake \"git+https://gitlab.n0de.biz/daniel/nix?ref=main#${hostname}\" --refresh";
      upd-remote = "nixos-rebuild switch --flake \"git+https://gitlab.n0de.biz/daniel/nix?ref=main#$argv[1]\" --target-host \"ion@$argv[1]\" --use-remote-sudo --refresh";

      # Yubikey helper
      ykcode = "ykman --device 13338635  oath accounts code $argv";

      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
    };
  };
}

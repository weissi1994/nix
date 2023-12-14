{ config, desktop, roles, hostname, inputs, lib, modulesPath, outputs, pkgs, platform, stateVersion, username, os_disk, os_layout, data_disks, data_layout, ... }:
{
  # TODO: Generate rules from installed packages
  services.opensnitch = {
    rules = {
      podman = {
        name = "allow-podman";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.conmon}/bin/conmon";
        };
      };
      cloudflared = {
        name = "allow-cloudflared";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.cloudflared}/bin/cloudflared";
        };
      };
    };
  };
}

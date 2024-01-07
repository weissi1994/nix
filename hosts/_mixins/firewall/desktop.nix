{ config, desktop, roles, hostname, inputs, lib, modulesPath, outputs, pkgs, platform, stateVersion, username, os_disk, os_layout, data_disks, data_layout, ... }:
{
  services.opensnitch = {
    rules = {
      google-chrome = {
        "name" = "allow-chrome";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "process.path";
          "data" = "${lib.getBin pkgs.unstable.google-chrome}/share/google/chrome/chrome";
        };
      };
      spotify = {
        "name" = "allow-spotfy";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "process.path";
          "data" = "${lib.getBin pkgs.spotify}/share/spotify/.spotify-wrapped";
        };
      };
      trip = {
        "name" = "allow-trip";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "process.path";
          "data" = "${lib.getBin pkgs.trippy}/bin/trip";
        };
      };
      telegram = {
        "name" = "allow-telegram";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "process.path";
          "data" = "${lib.getBin pkgs.telegram-desktop}/bin/.telegram-desktop-wrapped";
        };
      };
      avahi = {
        "name" = "allow-avahi";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "process.path";
          "data" = "${lib.getBin pkgs.avahi}/bin/avahi-daemon";
        };
      };
    };
  };
}

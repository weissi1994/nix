{ lib, pkgs, ... }:
{
  services.opensnitch = {
    rules = {
      dns = {
        "name" = "allow-dns";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "53";
        };
      };
      https = {
        "name" = "allow-https";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "443";
        };
      };
    };
  };
}

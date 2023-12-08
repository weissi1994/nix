{ config, hostname, inputs, lib, outputs, pkgs, data_disks, ... }:
{
  imports = [
    # Disko
    ./disks.nix
    inputs.disko.nixosModules.disko
    {
      disko.devices.disk.data_1.device = lib.mkForce builtins.index data_disks 0;
      disko.devices.disk.data_2.device = lib.mkForce builtins.index data_disks 1;
    }
  ];
}

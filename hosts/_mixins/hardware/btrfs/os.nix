{ config, hostname, inputs, lib, outputs, pkgs, os_disk, ... }:
{
  imports = [
    # Disko
    ./disks.nix
    inputs.disko.nixosModules.disko 
    { disko.devices.disk.os.device = lib.mkForce "${os_disk}"; }
  ];
}

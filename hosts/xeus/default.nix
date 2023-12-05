{ config, inputs, lib, pkgs, platform, hostname, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/services/pipewire.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.swraid = {
    enable = true;
    mdadmConf = ''
# mdadm configuration file
#
# mdadm will function properly without the use of a configuration file,
# but this file is useful for keeping track of arrays and member disks.
# In general, a mdadm.conf file is created, and updated, after arrays
# are created. This is the opposite behavior of /etc/raidtab which is
# created prior to array construction.
#
#
# the config file takes two types of lines:
#
#	DEVICE lines specify a list of devices of where to look for
#	 potential member disks
#
#	ARRAY lines specify information about how to identify arrays so
#	 so that they can be activated
#


# You can have more than one device line and use wild cards. The first 
# example includes SCSI the first partition of SCSI disks /dev/sdb,
# /dev/sdc, /dev/sdd, /dev/sdj, /dev/sdk, and /dev/sdl. The second 
# line looks for array slices on IDE disks.
#
#DEVICE /dev/sd[bcdjkl]1
#DEVICE /dev/hda1 /dev/hdb1
#
# The designation "partitions" will scan all partitions found in
# /proc/partitions
DEVICE partitions


# ARRAY lines specify an array to assemble and a method of identification.
# Arrays can currently be identified by using a UUID, superblock minor number,
# or a listing of devices.
#
#	super-minor is usually the minor number of the metadevice
#	UUID is the Universally Unique Identifier for the array
# Each can be obtained using
#
# 	mdadm -D <md>
#
# To capture the UUIDs for all your RAID arrays to this file, run these:
#    to get a list of running arrays:
#    # mdadm -D --scan >>/etc/mdadm.conf
#    to get a list from superblocks:
#    # mdadm -E --scan >>/etc/mdadm.conf
#
#ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
#ARRAY /dev/md1 super-minor=1
#ARRAY /dev/md2 devices=/dev/hda1,/dev/hdb1
#
# ARRAY lines can also specify a "spare-group" for each array.  mdadm --monitor
# will then move a spare between arrays in a spare-group if one array has a
# failed drive but no spare
#ARRAY /dev/md4 uuid=b23f3c6d:aec43a9f:fd65db85:369432df spare-group=group1
#ARRAY /dev/md5 uuid=19464854:03f71b1b:e0df2edd:246cc977 spare-group=group1
#

ARRAY /dev/md/0 metadata=1.2 name=xeus:0 UUID=0239ddb6:f3b2e5e2:0bfe9532:875ff802

# When used in --follow (aka --monitor) mode, mdadm needs a
# mail address and/or a program.  To start mdadm's monitor mode, enable
# mdadm.service in systemd.
#
# If the lines are not found, mdadm will exit quietly
MAILADDR ion@n0de.biz
PROGRAM /run/current-system/sw/sbin/handle-mdadm-events
    '';
  };

  fileSystems."/srv" =
  { device = "/dev/md0";
    fsType = "ext4";
    options = [ "rw" "relatime" ];
  }; 

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";
}


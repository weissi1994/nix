{ hostname ? "nixos", ... }:
let
  defaultFsOpts = [ "compress=zstd" "noatime" ]; # "noexec" ];
in
{
  disko.devices = {
    disk = {
      os = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "1G";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            # {
            #   name = "swap";
            #   start = "1G";
            #   end = "9G";
            #   part-type = "primary";
            #   content = {
            #     type = "swap";
            #     randomEncryption = true;
            #   };
            # }
            {
              name = "luks";
              start = "1G";
              end = "100%";
              content = {
                type = "luks";
                name = "${hostname}-crypted";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  # keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      # mountOptions = defaultFsOpts;
                    };
                    "@/root" = {
                      mountpoint = "/";
                      mountOptions = defaultFsOpts;
                    };
                    # Mountpoints inferred from subvolume name
                    "@/home" = {
                      mountpoint = "/home";
                      mountOptions = defaultFsOpts;
                    };
                    "@/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "@/log" = {
                      mountpoint = "/var/log";
                      mountOptions = defaultFsOpts;
                    };
                    "@/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "8000M";
                    };
                  };
                };
              };
            }
          ];
        };
      };
    };
  };
}

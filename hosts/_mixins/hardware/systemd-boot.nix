_: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      systemd-boot.consoleMode = "max";
      timeout = 10;
    };
  };
}

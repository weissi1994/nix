{ config, lib, pkgs, ... }:
{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-validation-layers 
      libvdpau-va-gl
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "nouveau" ];
  # services.xserver.videoDrivers = ["nvidia"];
  # boot.kernelParams = ["nvidia_drm.fbdev=1"];


  # environment.variables.VDPAU_DRIVER = "va_gl";
  # environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  programs.sway.extraOptions = ["--unsupported-gpu"];

  # Force wayland when possible 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # might fix flickering in yt fullscreen
  environment.sessionVariables.WLR_RENDERER = "vulkan"; 

  # Fix disappearing cursor on Hyprland / Sway
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; 

  # electron apps
  # environment.sessionVariables.GBM_BACKEND = "nvidia-drm";
  # environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;
    nvidiaPersistenced = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}

{config, username, pkgs, ...}:
{
  # Touchpad
  services = {
    xserver = {
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
        touchpad.middleEmulation = true;
        touchpad.tapping = true;
      };
    };
  };
}

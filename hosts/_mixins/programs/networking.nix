{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    asn
    wireshark
    wireshark-cli
    termshark
    dog
    nmap
    ipcalc
  ];
}

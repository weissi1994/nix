{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    asn
    wireshark
    wireshark-cli
    termshark
    dog
    nmap
    trippy
    gping
    ipcalc
    certigo
    dhcpdump
  ];
}

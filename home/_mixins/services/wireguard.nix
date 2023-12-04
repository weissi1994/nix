{ config, desktop, hostname, lib, pkgs, username, ... }: {
  home.file.".config/wireguard/wg-home.conf".text = ''
    # local settings for my computer
    [Interface]
    Address = 10.11.14.10/32
    DNS = 10.11.14.1, n0de.biz, home
    PostUp = resolvectl domain %i ~n0de.biz

    PostUp = wg set %i private-key <(sudo -u justin gopass show -o wireguard/private-keys/%i)
    PostUp = wg set %i peer vvLaDgLk2BhnZXxma6oQ8BJ5rEagQ+agSCVccAu2I1Q= preshared-key <(sudo -u justin gopass show -o wireguard/preshared-keys/%i/home)

    # remote settings for Home
    [Peer]
    PublicKey = vvLaDgLk2BhnZXxma6oQ8BJ5rEagQ+agSCVccAu2I1Q=
    Endpoint = pub.n0de.biz:51820
    #AllowedIPs = 0.0.0.0/0, ::/0
    AllowedIPs = 192.168.8.0/24, 192.168.1.0/24
  '';
}

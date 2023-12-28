_:
{
  users.users.root = {
    hashedPassword = null;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../../home/_mixins/users/ion/id_ed25519_sk.pub)
      (builtins.readFile ../../../../home/_mixins/users/ion/id_rsa_priv_yubikey.pub)
    ];
  };
}

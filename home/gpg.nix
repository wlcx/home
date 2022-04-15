{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./wlcx_gpg_public.asc;
        trust = "ultimate";
      }
      {
        source = ./yubikey_pgp_public.asc;
        trust = "ultimate";
      }
    ];
    # make yubikey work on macos? lolgpg
    # https://github.com/NixOS/nixpkgs/issues/155629
    scdaemonSettings = { disable-ccid = true; };
  };
}
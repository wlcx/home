{pkgs, lib, ...}: {
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
        source = ./gpg_yubikey_5.asc;
        trust = "ultimate";
      }
      {
        source = ./gpg_yubikey_5c.asc;
        trust = "ultimate";
      }
    ];
    # make yubikey work on macos? lolgpg
    # https://github.com/NixOS/nixpkgs/issues/155629
    scdaemonSettings = (lib.optionalAttrs pkgs.stdenv.isDarwin {disable-ccid = true;});
  };

  # Shouldn't have an effect on macos, on linux we need to specify a pinentry
  services.gpg-agent = {
    enable = !pkgs.stdenv.isDarwin;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-all;
  };
}

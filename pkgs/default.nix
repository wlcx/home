# TODO: auto import everything
{ pkgs, ... }: {
  qrclip = pkgs.callPackage ./qrclip { };
  zbar = pkgs.callPackage ./zbar { };
  yubikey-manager = pkgs.callPackage ./yubikey-manager { };
}

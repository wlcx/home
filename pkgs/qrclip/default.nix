{
  pkgs,
  lib,
  stdenv,
}:
let
  zbar = pkgs.zbar.override { enableVideo = false; };
in
(pkgs.writeShellScriptBin "qrclip" ''
  set -eo pipefail
  ${pkgs.pngpaste}/bin/pngpaste - | ${zbar}/bin/zbarimg --raw -q1 -
'')
// {
  meta.platforms = lib.platforms.darwin;
}

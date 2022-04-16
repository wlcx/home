{ pkgs }:
let zbar = pkgs.mypkgs.zbar.override { enableVideo = false; };
in pkgs.writeShellScriptBin "qrclip" ''
  set -eo pipefail
  ${pkgs.pngpaste}/bin/pngpaste - | ${zbar}/bin/zbarimg --raw -q1 -
''

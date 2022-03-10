{ pkgs }:
pkgs.writeShellScriptBin "qrclip" ''
  set -eo pipefail
  ${pkgs.pngpaste}/bin/pngpaste - | ${pkgs.zbar}/bin/zbarimg --raw -q1 -
''

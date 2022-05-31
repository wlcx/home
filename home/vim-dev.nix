{ pkgs, lib, system, ... }:
let
  vim-vue-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-vue-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "leafOfTree";
      repo = "vim-vue-plugin";
      rev = "b2bb4dd8f6d97909c48bc33937177d4068921a10";
      sha256 = "hstEInKVFra1g47p6wKA7uCDBwXpoZ3iJz/ZaRjB34Q=";
    };
  };
in {
  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      # More fancy shit
      nvim-treesitter
      # Language stuff
      nvim-lspconfig
      trouble-nvim
      rust-vim
      vim-terraform
      vim-protobuf
      vim-javascript
      vim-vue-plugin
      kotlin-vim
    ]
    # delve is unsupported on aarch64-linux and golangci-lint is broken on x86_64-darwin
    # (see https://github.com/NixOS/nixpkgs/issues/168984).
    ++ lib.optionals (system != "aarch64-linux" && system != "x86_64-darwin") [ vim-go ];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
    EOF
  '';
}

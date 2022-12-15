{
  pkgs,
  lib,
  system,
  ...
}: let
  vim-vue-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-vue-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "leafOfTree";
      repo = "vim-vue-plugin";
      rev = "b2bb4dd8f6d97909c48bc33937177d4068921a10";
      sha256 = "eBfMxt5AaSCHzU7PFp7eWZhGY8l3EqeMLrU0ntB6eLA=";
    };
  };
in {
  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      # More fancy shit
      nvim-treesitter
      trouble-nvim
      # Language server/completions 
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      # Language specific
      rust-vim
      vim-terraform
      vim-protobuf
      vim-javascript
      vim-vue-plugin
      dhall-vim
      kotlin-vim
      Jenkinsfile-vim-syntax
    ]
    # delve is unsupported on aarch64-linux and golangci-lint is broken on darwin
    # (see https://github.com/NixOS/nixpkgs/issues/168984).
    ++ lib.optionals (system != "aarch64-linux" && !pkgs.stdenv.isDarwin) [vim-go];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
        ${builtins.readFile ./lspconfig-volar.lua}
    EOF
  '';
}

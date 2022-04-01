# This module sets up a "full" neovim install with plugins and unicorns. It
# also makes neovim the default editor and aliases vim to nvim.
{ pkgs, lib, strings, ... }: {
  home.sessionVariables = { "EDITOR" = "nvim"; };
  home.packages = with pkgs; [ rnix-lsp ripgrep ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Basic stuff
      vim-sensible
      vim-noctu # 16color colorscheme
      gruvbox-nvim
      fzfWrapper # The basic "built in" fzf stuff
      fzf-vim # The fancier opt in fzf stuff
      # The only language plugin you always need... because if it's running nixos you
      # *will* be editing nix files!
      vim-nix
      # Git stuff
      fugitive
      vim-gitgutter
      # More stuff idk
      emmet-vim
    ];
    extraConfig = ''
      lua <<EOF
        ${builtins.readFile ./init.lua}
      EOF
    '';
  };
}

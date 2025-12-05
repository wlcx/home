# Vim with some niceties. If you're spending any time in vim you'll want this.
# For a full-fat vim with all the bells and whistles, see vim-dev
{
  pkgs,
  lib,
  ...
}:
{
  home.sessionVariables.EDITOR = lib.mkForce "nvim";
  home.packages = with pkgs; [ ripgrep ];
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
      vim-sleuth # guess whitespace settings from file
    ];
    extraConfig = ''
      lua <<EOF
        ${builtins.readFile ./init.lua}
      EOF
    '';
  };
}

{
  pkgs,
  ...
}:
let
  packages = pkgs.callPackage ./packages.nix { };
in
{
  home.packages = packages.all;
  home.sessionVariables = {
    EDITOR = "vim"; # is overriden to nvim in vim.nix if needed
    WORDCHARS = "\${WORDCHARS//[\\/.=]/}"; # ctrl-w on paths without make angery
  };
  /*
    # For some reason this doesn't play nice when using home manager config from inside
    # a nixos configuration.
    nix = {
      enable = true;
      package = pkgs.nix;
      settings.experimental-features = "nix-command flakes";
      settings.max-jobs = "auto"; # Gotta go fast (build derivations in parallel)
    };
  */
  programs = {
    home-manager.enable = true;

    # Shell and env-y stuff
    zsh = {
      enable = true;
      autocd = true;
      history = rec {
        extended = true;
        size = 100000;
        save = size;
        ignoreDups = true;
      };
      shellAliases = {
        g = "git";
        cat = "bat";
        ip = "ip --color=auto";
        ns = "nix shell nixpkgs#";
        hm = ''home-manager --flake ".#$(hostname -s)"'';
        hms = ''home-manager --flake ".#$(hostname -s)" switch'';
        nr = "nixos-rebuild --sudo --flake '.#'";
        nrs = "nixos-rebuild --sudo --flake '.#' switch";
        da = "direnv allow .";
        dr = "direnv reload";
      };
      # Extra .zshrc stuff
      initContent = ''
        # zstyle ':completion:*' menu select # fancy interactive autocomplete
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # tabcomplete lower to upper case

        # git already sorts output non-alphabetically, which we want to preserve
        zstyle ':completion:*:git-checkout:*' sort false

        # Don't honk at me constantly
        unsetopt beep
      '';
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
        {
          name = "zsh-z";
          src = "${pkgs.zsh-z}/share/zsh-z";
        }
      ];
    };

    eza.enable = true;

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        direnv.disabled = false;
        format = "$all";
        username.format = "[$user]($style) ";
        hostname.format = "[$hostname]($style) ";
        directory = {
          truncation_length = -1;
        };
        git_branch.format = "[$symbol$branch]($style) ";
        python.symbol = "py ";
        nodejs.symbol = "js ";
        nix_shell.symbol = "nix ";
        rust.symbol = "rs ";
        direnv.symbol = "de ";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.warn_timeout = "30s";
    };

    fzf = {
      enable = true;
      defaultCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    };

    ssh = {
      enable = true;
      includes = [ "~/.ssh/config.local" ];
      matchBlocks."*" = {
        user = "samw";
        serverAliveInterval = 30;
        serverAliveCountMax = 10;
      };
    };
  };
}

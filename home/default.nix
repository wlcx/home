{
  pkgs,
  lib,
  ...
}: let
  packages = pkgs.callPackage ./packages.nix {};
in {
  home.packages = packages.all;
  home.sessionVariables = {
    "PATH" = "$HOME/.local/bin:$PATH";
    "EDITOR" = "vim";
    "WORDCHARS" = "\${WORDCHARS//[\\/.=]/}"; # ctrl-w on paths without make angery
  };
  nix = {
    enable = true;
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    settings.max-jobs = "auto"; # Gotta go fast (build derivations in parallel)
  };
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
        hmswitch = ''home-manager switch --flake ".#$(hostname -s)"'';
        nrswitch = "nixos-rebuild --use-remote-sudo switch --flake '.#'";
        da = "direnv allow .";
        dr = "direnv reload";
      };
      # Extra .zshrc stuff
      initExtra = ''
        # zstyle ':completion:*' menu select # fancy interactive autocomplete
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # tabcomplete lower to upper case

        # git already sorts output non-alphabetically, which we want to preserve
        zstyle ':completion:*:git-checkout:*' sort false

        # Don't honk at me constantly
        unsetopt beep
      '';
      enableSyntaxHighlighting = true;
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

    exa = {
      enable = true;
      enableAliases = true;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username$hostname$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$docker_context$golang$kotlin$nodejs$python$rust$terraform$nix_shell$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$status$shell$character";
        username.format = "[$user]($style) ";
        hostname.format = "[$hostname]($style) ";
        directory = {truncation_length = -1;};
        git_branch.format = "[$symbol$branch]($style) ";
        python.format = "[py \${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
        nodejs.format = "[js ($version )]($style)";
        nix_shell.format = "[nix $state( \\($name\\))]($style) ";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
    };

    ssh = {
      enable = true;
      includes = ["~/.ssh/config.local"];
      serverAliveInterval = 30;
      serverAliveCountMax = 10;
      matchBlocks."*".user = "samw";
    };
  };
}

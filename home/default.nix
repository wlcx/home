{ pkgs, ... }:

let mypkgs = (import ../modules/pkgs.nix { inherit pkgs; });
in {
  home.packages = mypkgs.all;
  home.sessionVariables = {
    "PATH" = "$HOME/.local/bin:$PATH";
    "EDITOR" = "vim";
    "WORDCHARS" = "\${WORDCHARS//[\\/.]/}"; # ctrl-w on paths without make angery
  };
  programs = {
    home-manager.enable = true;

    # Shell and env-y stuff
    zsh = {
      enable = true;
      shellAliases = {
        g = "git";
        cat = "bat";
        hmswitch = ''home-manager switch --flake ".#$(hostname -s)"'';
        nrswitch = "sudo nixos-rebuild switch --flake '.#'";
      };
      # Extra .zshrc stuff
      initExtra = ''
        # zstyle ':completion:*' menu select # fancy interactive autocomplete
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # tabcomplete lower to upper case
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
        format =
          "$username$hostname$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$docker_context$golang$kotlin$nodejs$python$rust$terraform$nix_shell$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$status$shell$character";
        username.format = "[$user]($style) ";
        hostname.format = "[$hostname]($style) ";
        directory = { truncation_length = -1; };
        git_branch.format = "[$symbol$branch]($style) ";
        python.format = "[py \${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
        nodejs.format = "[js ($version )]($style)";
        nix_shell.format = "[nix $state( \\($name\\))]($style) ";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
    };

    fzf.enable = true;

    ssh = {
      enable = true;
      includes = [ "~/.ssh/config.local" ];
    };

  };
}

{ config, pkgs, ... }:

let mypkgs = (import ./modules/pkgs.nix { inherit pkgs; });
in {
  home.packages = mypkgs.all;
  home.sessionVariables = {
    "EDITOR" = "nvim";
    "WORDCHARS" = "\${WORDCHARS/\\/}"; # ctrl-w on paths without make angery
  };
  programs = {
    home-manager.enable = true;

    # Shell and env-y stuff
    zsh = {
      enable = true;
      shellAliases = {
        g = "git";
        cat = "bat";
        vim = "nvim";
        hmswitch = ''home-manager switch --flake ".#$(hostname -s)"'';
        nrswitch = "sudo nixos-rebuild switch --flake '.#'";
      };

      plugins = [{
        name = "zsh-z";
        file = "share/zsh-z/zsh-z.plugin.zsh";
        src = pkgs.zsh-z;
      }];
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
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
    };

    fzf.enable = true;

    # Tools
    git = {
      enable = true;
      userName = "Sam Willcocks";
      userEmail = "sam@wlcx.cc";

      delta = { # Better diffs
        enable = true;
        options = { line-numbers = true; };
      };

      aliases = {
        a = "add";
        ap = "add -p";
        c = "commit";
        can = "commit --amend --no-edit";
        cm = "commit -m";
        co = "checkout";
        d = "diff";
        dc = "diff --cached";
        l = "log";
        lp = "log --patch";
        r = "rebase";
        rc = "rebase --continue";
        ra = "rebase --autostash";
        rai = "rebase --autostash --interactive";
        st = "status";

        gone = ''
          ! "git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | a
                 │ wk '$2 == \"[gone]\" {print $1}' | xargs -r git branch -D"'';
      };
      extraConfig = {
        branch.sort = "-committerdate";
        log.showSignature = true;
        push.default = "current";
        include.path = "~/.gitconfig.local";
      };
    };
  };
}

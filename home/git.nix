{...}: {
  programs.git = {
    enable = true;
    userName = "Sam Willcocks";
    userEmail = "sam@wlcx.cc";

    delta = {
      # Better diffs
      enable = true;
      options = {line-numbers = true;};
    };

    aliases = {
      a = "add";
      ap = "add -p";
      c = "commit";
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dc = "diff --cached";
      l = "log";
      lp = "log --patch";
      p = "push";
      pf = "push --force-with-lease";
      r = "rebase";
      rc = "rebase --continue";
      ra = "rebase --autostash";
      rai = "rebase --autostash --interactive";
      rs = "restore --staged";
      st = "status";
      sw = "switch";
      swc = "switch --create";

      gone = ''
        ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' │ awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
    };
    extraConfig = {
      branch.sort = "-committerdate";
      push.default = "current";
      init.defaultBranch = "main";
    };
    includes = [
      # Always include local gitconfig if it's there
      {
        path = "~/.gitconfig.local";
      }
      # Include work gitconfig if we're somewhere in ~/work
      {
        path = "~/.gitconfig.work";
        condition = "gitdir:~/work/";
      }
    ];
  };
}

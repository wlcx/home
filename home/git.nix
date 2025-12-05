{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-open
    tea
  ];
  programs.delta = {
    # Better diffs
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Sam Willcocks";
      user.email = "sam@wlcx.cc";
      alias = {
        a = "add";
        ap = "add -p";
        br = "branch";
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

        gone = ''! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' │ awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
      };
      branch.sort = "-committerdate";
      push.default = "current";
      init.defaultBranch = "main";
      merge = {
        conflictStyle = "diff3";
        mergiraf = {
          name = "mergiraf";
          driver = "${pkgs.mergiraf}/bin/mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
        };
      };
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

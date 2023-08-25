{pkgs}:
with pkgs; rec {
  # The stuff you want installed everywhere. The necessities.
  base = [
    bat # cat replacement, aliased to cat in home-manager
    file
    git
    htop
    lsof
    mosh
    tmux
    unzip
    vim
    wget
  ];

  # Networking shit
  net = [dig iperf3 nmap socat tcpdump whois];

  # development tools
  dev = [jq nixfmt gh glab hexyl];

  all = base ++ net ++ dev;
}

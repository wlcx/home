{ pkgs }:
with pkgs;
rec {
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
    helix
  ];

  # Networking shit
  net = [
    dig
    iperf3
    mtr
    nmap
    socat
    tcpdump
  ];

  # development tools
  dev = [
    jq
    nixfmt-rfc-style
    gh
    glab
    hexyl
    attic-client
  ];

  all = base ++ net ++ dev;
}

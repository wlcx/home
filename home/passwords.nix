{ pkgs, ... }: {
  home.packages = with pkgs; [ yubikey-manager ];
  programs.password-store = {
    enable = true;
    settings = { PASSWORD_STORE_DIR = "$HOME/.password-store"; };
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
  programs.zsh.shellAliases = {
    p = "pass";
    pc = "pass -c";
  };
}

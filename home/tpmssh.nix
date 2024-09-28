# Enable tpm-ssh-agent in a systemd user service
{pkgs, config, lib, ...}: {
  home.packages = [ pkgs.ssh-tpm-agent ];
  home.sessionVariables = {
    SSH_AUTH_SOCK = let
      maybeProxy = lib.strings.optionalString config.services.gpg-agent.enableSshSupport "-A $(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
      cmd = "${pkgs.ssh-tpm-agent} --print-socket${maybeProxy}";
    in "$(${cmd})";
    TESTIFICLES = "hello";
  };
  systemd.user.sockets.ssh-tpm-agent = {
    Unit.WantedBy = [ "sockets.target" ];
    Socket = {
      ListenStream = "%t/ssh-tpm-agent.sock";
      SocketMode = "0600";
      Service = "ssh-tpm-agent.service";
    };
  };

  systemd.user.services.ssh-tpm-agent = {
    Unit = {
      Requires = [ "ssh-tpm-agent.socket" ];
      ConditionEnvironment = "!SSH_AGENT_PID";
    };
    Service = {
      Environment = ''
        SSH_AUTH_SOCK="%t/ssh-tpm-agent.sock"
      '';
      ExecStart = "${pkgs.ssh-tpm-agent}";
      PassEnvironment = "SSH_AGENT_PID";
      SuccessExitStatus = 2;
      Type = "simple";
    };
  };
}

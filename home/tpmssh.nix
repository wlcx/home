# Enable tpm-ssh-agent in a systemd user service
{ pkgs, config, ... }:
{
  home.packages = [ pkgs.ssh-tpm-agent ];
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent --print-socket)";
  };
  systemd.user.sockets.ssh-tpm-agent = {
    Install.WantedBy = [ "sockets.target" ];
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
      ExecStart = "${
        pkgs.writeShellScriptBin "start-ssh-tpm-agent" (
          if config.services.gpg-agent.enableSshSupport then
            ''
              ${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent -A $(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
            ''
          else
            ''
              ${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent
            ''
        )
      }/bin/start-ssh-tpm-agent";
      PassEnvironment = "SSH_AGENT_PID";
      SuccessExitStatus = 2;
      Type = "simple";
    };
  };
}

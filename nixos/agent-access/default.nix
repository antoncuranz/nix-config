{ config, lib, pkgs, sshKeys, ... }:

# Read-only shell access for AI agents (debugging / analysis).
#
# The agent user is deliberately unprivileged:
#   - not in wheel, no general sudo, not in the `disk` group
#   - ZFS is readable without root (zfs list, zpool status, ...) but every
#     modifying ioctl requires root or a `zfs allow` delegation
#   - kubernetes access is a read-only ServiceAccount (RBAC lives in the
#     homelab gitops repo: system/agent-access)
#   - every command is logged to the journal with tag `agent-cmd`

let
  cfg = config.agentAccess;
  user = "agent";
  uid = 1100;
  home = "/home/${user}";

  # forced command: log the requested command, then run it
  agentShell = pkgs.writeShellScript "agent-shell" ''
    ${pkgs.util-linux}/bin/logger -t agent-cmd -- "''${SSH_ORIGINAL_COMMAND:-<interactive>}"
    if [ -n "''${SSH_ORIGINAL_COMMAND:-}" ]; then
      exec ${pkgs.bash}/bin/bash -c "$SSH_ORIGINAL_COMMAND"
    else
      exec ${pkgs.bash}/bin/bash -l
    fi
  '';

  # exact read-only commands that need root
  sudoCommands = [
    "/run/current-system/sw/bin/zpool events -v"
    "/run/current-system/sw/bin/smartctl -a /dev/sd[a-z]"
    "/run/current-system/sw/bin/smartctl -a /dev/nvme[0-9]"
    "/run/current-system/sw/bin/smartctl -a /dev/nvme[0-9]n[0-9]"
  ] ++ lib.optional config.kubernetes.iscsi.enable
    "/run/current-system/sw/bin/targetcli ls";

  kubectl = "${pkgs.kubectl}/bin/kubectl";
in
{
  options.agentAccess = {
    enable = lib.mkEnableOption "read-only access for AI agents";

    kubeconfig = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kubernetes.enable;
        description = "Generate ~/.kube/config for the agent from its ServiceAccount token.";
      };
      namespace = lib.mkOption {
        type = lib.types.str;
        default = "agent-access";
      };
      tokenSecret = lib.mkOption {
        type = lib.types.str;
        default = "ai-agent-token";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      users.groups.${user}.gid = uid;
      users.users.${user} = {
        isNormalUser = true;
        inherit uid home;
        group = user;
        extraGroups = [ "systemd-journal" ];
        openssh.authorizedKeys.keys = lib.optional (sshKeys ? agent)
          ''restrict,command="${agentShell}" ${sshKeys.agent}'';
      };

      services.openssh.settings.AllowUsers = [ user ];

      security.sudo.extraRules = [{
        users = [ user ];
        commands = map (command: { inherit command; options = [ "NOPASSWD" ]; }) sudoCommands;
      }];

      environment.systemPackages = with pkgs; [ smartmontools ];

      # keep a runaway agent from hurting the host
      systemd.slices."user-${toString uid}".sliceConfig = {
        MemoryMax = "2G";
        CPUQuota = "100%";
      };
    }

    (lib.mkIf cfg.kubeconfig.enable {
      systemd.services.agent-kubeconfig = {
        description = "Write read-only kubeconfig for the agent user";
        after = [ "k3s.service" ];
        wants = [ "k3s.service" ];
        wantedBy = [ "multi-user.target" ];
        environment.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
        path = [ pkgs.coreutils ];
        serviceConfig.Type = "oneshot";
        script = ''
          set -euo pipefail

          # wait for the API server and for argocd to have created the token
          token=""
          for _ in $(seq 30); do
            token=$(${kubectl} -n ${cfg.kubeconfig.namespace} get secret ${cfg.kubeconfig.tokenSecret} \
              -o jsonpath='{.data.token}' 2>/dev/null | base64 -d || true)
            [ -n "$token" ] && break
            sleep 10
          done
          if [ -z "$token" ]; then
            echo "secret ${cfg.kubeconfig.namespace}/${cfg.kubeconfig.tokenSecret} not available" >&2
            exit 1
          fi

          tmp=$(mktemp)
          trap 'rm -f "$tmp"' EXIT
          export KUBECONFIG="$tmp"
          ${kubectl} config set-cluster serverton \
            --server=https://127.0.0.1:6443 \
            --certificate-authority=/var/lib/rancher/k3s/server/tls/server-ca.crt \
            --embed-certs=true >/dev/null
          ${kubectl} config set-credentials ai-agent --token="$token" >/dev/null
          ${kubectl} config set-context serverton --cluster=serverton --user=ai-agent >/dev/null
          ${kubectl} config use-context serverton >/dev/null

          install -d -m 700 -o ${user} -g ${user} ${home}/.kube
          install -m 600 -o ${user} -g ${user} "$tmp" ${home}/.kube/config
        '';
      };

      # refresh daily (picks up a recreated token / late gitops sync)
      systemd.timers.agent-kubeconfig = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    })
  ]);
}

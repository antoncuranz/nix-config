#!/usr/bin/env bash
# Run as root on Serverton before installing a boot entry.
set -euo pipefail

encrypted_file=${1:?Pass the path to secrets/secrets.enc.json}
export SOPS_AGE_KEY_CMD="${SOPS_AGE_KEY_CMD:-$(command -v ssh-to-age) -private-key -i /persist/etc/ssh/ssh_host_ed25519_key}"
directory=/persist/secrets/initrd
install -d -m 0700 "$directory"
temporary=$(mktemp -d "$directory/.pushover.XXXXXXXX")
cleanup() {
  rm -f "$temporary/token" "$temporary/user"
  rmdir "$temporary"
}
trap cleanup EXIT
umask 077
sops --decrypt --extract '["pushover"]["token"]' "$encrypted_file" > "$temporary/token"
sops --decrypt --extract '["pushover"]["user"]' "$encrypted_file" > "$temporary/user"
test -s "$temporary/token"
test -s "$temporary/user"
install -m 0600 "$temporary/token" "$directory/pushover-token"
install -m 0600 "$temporary/user" "$directory/pushover-user"

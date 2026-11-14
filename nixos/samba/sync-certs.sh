set -euo pipefail
umask 077

dir="${SAMBA_TLS_DIR:-/var/lib/samba/tls-managed}"
mkdir -p "$dir"
chmod 700 "$dir"
tmp=$(mktemp -d "$dir/.sync.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT

# Fetch once so both fields come from the same version of the Secret.
kubectl --request-timeout=30s -n authentication get secret samba-ad-dc-certs -o json > "$tmp/secret.json"
jq -er '.data["tls.crt"] | select(type == "string" and length > 0)' "$tmp/secret.json" | base64 -d > "$tmp/ad.crt"
jq -er '.data["tls.key"] | select(type == "string" and length > 0)' "$tmp/secret.json" | base64 -d > "$tmp/ad.key"

openssl x509 -in "$tmp/ad.crt" -noout -checkend 0
not_before=$(openssl x509 -in "$tmp/ad.crt" -noout -startdate)
test "$(date -d "${not_before#notBefore=}" +%s)" -le "$(date +%s)"
openssl pkey -in "$tmp/ad.key" -check -noout
openssl x509 -in "$tmp/ad.crt" -pubkey -noout | openssl pkey -pubin -outform DER > "$tmp/cert.pub"
openssl pkey -in "$tmp/ad.key" -pubout -outform DER > "$tmp/key.pub"
cmp -s "$tmp/cert.pub" "$tmp/key.pub" || { echo "Certificate and key do not match" >&2; exit 1; }

if ! cmp -s "$tmp/ad.crt" "$dir/ad.crt" || ! cmp -s "$tmp/ad.key" "$dir/ad.key"; then
  # Mark before replacing either file so an interrupted installation is retried.
  touch "$dir/pending"
  mv -f "$tmp/ad.crt" "$dir/ad.crt"
  mv -f "$tmp/ad.key" "$dir/ad.key"
fi

if [ -e "$dir/pending" ]; then
  smbcontrol ldap_server reload-certs
  rm -f "$dir/pending"
  echo "Installed and reloaded Samba LDAP TLS certificate"
else
  echo "Samba TLS certificate is unchanged"
fi

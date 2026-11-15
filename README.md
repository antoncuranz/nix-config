# nix-config

## Secrets and CI

`secrets/secrets.enc.json` is encrypted with sops and age for the
Serverton host key and the owner's recovery key. Back up the recovery key
separately; CI needs neither private key. The SSH public keys used by NixOS
are in `public-keys.nix`. The previous git-crypt encrypted Samba
initialization script is preserved as the encrypted JSON value
`initSambaScriptBase64`.

On the Mac, install sops and age and keep the recovery key at
`~/.config/sops/age/keys.txt`. Check decryption without printing secrets:

```sh
sops --decrypt secrets/secrets.enc.json >/dev/null
```

Edit encrypted values with `sops secrets/secrets.enc.json`. To recover the
old Samba script, decrypt the `initSambaScriptBase64` field and base64-decode
it into a private location; it may contain sensitive information. Git history
still contains git-crypt ciphertext and requires the original key.

### First deployment to Serverton

The system uses the persisted host key at
`/persist/etc/ssh/ssh_host_ed25519_key`. Keep a secure backup: if the host
key changes, use the recovery key to add the new host's age recipient with
`sops updatekeys` before deploying. The key and `/persist` must be available
before user creation.

The initrd notification credentials must exist **before** installing the
first boot entry. On Serverton, from a checkout containing the new encrypted
file, run as root:

```sh
nix shell nixpkgs#sops nixpkgs#ssh-to-age --command ./scripts/provision-initrd-secrets.sh secrets/secrets.enc.json
```

Then build and switch the configuration. Run the provisioning command again
**before** a rebuild whenever those Pushover values change. This copies the
current Pushover values to protected files on the encrypted filesystem; the
bootloader appends them to the initrd outside the Nix store. They are readable
from the unencrypted boot partition, including in old boot generations.
These are the same credentials as the normal failure notification. Using a
separate token would require separate encrypted values and provisioning logic.

For a fresh install, restore the persistent host key and provision these files
under the target's `/persist` before installing the boot entry. Alternatively,
add the new host key as a sops recipient using the recovery key and re-encrypt
the file first. Never put a private key in the repository or Nix store.

### Automatic deployment

After the first manual deployment, Comin polls this repository's `main`
branch every 10 minutes and switches Serverton to new commits. Its state is
persisted in `/persist/var/lib/comin`; no testing branch is enabled. GitHub CI
and Comin run independently: Comin does not wait for checks or for Cachix to
finish uploading. Require successful checks before merging changes.

Merge this configuration into `main` before the first switch. If Comin is
started from an unmerged branch, it will instead deploy the current `main`
branch. Provision the initrd credentials before that first switch and before
merging changes to the Pushover credentials, as described above.

### Cachix

The public `antoncuranz` Cachix cache uses a write token stored as the
repository Actions secret `CACHIX_AUTH_TOKEN`. Pull requests from this
repository and pushes to `main` upload the Serverton, macbook, and workbook runtime closures.
Forked pull requests build using the public cache without an upload token.
Serverton is configured to use this cache once the new configuration has
been activated. Review Nix store contents for secrets before publishing; a
binary cache is not a secret store.

CI runs vulnix against the
Serverton runtime closure and lists potential CVEs in the run summary. The
vulnerability report is informational: matching is heuristic and may miss
paths without available derivations or report false positives. Scanner errors
fail the job; reported CVEs do not.

## Installation

```bash
sudo passwd root # via KVM
ssh root@192.168.x.y

bash <(curl -s https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/install.sh)

# run init scripts
```

## macOS Installation

```bash
# install nix
curl -L https://nixos.org/nix/install | sh

# bootstrap
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake '/Users/ant0n/Developer/nix-config#macbook'

# update
rebuild
```


### Flake updates

The daily update workflow opens a pull request when inputs change. Configure
`GH_TOKEN_FOR_UPDATES` as an Actions secret with a fine-grained token that has
repository Contents and Pull requests read/write access. Its identity triggers
CI for the update PR. Pull requests from the `update-flake-lock` branch are
automatically squash merged after all three builds and cache uploads pass.
Enable auto-merge in repository settings and
require the build checks on `main` through branch protection or a ruleset;
any additional required checks or reviews also need to pass. Merging deploys Serverton
through Comin, as described above.

The Serverton vulnerability summary sorts individual CVEs by CVSS v3 base
score, with missing scores listed last. These scores are informational and do
not block an update.

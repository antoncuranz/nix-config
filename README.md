# nix-config

## Installation

```bash
sudo passwd root # via KVM
ssh root@192.168.x.y

# format disk
curl https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/disko/zroot.nix -o /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix

mkdir -p /mnt/etc/nixos /mnt/etc/secrets/initrd

# install git and git-crypt
nix-env -f '<nixpkgs>' -iA git
nix-env -f '<nixpkgs>' -iA git-crypt

# clone and unlock configuration
git clone https://github.com/ant0ncuranz/nix-config.git /mnt/etc/nixos
echo """<PASTE_BASE64_ENCODED_KEY>""" | base64 --decode > /tmp/git-crypt-key
(cd /mnt/etc/nixos && git-crypt unlock /tmp/git-crypt-key)

ssh-keygen -t ed25519 -N "" -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
ssh-keygen -t rsa -N "" -f /mnt/etc/secrets/initrd/ssh_host_rsa_key

nixos-install

# run init scripts
```


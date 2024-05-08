# nix-config

## Installation

```bash
sudo passwd root # via KVM
ssh root@192.168.x.y

bash <(curl -s https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/install.sh)

# run init scripts
```

## Low memory VPS Installation

```bash
# verify disk and image size
vim disko/cloudton.nix

# build disk image
nix build .#nixosConfigurations.cloudton.config.system.build.diskoImagesScript
sudo ./result

# transfer image to VPS (boot live system, e.g. nix minimal)
cat main.raw | ssh root@<VPS_IP> "dd of=/dev/xyz"
```

## Test VM Installation

```bash
sudo passwd root # via virt-manager
ssh root@192.168.x.y

bash <(curl -s https://raw.githubusercontent.com/ant0ncuranz/nix-config/main/vminstall.sh)
```


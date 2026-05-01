{ config, lib, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    lazygit
    htop
    wget
    git-crypt
    tree
    tig

    unstable.colima
    docker
    docker-compose
    docker-credential-helpers

    kubernetes-helm
    kubectl
    kubectl-cnpg
    kubectx
    unstable.k9s
    unstable.freelens-bin
    unstable.fluxcd
    minikube
    unstable.opentofu
    cilium-cli

    goku
    go
    delta
    krew
    _1password-cli
    just
    minijinja
    postgresql  # provides pg_dump
    postgresql.pg_config  # required for psycopg2 python package
    python312
    restic
    unixtools.watch
    unstable.vscodium
    gh
    unstable.ripgrep
    unstable.bun
  ];
}

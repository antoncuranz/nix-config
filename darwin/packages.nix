{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    unstable.colima
    docker
    docker-compose
    docker-credential-helpers
    fork.iterm2
    unstable.k9s
    goku
    spotify
    go
    lazygit
    git-crypt
    kubernetes-helm
    kubectl
    kubectl-cnpg
    kubectx
    unstable.fluxcd
    _1password-cli
    just
    minijinja
    htop
    wget
    postgresql  # provides pg_dump
    postgresql.pg_config  # required for psycopg2 python package
    python312
    restic
    tree
    claude-code
  ];
}

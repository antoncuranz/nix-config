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

    lighter
    orca
    docker
    docker-compose
    docker-credential-helpers

    kubernetes-helm
    kubectl
    kubectl-cnpg
    kubectx
    kubeconform
    kube-linter
    kustomize
    unstable.k9s
    unstable.fluxcd
    unstable.opentofu
    cilium-cli

    goku
    go
    delta
    krew
    _1password-cli
    just
    minijinja
    postgresql  # provides pg_dump, psql, and pg_isready for DollarBridge
    python312
    restic
    unixtools.watch
    gh
    forgejo-cli
    unstable.ripgrep
    unstable.bun
    fzf
    bat
    yq
    devcontainer
  ];
}

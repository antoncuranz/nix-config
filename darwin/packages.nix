{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    colima
    docker
    docker-compose
    unstable.iterm2
    unstable.k9s
    goku
    spotify
    go
    lazygit
    git-crypt
    kubernetes-helm
  ];
}

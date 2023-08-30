{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    zstd
    kubectl
    kubernetes-helm
    jq
    yq
    curl
    wget
    caddy
    btop
    cmake
    exa
    fzf
    delta
    rsync
    s3cmd
    neovim
    minikube
    gnumake
    yubikey-manager
    tmux
    tmate
  ];
}

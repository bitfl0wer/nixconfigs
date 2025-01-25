{ config, pkgs, ... }:

{  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    zsh
    htop
    btop
    iotop
    nethogs
    iftop
    docker
    docker-compose
    iptables
    bat
    zoxide
    gh
  ];
}
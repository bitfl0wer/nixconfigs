# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "snowstorm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking = { useDHCP = lib.mkForce true; };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.star = {
    isNormalUser = true;
    description = "star";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  users.users.root.shell = pkgs.zsh;

  programs.zsh.enable = true;

  # Allow unfree packages
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = { "PermitRootLogin" = "yes"; };
  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ 
  # ... ]; Or disable the firewall altogether. networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and 
  # database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release 
  # version of the first install of this system. Before changing this value read the documentation for this option (e.g. 
  # man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "data-root" = "/data/docker-data";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.git = {
    enable = true;
    userName = "Flori Weber";
    userEmail = "flori@bitfl0wer.de";
  };
}

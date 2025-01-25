{config, lib, ... }:

{
  networking.hostName = "snowstorm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking = { useDHCP = lib.mkForce true; };
}
{ inputs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/packages.nix
    ../../modules/openssh.nix
    ../../modules/docker.nix
    ../../modules/users.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    initrd.luks.devices.cryptroot.device =
      "/dev/disk/by-uuid/25802b28-9996-46d1-af80-f65e722c6f57";
  };

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # nvme0n1p3_crypt UUID=25802b28-9996-46d1-af80-f65e722c6f57 none luks,discard
      # data /dev/sda /root/lukskey
      # hdd1 UUID=119d760f-b661-42a7-9c36-c2c5dc3009b7 /root/lukskey2
      vault8 UUID=3ea0931e-8f06-4b52-80ca-56c831a6f6a0 /etc/.crypt-vault8 nofail
    '';
  };

  fileSystems."/srv/vault8" = {
    device = "/dev/mapper/vault8";
    fsType = "auto";
    options = [ "nofail" "users" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ 
  # ... ]; Or disable the firewall altogether. networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and 
  # database versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release 
  # version of the first install of this system. Before changing this value read the documentation for this option (e.g. 
  # man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Eat your nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

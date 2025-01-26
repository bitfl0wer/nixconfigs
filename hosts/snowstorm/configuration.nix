{ inputs, lib, config, ... }:

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
    initrd = {
      availableKernelModules = [ "virtio-pci" ];
      luks.devices.cryptroot.device =
        "/dev/disk/by-uuid/25802b28-9996-46d1-af80-f65e722c6f57";
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          # this includes the ssh keys of all users in the wheel group
          authorizedKeys = with lib;
            concatLists (mapAttrsToList (name: user:
              if elem "wheel" user.extraGroups then
                user.openssh.authorizedKeys.keys
              else
                [ ]) config.users.users);
        };
        postCommands = ''
          echo 'cryptsetup-askpass' >> /root/.protifle
        '';
      };
    };
  };

  # Add a systemd service to generate keys if they are missing
  systemd.services.generateInitrdSSHKeys = {
    description = "Generate SSH keys for initrd";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        mkdir -p /etc/secrets/initrd
        for key_type in rsa ed25519; do
          key_path="/etc/secrets/initrd/ssh_host_$\{key_type}_key"
          if [ ! -f "$key_path" ]; then
            ssh-keygen -t $key_type -f "$key_path" -N ""
          fi
        done
      '';
      Type = "oneshot";
      RemainAfterExit = true;
      before = "initrdSSH";
    };
  };

  # Ensure keys are included in the initrd
  boot.initrd.network.ssh.hostKeys = [
    "/etc/secrets/initrd/ssh_host_rsa_key"
    "/etc/secrets/initrd/ssh_host_ed25519_key"
  ];

  # Optional: secure the directory with correct permissions
  environment.etc."secrets/initrd".source = "/etc/secrets/initrd";
  environment.etc."secrets/initrd".mode = "0700";

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

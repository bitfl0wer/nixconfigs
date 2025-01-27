{ pkgs, ... }:

{ # Allow unfree packages
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
    gnupg

  ];
  programs.zsh.enable = true;
  # NixOS comes with a pre-configured SSH jail which will observe errors in the SSH daemon and ban offending IPs.
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [ "192.168.172.0/16" ];
    bantime = "6h";
    bantime-increment = {
      enable = true;
      formula =
        "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h";
      overalljails = true;
    };
  };
}

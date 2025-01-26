{ identities, pkgs, ... }:

{
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;

  users.users = {
    ${identities.flori.username} = {
      initialHashedPassword = identities.flori.password;
      openssh.authorizedKeys.keys = identities.flori.pubkeys;
      useDefaultShell = true;
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" ];
    };
    ${identities.viv.username} = {
      initialHashedPassword = identities.viv.password;
      openssh.authorizedKeys.keys = identities.viv.pubkeys;
      useDefaultShell = true;
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" ];
    };
  };
}

{
  description = "Shared server flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {

    nixosConfigurations = {

      snowstorm = nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        modules = [
          ./hosts/snowstorm/configuration.nix
          ./hosts/snowstorm/hardware-configuration.nix
          ./modules/docker.nix
          ./modules/packages.nix
          ./modules/users.nix
          ./modules/networking.nix
          inputs.home-manager.nixosModules.default
        ];
        specialArgs = {
          inherit inputs;
          hostname = "snowstorm";
          identities.flori = import ./identities/flori.nix;
          identities.viv = import ./identities/viv.nix;
        };

      };

      snowstorm-vm = nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        modules = [
          ./hosts/snowstorm-vm/configuration.nix
          ./hosts/snowstorm-vm/hardware-configuration.nix
          ./modules/docker.nix
          ./modules/packages.nix
          ./modules/users.nix
          ./modules/networking.nix
          inputs.home-manager.nixosModules.default
        ];
        specialArgs = {
          inherit inputs;
          hostname = "snowstorm-vm";
          identities.flori = import ./identities/flori.nix;
          identities.viv = import ./identities/viv.nix;
        };

      };

    };
  };
}

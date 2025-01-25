{
  description = "Shared server flake";

  input.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  output = { self, nixpkgs }: {

      nixosConfigurations = {
        snowstorm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/snowstorm/configuration.nix
            ./modules/docker.nix
            ./modules/packages.nix
            ./modules/users.nix
          ]
        }
      }

  }
}
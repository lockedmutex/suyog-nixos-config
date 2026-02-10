{
  description = "NixOS Configuration for AsusVivobook";

  inputs = {
    # 1. Official NixOS Package Sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3. Nix User Repository (NUR)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.AsusVivobook = nixpkgs.lib.nixosSystem {
        inherit system;

        # Pass inputs and special variables to all modules
        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Main Configuration
          ./configuration.nix

          # Home Manager Module
          home-manager.nixosModules.default

          # NUR Overlay (This adds `pkgs.nur` to your system packages)
          {
            nixpkgs.overlays = [ nur.overlays.default ];
          }
        ];
      };
    };
}

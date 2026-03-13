{
  description = "Nix Blueprint Scaffolding";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
  }: {
    # macOS configuraiton
    darwinConfigurations = {
      "macbox" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./modules/core.nix
          ./modules/homebrew.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users."david" = import ./modules/home.nix;
          }
        ];
      };

      # linux configuration
    };
  };
}

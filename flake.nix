{
  description = "Han's system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kapi-vim = {
      url = "github:henrydsg/kapi-vim";
    };
  };
  outputs =
    inputs @ { nixpkgs
    , home-manager
    , flake-parts
    , darwin
    , kapi-vim
    , ...
    }: {
      darwinConfigurations.youyihongs-MacBook-Pro =
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs { system = "aarch64-darwin"; };
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              users.users.yihungyu = {
                name = "yihungyu";
                home = "/Users/yihungyu";
              };
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                extraSpecialArgs = { inherit kapi-vim; };
                users.yihungyu = import ./home-manager/home.nix;
              };
            }
          ];
        };
    };
}

{
  description = "My macOS and Linux configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-current-pane-hostname = {
      url = "github:soyuka/tmux-current-pane-hostname";
      flake = false;
    };

    tmux-tilish = {
      url = "github:aryzhk0v/tmux-tilish";
      flake = false;
    };

    tmux-suspend = {
      url = "github:MunifTanjim/tmux-suspend";
      flake = false;
    };

    tmux-ssh-split = {
      url = "github:pschmitt/tmux-ssh-split";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs-linux,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "aryzhkov";
      linuxSystem = "x86_64-linux";
      darwinHostname = "aryzhkovs-MacBook-Pro";
    in
    {
      darwinConfigurations.${darwinHostname} =
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs username;
          };

          modules = [
            home-manager.darwinModules.home-manager
            ./darwin.nix
          ];
        };

      homeConfigurations."${username}@linux" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-linux.legacyPackages.${linuxSystem};

          extraSpecialArgs = {
            inherit inputs username;
          };

          modules = [
            ./home.nix
            ./linux.nix
          ];
        };
    };
}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    hyprdynamicmonitors.url = "github:fiffeek/hyprdynamicmonitors";
  };
  outputs = {nixpkgs, home-manager, hyprdynamicmonitors, ...} @ inputs: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.x1nano = nixpkgs.lib.nixosSystem { 
	specialArgs = { inherit inputs system; }; 
	modules = [
	    ./configuration.nix
	    home-manager.nixosModules.home-manager {
			home-manager.extraSpecialArgs = { inherit inputs system; }; 
	    	home-manager.useGlobalPkgs = true; 
			home-manager.useUserPackages = true; 
			home-manager.users.nate = import ./home.nix; 
	    } 
	];
    }; 
  };
}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
#    hyprland.url = "github:hyprwm/Hyprland"; 
  };
  outputs = {nixpkgs, home-manager,...} @ inputs: 
  {
    nixosConfigurations.x1nano = nixpkgs.lib.nixosSystem { 
	system = "x86_64-linux"; 
	modules = [
	    ./configuration.nix
	    home-manager.nixosModules.home-manager {
	    	home-manager.useGlobalPkgs = true; 
		home-manager.useUserPackages = true; 
		home-manager.users.nate = import ./home.nix; 
	    } 
	];
    }; 
  }; 
}

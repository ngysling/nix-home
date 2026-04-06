# Edit this configuration file to define what should be installed on
  
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{
  imports = [
      ./hardware-configuration.nix
	  ./modules/noise-suppression.nix
	  ./modules/sddm.nix
  ];
  nix = { 
	settings = { 
		experimental-features = ["nix-command" "flakes" ];
	}; 
  }; 
  environment.systemPackages = with pkgs; [ 
  	hyprland
	neovim
	git
	wget
	acpi
	curl
	jq
	qemu
	quickemu
	openrazer-daemon
	usbutils
  ]; 
  services.upower.enable = true; 
  programs.hyprland = { 
      enable = true;
	  withUWSM = true; 
  }; 
  programs.uwsm.enable = true; 
#  programs.uwsm = { 
#    enable = true;
#	waylandCompositors = { 
#	  hyprland = {
#	    prettyName = "Hyprland";
#	    comment = "Hyprland compositor managed by UWSM";
#	    binPath = "/run/current-system/sw/bin/Hyprland";
#	  };
#    }; 
#  }; 
  environment.sessionVariables = { 
	GTK_THEME = "Adwaita:dark"; 
	NIXOS_OZONE_WL = "1"; 
  };  
  hardware = { 
	bluetooth = { 
		enable = true;
		powerOnBoot = true; 
		settings = { 
			General = { 
				Experimental = true; 
			}; 
		}; 
	}; 
	graphics.enable = true; 
	openrazer.enable = true; 
  };
	systemd.user.services.razer-dpi = {
	  description = "Set Razer DPI on login";
	  wantedBy = [ "default.target" ];
	  after = [ "openrazer-daemon.service" ];
	  serviceConfig = {
		Type = "oneshot";
		ExecStart = "${pkgs.razer-cli}/bin/razer-cli -d 800";
	  };
	};
  fonts = {
      fontconfig = {
        enable = true; 
	defaultFonts = {
	  monospace = [ "JetBrainsMono Nerd Font Mono" "JetBrains Mono" ]; 
	  serif = [ "Liberation Serif" ]; 
	  sansSerif = [ "Liberation Sans" ]; 
        }; 
      }; 
      packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	nerd-fonts.fira-code
	noto-fonts-color-emoji
	liberation_ttf
	jigmo # kanji
      ]; 
  }; 
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "gnome"
        ];
      };
    };
  };
  security.rtkit.enable = true; 
  services.pipewire = { 
	enable = true; 
	alsa.enable = true; 
	alsa.support32Bit = true; 
	pulse.enable = true; 
	jack.enable = true; 
  };  
 
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "x1nano"; # Define your hostname.
  networking.networkmanager.enable = true;  
  time.timeZone = "America/New_York";
  services.tailscale = {
  	enable = true; 
	extraSetFlags = [ "--accept-routes" ];
  };
  users.users.nate = {
    isNormalUser = true;
    extraGroups = [ "wheel" "openrazer" ]; 
    shell = pkgs.zsh; 
  };
  services.pcscd.enable = true; 
  programs.gnupg.agent = { 
  	enable = true;
	pinentryPackage = pkgs.pinentry-gtk2; 
  }; 

  programs.steam.enable = true; 
  programs.zsh.enable = true; 
  services.blueman.enable = true; 
  services.tlp.enable = true;
  services.thermald.enable = true; 

  system.stateVersion = "25.05"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true; 

}


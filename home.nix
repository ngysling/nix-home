{ inputs, pkgs, lib, ... }:

let 
    laptop = { 
	  desc = "Chimei Innolux Corporation 0x1301";
	  conf = "preferred,0x0,1.2";
	};
	sceptre = { 
	  desc = "Sceptre Tech Inc Sceptre Z27"; 
	  conf = "preferred,auto,1.5";
	};
  undocked-conf = pkgs.writeText "undocked" ''
    monitor=desc:${laptop.desc},${laptop.conf} 
  ''; 
  
  docked-conf = pkgs.writeText "docked" ''
    monitor=desc:${sceptre.desc},${sceptre.conf}
    monitor=desc:${laptop.desc},disable
  '';
in {
  imports = [
    ./modules/hyprland.nix
    ./modules/zsh.nix
    ./modules/kanshi.nix
    ./modules/waybar.nix
    ./modules/rofi.nix
    ./modules/kitty.nix
    ./modules/superfile.nix
	./modules/japanese.nix
	./modules/drpp.nix
	./modules/hyprdynamicmonitors.nix
	inputs.hyprdynamicmonitors.homeManagerModules.default
  ]; 
  services.discord-rpc-plex = { 
  	enable = true; 
  }; 
  home.username = "nate";
  home.homeDirectory = "/home/nate";
  home.packages = with pkgs; [
	hyprland
	hyprlock
	swww
	dunst
	libnotify
	swaynotificationcenter
	kanshi
	clipse
	btop
	pamixer
	brightnessctl
	firefox
	thunderbird
	discord
	plex-desktop
	plexamp
	vscode
	ffmpeg
	mpv
	nodejs
	obsidian
	wl-clipboard
	networkmanagerapplet
	grim
	slurp
	unzip
	polychromatic
	kdePackages.gwenview
	nicotine-plus
	swayimg
	yt-dlp
	calcurse
	pandoc
	texliveMedium
	zathura
	anki
	prismlauncher 

	# -- Fonts and IME stuff -- 
	font-awesome
	nerd-fonts.fira-code
	nerd-fonts.jetbrains-mono
	ipafont
	kochi-substitute
	noto-fonts-cjk-sans
	noto-fonts
	noto-fonts-lgc-plus
	noto-fonts-color-emoji
  ];
  home.sessionVariables = { 
    GTK_THEME = "Adwaita:dark"; 
    NIXOS_OZONE_WL = "1"; 
  };
  # -- Programs and services -- 
  xdg.portal.enable = true; 
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk 
    pkgs.xdg-desktop-portal-hyprland
  ]; 
  programs.home-manager.enable = true;
  programs.neovim = { 
    enable = true; 
    extraConfig = lib.fileContents ./nvim/init.vim; 
    vimAlias = true; 
  }; 
  services.swww.enable = true; 
  services.ssh-agent.enable = true; 
  fonts.fontconfig.enable = true; 

  home.stateVersion = "25.05"; 
    home.hyprdynamicmonitors = { 
		enable = true;
		installExamples = false;
		systemdTarget = "graphical-session.target"; 
		extraFlags = ["--disable-power-events"];
		config = ''#toml
		[profiles.docked]
		config_file = "${docked-conf}"
		config_file_type = "static"
		[profiles.docked.conditions]
	  
		[[profiles.docked.conditions.required_monitors]]
		description = "${laptop.desc}"
	  
		[[profiles.docked.conditions.required_monitors]]
		description = "${sceptre.desc}"
	  
		[profiles.undocked]
		config_file = "${undocked-conf}"
		config_file_type = "static"
		[profiles.undocked.conditions]
		[[profiles.undocked.conditions.required_monitors]]
		description = "${laptop.desc}"
		''; 
    }; 
}


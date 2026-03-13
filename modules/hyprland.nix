{ ... }: {

  wayland.windowManager.hyprland = {
    enable = true;
	systemd.enable = false; 
    extraConfig = builtins.readFile ../hypr/hyprland.conf;
    xwayland.enable = true; 
  };
}

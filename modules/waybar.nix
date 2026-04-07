{ ... }:

{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ../waybar/style.css; 
    settings = {
      mainBar = {
	  	spacing = 0; 
		height = 30; 
        layer = "top";
		margin-top = 5; 
        exclusive = true;
        passthrough = false;

        modules-left = [
		  "custom/menu"
		  "custom/divider"
          "cpu"
          "custom/divider"
          "memory"
		  "custom/divider"
		  "temperature"
          "custom/divider"
          "network"
          "custom/divider"
          "battery"
        ];
        
        modules-center = [ "clock" ];
        
        modules-right = [
		  "custom/notification"
		  "custom/divider"
          "custom/clipboard"
		  "custom/divider"
          "backlight"
          "custom/divider"
          "pulseaudio"
          "custom/divider"
          "tray"
       ];

        clock = {
          tooltip = true;
		  format = " {:%I:%M %p}";
          tooltip-format = "{:%a, %b%e}";
		  on-click = "kitty calcurse"; 
        };

        cpu = {
          interval = 30;
          format = "  {}%";
          max-length = 10;
          on-click = "kitty -e btop";
        };

        memory = {
          interval = 1;
          format = " {}%";
          max-length = 30;
        };

        network = {
          interval = 100;
          interface = "wlp0s20f3";
          format = "{ifname}";
          format-wifi = "";
          format-ethernet = " {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected "; # An empty format will hide the module
          tooltip-format = " {ifname} via {gwaddr}";
          tooltip-format-wifi = " {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          exec = "kitty -e nmcli dev wifi ";
          on-click = "iwmenu -l rofi&";
        };

	  temperature = { 
  		 thermal-zone = 4;
		 critical-threshold = 80;
		 interval = 2;
		 format = "{icon} {temperatureC}°C";
		 format-critical = "󱒔 {temperatureC}°C";
		 format-icons = ["󱃃" "󰔏" "󱃂" "󰸁" "󱃂"];
		 tooltip = true; 
		 tooltip-format = "Temperature: {temperatureC}°C ({temperatureF}°F)";
		 on-click = "kitty -e watch -n 1 sensors";
        }; 

        "custom/clipboard" = {
          format = "";
          on-click = "kitty --class clipse -e 'clipse'";
		  tooltip = false; 
        };

	    "custom/menu" = { 
			format = ""; 
			on-click = "rofi -show drun"; 
		}; 

        backlight = {
          device = "intel_backlight";
		  exec-if = "hyprctl monitors -j | jq -e '.[] | select(.name == \"eDP-1\")' > /dev/null"; 
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          min-length = 6;
		  tooltip = false; 
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          tooltip = false;
          format-muted = " Muted";
          on-click = "pamixer -t";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
       #   format: "<span font='JetBrainsMono Nerd Font'> {capacity}%</span>"
          format = "{icon}  {capacity}% ";
          format-charging = "󰉁 {capacity}% ";
          format-plugged = " {capacity}% ";
          format-alt = "{time} {icon} ";
          format-icons = ["" "" "" "" ""];
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        "custom/divider" = {
          format = "|";
		  tooltip = false; 
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };
  };
}

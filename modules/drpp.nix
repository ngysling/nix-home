{lib, pkgs, config, ...}:

with lib; 
let
  cfg = config.services.discord-rpc-plex;
in
{
  options = { 
  	services.discord-rpc-plex = { 
		enable = mkEnableOption "discord-rpc-plex";
		package = mkPackageOption pkgs "discord-rich-presence-plex" { };

		dataDir = mkOption {
		  type = types.path;
		  default = "${config.home.homeDirectory}/.local/share/drpp";  
		  description = "Path to the data directory.";
		};

		configFile = mkOption {
		  type = types.str;
		  default = "config.yml";
		  description = "Path to config file, relative to data directory or absolute.";
		};

		cacheFile = mkOption {
		  type = types.str;
		  default = "cache.json";
		  description = "Path to cache file, relative to data directory or absolute.";
		};

		logFile = mkOption {
		  type = types.nullOr types.path;
		  default = null;
		  description = "Path to log file. Set to null to disable.";
		};

		disableWebUI = mkOption {
		  type = types.bool;
		  default = false;
		  description = "Whether to disable the web interface. The web UI must be used for first time setup. ";
		};

		disableSystray = mkOption {
		  type = types.bool;
		  default = false;
		  description = "Whether to disable the system tray icon.";
		}; 

		disableWebUILaunch = mkOption {
		  type = types.bool;
		  default = false;
		  description = "Whether to disable the web UI launching on startup";
		}; 
	  };
	}; 
	 
	config = mkIf (cfg.enable) {
		systemd.user.services.discord-rpc-plex = { 
			  Unit = {
				  Description = "Discord Rich Presence for Plex";
			  }; 
			  Install = {
			  	  WantedBy = [ "graphical-session.target" ]; 
			  }; 
			  Service = { 
			  	  Environment = [ 
					"DRPP_DISABLE_WEB_UI=${toString cfg.disableWebUI}"
					"DRPP_DISABLE_SYSTRAY=${toString cfg.disableSystray}"
					"DRPP_DATA_DIR=${cfg.dataDir}"
					"DRPP_CONFIG_FILE=${cfg.configFile}"
					"DRPP_CACHE_FILE=${cfg.cacheFile}"
					"DRPP_DISABLE_WEB_UI_LAUNCH=${toString cfg.disableWebUILaunch}"
				  ]
					++ lib.optional (cfg.logFile != null) "DRPP_LOG_FILE=${toString cfg.logFile}";
				  ExecStart = "${pkgs.writeShellScript "drpp" '' 
					${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}
					/home/nate/drpp \ 
				  ''}";
			  };
    	    };
    }; 
}

{config, pkgs, inputs, lib, ...}: 
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
  in 
  {
    home.hyprdynamicmonitors = { 
		enable = true;
		installExamples = false;
		systemdTarget = "graphical.target"; 
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

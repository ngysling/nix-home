{ pkgs, ... }:
{
home.packages = with pkgs; [
	rofi
]; 

home.file = { 
	".config/rofi/config.rasi".source = ../rofi/config.rasi;
	".config/rofi/nord.rasi".source = ../rofi/nord.rasi; 
}; 
}


{ pkgs, ... }:
let
  amadeus = pkgs.stdenvNoCC.mkDerivation {
    name = "sddm-theme-amadeus";
    src = pkgs.fetchFromGitHub {
      owner = "Michal-Szczepaniak";
      repo = "sddm-theme-amadeus";
      rev = "master";
	  sha256 = "sha256-A0xehyIDPVnxAqNtaru6IegUgUBPEPLgpbUerCunHvE="; 
    };
	installPhase = ''
	  mkdir -p $out/share/sddm/themes/amadeus
	  cp -r . $out/share/sddm/themes/amadeus
	  echo "QtVersion=6" >> $out/share/sddm/themes/amadeus/metadata.desktop
	  substituteInPlace $out/share/sddm/themes/amadeus/Main.qml \
		--replace "import QtGraphicalEffects" "import Qt5Compat.GraphicalEffects"
	  substituteInPlace $out/share/sddm/themes/amadeus/components/SpTextBox.qml \
		--replace "import QtGraphicalEffects" "import Qt5Compat.GraphicalEffects"
	'';
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "amadeus";
	extraPackages = [ amadeus pkgs.qt6.qt5compat ]; 
  };

  environment.systemPackages = [ amadeus pkgs.qt6.qt5compat];
} 

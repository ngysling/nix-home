{ ... }: 
{
  programs.zsh = {
    enable = true; 
    shellAliases = { 
      vim = "nvim";
	  repono = "kitty +kitten ssh -i ~/.ssh/homelab nate@192.168.1.140"; 
	  udelgo = "kitty +kitten ssh -i ~/.ssh/udel ngysling@go.eecis.udel.edu"; 
	  cisc372 = "kitty +kitten ssh -i ~/.ssh/udel ngysling@cisc372.cis.udel.edu"; 
	  darwin = "kitty +kitten ssh -i ~/.ssh/udel ngysling@darwin.hpc.udel.edu"; 
	  taildrop = "sudo tailscale file get .";
	  rebuild = "sudo nixos-rebuild switch --flake /home/nate/nix-home";
	  fastfetch = "fastfetch --logo-color-1 \"#DBC93F\" --logo-color-2 \"#DBC93F\"";
    };
	sessionVariables = { 
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
	}; 
    initContent = "ssh-add ~/.ssh/github 2>/dev/null || true"; 
  }; 
  programs.starship = { 
    enable = true; 
  }; 
}

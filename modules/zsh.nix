{ ... }: 
{
  programs.zsh = {
    enable = true; 
    shellAliases = { 
      vim = "nvim";
	  repono = "kitty +kitten ssh -i ~/.ssh/homelab nate@192.168.1.140"; 
	  udelgo = "kitty +kitten ssh -i ~/.ssh/udel-go ngysling@go.eecis.udel.edu"; 
	  taildrop = "sudo tailscale file get .";
	  rebuild = "sudo nixos-rebuild switch --flake /home/nate/nix-home";
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

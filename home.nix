{ config, pkgs, ... }:

let
  catppuccin-wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
    sha256 = "sha256-fmKFYw2gYAYFjOv4lr8IkXPtZfE1+88yKQ4vjEcax1s="; 
    name = "catppuccin-mocha.png";
  };
  purple-haze-wallpaper = pkgs.fetchurl {
    url = "https://images.unsplash.com/photo-1637825891035-1930cbd564dd?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=milad-fakurian-Oi_oaJk3qlo-unsplash.jpg";
    sha256 = "";
    name = "purple-haze.jpg";
  };
    purple-gloss-wallpaper = pkgs.fetchurl {
    url = "https://images.unsplash.com/photo-1672009190560-12e7bade8d09?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=pawel-czerwinski-1A_dO4TFKgM-unsplash.jpg";
    sha256 = "sha256-oYCYGI6wD02ykdD6RVad+8WA386RaH+LuEFyYu3iSps=";
    name = "purple-gloss.jpg";
  };
in
{
  home.username = "suyog";
  home.homeDirectory = "/home/suyog";

  # home.packages = with pkgs; [];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 30000;
      save = 10000;
      path = "${config.home.homeDirectory}/.histfile"; 
    };
    defaultKeymap = "viins";
    initContent= ''
      setopt extendedglob
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/suyog/nixos-config";
      update = "sudo nix flake update --flake /home/suyog/nixos-config && sudo nixos-rebuild switch --flake /home/suyog/nixos-config";
      clean = "sudo nix-collect-garbage -d";
    };
    
    # Example: Oh My Zsh (optional)
    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [ "git" ];
    #   theme = "robbyrussell";
    # };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Suyog Tandel";
        email = "git@suyogtandel.in";
        signingkey = "/home/suyog/.ssh/git-commit-signing-key";
      };
      
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      init.defaultBranch = "main";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${purple-gloss-wallpaper}";
      picture-uri-dark = "file://${purple-gloss-wallpaper}";
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11"; 
}

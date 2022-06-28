{ config, pkgs, ... }:
{
  imports =[./hardware-configuration.nix <home-manager/nixos>];
  # Grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Enable networking
  networking.networkmanager.enable = true;

  # DESKTOP
  services.xserver.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.bspwm.configFile = pkgs.writeTextFile{
    name = "bspwmrc";
    text = ''
    #! /bin/sh
    picom &
    pgrep -x sxhkd > /dev/null || sxhkd &
    bspc monitor -d I II III IV
    bspc config border_width         3
    bspc config window_gap           8
    bspc config split_ratio          0.5
    bspc config active_border_color "#1d2021"
    bspc config focused_border_color "#928374"
    '';
    executable = true;
  };

  services.xserver.windowManager.bspwm.sxhkd.configFile = pkgs.writeTextFile{

    name = "sxhkdrc";
    text = ''
    # Terminal
    super + Return
            alacritty
    # Launch Rofi
    super + d
            dmenu_run
    # Reload
    super + Escape
            pkill -USR1 -x sxhkd
    # focus or send to the given desktop
    super + {_,shift + }{1-9,0}
            bspc {desktop -f,node -d} '^{1-9,10}'
    # focus the last node/desktop
    super + {grave,Tab}
            bspc {node,desktop} -f last
    # quit/restart bspwm
    super + alt + {q,r}
            bspc {quit,wm -r}
    # close and kill
    super + {_,shift + }w
            bspc node -{c,k}
    # -- Vol + Media -- #
    {XF86AudioRaiseVolume, XF86AudioLowerVolume}
            pactl set-sink-volume @DEFAULT_SINK@ {+5%, -5%}
    {XF86AudioPlay, XF86AudioPrev, XF86AudioNext}
            playerctl {play-pause,previous,next}
    # Flameshot
    Print
            flameshot gui
    '';
    executable = true;
  };

  # Locales
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.utf8";
  console.keyMap = "br-abnt2";
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Som e Pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.fish.shellAliases = {
    n = "nvim";
		c = "code";
  };

  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "lucas";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    dmenu
		neovim
		flameshot
		google-chrome
		alacritty
		vscode
		tdesktop
		yt-dlp
		kdenlive
		jetbrains-mono
		git
		picom
    playerctl
		minecraft
  ];
  system.stateVersion = "22.05"; # Did you read the comment?

  # Usuário
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio"];
  };

	# Home Manager
	# Picom
	services.picom = {
		enable = true;
		vSync = true;
		fade = true;
		fadeDelta = 5;
	};

}

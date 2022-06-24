{ config, pkgs, ... }:
{
  imports =[./hardware-configuration.nix];
  # Grub
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable networking
  networking.networkmanager.enable = true;

  # DESKTOP
  services.xserver.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  services.xserver.windowManager.bspwm.configFile = pkgs.writeTextFile{
    name = "bspwmrc";
    text = ''
    #! /bin/sh
    xsetroot -cursor_name left_ptr &
    setxkbmap br &
    feh --bg-scale ~/wallpaper.png &
    dunst &
    picom &
    polkit-dumb-agent &
    pgrep -x sxhkd > /dev/null || sxhkd &
    bspc monitor -d I II III IV

    bspc config border_width         5
    bspc config window_gap           12
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
    ctrl + shift + {KP_8, KP_2}
            pactl set-sink-volume @DEFAULT_SINK@ {+5%, -5%}

    ctrl + shift + {KP_5,KP_4,KP_6}
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

  # Som e Pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Usuário
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.fish.shellAliases = {
    n = "nvim";
  };

  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "lucas";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    pkgs.dmenu
    pkgs.neovim
    pkgs.flameshot
    pkgs.google-chrome
    pkgs.alacritty
    pkgs.vscode
    pkgs.tdesktop
    pkgs.yt-dlp
    pkgs.kdenlive
    pkgs.jdk
    pkgs.jdk8
    pkgs.jetbrains-mono
  ];
  system.stateVersion = "22.05"; # Did you read the comment?

}

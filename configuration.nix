{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Nix Config:
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    copyKernels = true;
    gfxmodeEfi = "1920x1080";
    gfxpayloadEfi = "keep";
    configurationLimit = 20;
  };

  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.initrd.systemd.enable = true;
  systemd.services.systemd-udev-settle.enable = false;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # LTS Fallback kernel.
  specialisation = {
    on-lts.configuration = {
      system.nixos.tags = [ "lts" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
      boot.supportedFilesystems = [ "zfs" ];
      services.zfs.autoScrub.enable = true;
    };
  };

  # Boot Splash Screen & Silent Boot
  boot.plymouth = {
    enable = true;
    # theme = "bgrt";
    theme = "catppuccin-mocha";
    themePackages = with pkgs; [
      (catppuccin-plymouth.override {
        variant = "mocha";
      })
    ];
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "cifs"
  ];

  networking.hostId = "fc32a568";
  networking.hostName = "AsusVivobook"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.tailscale.enable = true;

  programs.dconf.enable = true;
  environment.sessionVariables.GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Zram Swap
  zramSwap.enable = true;

  # Enable OpenGL/Vulkan support
  hardware.graphics.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.podman.dockerSocket.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable Zsh Integration
  programs.zsh.enable = true;

  # Set Zsh as the default shell for ALL users
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.suyog = {
    isNormalUser = true;
    description = "Suyog Tandel";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      gnome-builder
      gapless
      inkscape-with-extensions
      pods
      distrobox
      zed-editor-fhs
      antigravity-fhs
      keepassxc
      yubioath-flutter
      clapper
      clapper-enhancers
      qbittorrent
      fractal
      authenticator
      peazip
      steam
      heroic
      obs-studio
      iotas
      vesktop
      libreoffice
      pkgs.nur.repos.Ev357.helium

      # language servers for zed:
      nixd
      nil
      nixfmt-rfc-style
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Configure NixPkgs
  nixpkgs.config.allowUnfree = true;

  # Enable SSH Agent
  programs.ssh.startAgent = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    tree
    git
    pcsclite
    python314
    ptyxis
    podman-compose
    zsh
    fuse
    fuse3
    mission-center
    thunderbird
    gnome-tweaks
    fastfetch
    unzip
    zip
    p7zip
    unrar
    git-credential-oauth
    libfido2
    gearlever

    # GNOME Stuff
    gnomeExtensions.dash-to-panel
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
  ];

  environment.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.flatpak.enable = true;
  services.pcscd.enable = true;
  services.clamav.updater.enable = true;
  services.clamav.updater.frequency = 6;
  services.clamav.daemon.enable = false;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  systemd.services.battery-charge-threshold = {
    description = "Set Battery Charge Maximum Limit";

    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];

    startLimitBurst = 0;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
    };
  };

  system.stateVersion = "25.11";

  # Home Manager config
  home-manager = {
    backupFileExtension = "backup";
    users.suyog = import ./home.nix;
  };
}

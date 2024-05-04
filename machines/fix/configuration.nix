{
  pkgs,
  clan-core,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  users.users.root.openssh.authorizedKeys.keys = [
    # IMPORTANT! Add your SSH key here
    # e.g. > cat ~/.ssh/id_ed25519.pub
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
  ];

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.defaultSession = "xfce";
  # Disable the default gnome apps to speed up deployment
  services.gnome.core-utilities.enable = false;

  system.stateVersion = "24.05";
  programs.fish.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  sops.secrets.fil-passwd.neededForUsers = true;
  sops.secrets.nim-passwd.neededForUsers = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    fil = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.fil-passwd.path;
      description = "Philippe Saurel";
      extraGroups = [ "networkmanager" ];
      packages = with pkgs; [
        firefox
        #  thunderbird
      ];
    };
    nim = {
      shell = pkgs.fish;
      isNormalUser = true;
      passwordFile = config.sops.secrets.nim-passwd.path;
      description = "Guilhem Saurel";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        vim
        ncdu
        dfc
        git
      ];
    };
  };

  nix = {
    nixPath = [ "nixpkgs=${clan-core.inputs.nixpkgs}" ];
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nim65s-dotfiles.cachix.org"
        "https://nim65s-nur.cachix.org"
        "https://rycee.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
        "nim65s-nur.cachix.org-1:V3uaUnDnkWYgPDZaXpoe/KIbX5913GWfkazhHVDYPoU="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "fil";
}

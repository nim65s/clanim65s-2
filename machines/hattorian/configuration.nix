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

  system.stateVersion = "24.05";
  programs.fish.enable = true;
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
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
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "bepo";
  };

  # Configure console keymap
  console.keyMap = "fr-bepo";

  sops.secrets."hattorian-nim-passwd".neededForUsers = true;

  users.users = {
    nim = {
      shell = pkgs.fish;
      isNormalUser = true;
      passwordFile = config.sops.secrets."hattorian-nim-passwd".path;
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
}

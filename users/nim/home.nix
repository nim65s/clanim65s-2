_:
{
  home = {
    homeDirectory = "/home/nim";
    stateVersion = "24.05";
    username = "nim";
  };

  programs = {
    firefox.enable = true;
    home-manager.enable = true;
    vim.enable = true;
  };

  services = {
    nextcloud-client.enable = true;
  };
}

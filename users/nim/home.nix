{config, ... }:
{
  home = {
    homeDirectory = "/home/nim";
    packages = [
      #config.nur.repos.mic92.hello-nur
    ];
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

{
  description = "<Put your description here>";

  inputs.clan-core.url = "git+https://git.clan.lol/clan/clan-core";

  outputs =
    { self, clan-core, ... }:
    let
      system = "x86_64-linux";
      pkgs = clan-core.inputs.nixpkgs.legacyPackages.${system};
      # Usage see: https://docs.clan.lol
      clan = clan-core.lib.buildClan {
        directory = self;
        clanName = "__CHANGE_ME__"; # Ensure this is internet wide unique.
        clanIcon = null; # Optional, a path to an image file

        # Prerequisite: boot into the installer
        # See: https://docs.clan.lol/getting-started/installer
        # local> mkdir -p ./machines/machine1
        # local> Edit ./machines/machine1/configuration.nix to your liking
        machines = {
          jon = {
            imports = [
              ./modules/shared.nix
              ./machines/jon/configuration.nix
            ];

            nixpkgs.hostPlatform = system;

            clanCore.machineIcon = null; # Optional, a path to an image file

            # Set this for clan commands use ssh i.e. `clan machines update`
            clan.networking.targetHost = pkgs.lib.mkDefault "root@jon";

            # TODO: Example how to use disko for more complicated setups

            # remote> lsblk --output NAME,PTUUID,FSTYPE,SIZE,MOUNTPOINT
            clan.diskLayouts.singleDiskExt4 = {
              device = "/dev/disk/by-id/__CHANGE_ME__";
            };

            # TODO: Document that there needs to be one controller
            clan.networking.zerotier.controller.enable = true;
          };
          sara = {
            imports = [
              ./modules/shared.nix
              ./machines/sara/configuration.nix
            ];

            nixpkgs.hostPlatform = system;

            clanCore.machineIcon = null; # Optional, a path to an image file

            # Set this for clan commands use ssh i.e. `clan machines update`
            clan.networking.targetHost = pkgs.lib.mkDefault "root@sara";

            # local> clan facts generate

            # remote> lsblk --output NAME,PTUUID,FSTYPE,SIZE,MOUNTPOINT
            clan.diskLayouts.singleDiskExt4 = {
              device = "/dev/disk/by-id/__CHANGE_ME__";
            };

            clan.networking.zerotier.networking.enable = true;
            /*
              After jon is deployed, uncomment the following line
              This will allow sara to share the VPN overlay network with jon
            */
            # clan.networking.zerotier.networkId = builtins.readFile ../jon/facts/zerotier-network-id;
          };
        };
      };
    in
    {
      # all machines managed by cLAN
      inherit (clan) nixosConfigurations clanInternals;
      # add the cLAN cli tool to the dev shell
      devShells.${system}.default = pkgs.mkShell {
        packages = [ clan-core.packages.${system}.clan-cli ];
      };
    };
}

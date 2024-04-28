{
  description = "clan nim65s";

  inputs.clan-core.url = "git+https://git.clan.lol/clan/clan-core";

  outputs =
    { self, clan-core, ... }:
    let
      system = "x86_64-linux";
      pkgs = clan-core.inputs.nixpkgs.legacyPackages.${system};
      # Usage see: https://docs.clan.lol
      clan = clan-core.lib.buildClan {
        directory = self;
        clanName = "clanim65s"; # Ensure this is internet wide unique.
        clanIcon = null; # Optional, a path to an image file

        # Prerequisite: boot into the installer
        # See: https://docs.clan.lol/getting-started/installer
        # local> mkdir -p ./machines/machine1
        # local> Edit ./machines/machine1/configuration.nix to your liking
        machines = {
          fix = {
            imports = [
              ./modules/shared.nix
              ./machines/fix/configuration.nix
            ];

            nixpkgs.hostPlatform = system;

            clanCore.machineIcon = null; # Optional, a path to an image file

            # Set this for clan commands use ssh i.e. `clan machines update`
            clan.networking.targetHost = pkgs.lib.mkDefault "root@fix";

            # TODO: Example how to use disko for more complicated setups

            # remote> lsblk --output NAME,PTUUID,FSTYPE,SIZE,MOUNTPOINT
            clan.diskLayouts.singleDiskExt4 = {
              device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_500GB_23313J803792";
            };

            # TODO: Document that there needs to be one controller
            clan.networking.zerotier.networking.enable = true;
          };
          hattorian = {
            imports = [
              ./modules/shared.nix
              ./machines/hattorian/configuration.nix
            ];

            nixpkgs.hostPlatform = system;

            clanCore.machineIcon = null; # Optional, a path to an image file

            # Set this for clan commands use ssh i.e. `clan machines update`
            clan.networking.targetHost = pkgs.lib.mkDefault "root@hattorian";

            # local> clan facts generate

            # remote> lsblk --output NAME,PTUUID,FSTYPE,SIZE,MOUNTPOINT
            clan.diskLayouts.singleDiskExt4 = {
              device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
            };

            clan.networking.zerotier.controller.enable = true;
            /*
              After fix is deployed, uncomment the following line
              This will allow hattorian to share the VPN overlay network with fix
            */
            # clan.networking.zerotier.networkId = builtins.readFile ../fix/facts/zerotier-network-id;
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

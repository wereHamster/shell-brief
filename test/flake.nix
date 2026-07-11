{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});

      lib = import ../lib.nix { };

      brief =
        pkgs:
        lib.mkShellBrief {
          inherit pkgs;

          banner = ''
            echo "  BEAUTIFUL"
            ${pkgs.figlet}/bin/figlet "shell brief"
          '';

          setup = [
            {
              name = "Dependencies";
              condition = "false";
              suggestion = "Run 'pnpm install'";
            }
            {
              name = "Vercel Link";
              condition = "true";
              suggestion = "Run 'pnpx vercel link'";
            }
            {
              name = "Environment";
              condition = "false";
              suggestion = "Run 'pnpx vercel env pull'";
            }
          ];

          commands = [
            {
              name = "pnpm";
              help = "Manage Node.js dependencies";
            }
            {
              name = "pnpm run dev";
              help = "Start the Next.js development server";
            }
          ];
        };
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          shellHook = ''
            ${brief pkgs}/bin/brief
          '';
        };
      });
    };
}

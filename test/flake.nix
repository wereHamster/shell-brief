{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        lib = import ../lib.nix { };

        brief = lib.mkShellBrief {
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
        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${brief}/bin/brief
          '';
        };
      }
    );
}

{ pkgs }:

let
  lib = pkgs.lib;
  colors = {
    blue = "\\033[1;34m";
    dim = "\\033[0;2m";
    yellow = "\\033[1;33m";
    green = "\\033[0;32m";
    nc = "\\033[0m";
  };

  padTo =
    target: str:
    let
      strLen = builtins.stringLength str;
      diff = target - strLen;
      actualDiff = if diff > 0 then diff else 1;
      spaces = lib.concatStrings (builtins.genList (_: " ") actualDiff);
    in
    "${str}${spaces}";

in
rec {
  mkShellBrief =
    {
      banner,
      setup ? [ ],
      commands ? [ ],
    }:
    pkgs.writeShellScriptBin "brief" ''
      clear

      ${banner}

      echo
      echo

      ${mkSections {
        inherit setup commands;
      }}
    '';

  mkSections =
    {
      setup ? [ ],
      commands ? [ ],
    }:
    let
      mkVarName = name: "status_" + (builtins.replaceStrings [ " " "-" "." ] [ "_" "_" "_" ] name);
      allSetupVars = map (item: mkVarName item.name) setup;
      okValue = "${colors.green}Ok${colors.nc}";
    in
    ''
      # 1. State Calculation
      ${lib.concatStringsSep "\n" (
        map (item: ''
          ${mkVarName item.name}="${okValue}"
          if ! ${item.condition}; then
            ${mkVarName item.name}="${colors.yellow}${item.suggestion}${colors.nc}"
          fi
        '') setup
      )}

      # 2. Render Setup Section (Only if at least one step is not "Ok")
      ${lib.optionalString (setup != [ ]) ''
        SHOW_SETUP=false
        for var in ${lib.concatStringsSep " " allSetupVars}; do
          if [ "''${!var}" != "${okValue}" ]; then
            SHOW_SETUP=true
            break
          fi
        done

        if [ "$SHOW_SETUP" = true ]; then
          echo -e "${colors.blue}Setup${colors.nc}"
          ${lib.concatStringsSep "\n" (
            lib.imap0 (
              i: item:
              let
                isLast = i == (builtins.length setup - 1);
                icon = if isLast then "└─" else "├─";
                paddedName = padTo 20 item.name;
              in
              "echo -e \"${colors.dim} ${icon} ${colors.nc}${paddedName}\${${mkVarName item.name}}\""
            ) setup
          )}
          echo
        fi
      ''}

      # 3. Render Commands Section
      ${lib.optionalString (commands != [ ]) ''
        echo -e "${colors.blue}Commands${colors.nc}"
        ${lib.concatStringsSep "\n" (
          map (
            item:
            let
              paddedName = padTo 22 item.name;
            in
            "echo -e \"  ${paddedName}${colors.dim}# ${item.help}${colors.nc}\""
          ) commands
        )}
        echo
      ''}
    '';
}

# Shell Brief

Library for generating beautiful nix dev shell briefs.

## Motivation

Be involved in multiple projects at the same time.
Each project uses slightly different tools.
And requires different setup steps.
When switching between these projects, it's easy to use the wrong tool or miss an important setup step.

My solution is to print a short brief when I open the nix dev shell.
This brief explains what setup steps need to be performed.
And also what tools and other commands the dev shell makes available.

This nix library provides a function to generate a script that prints the brief.

Below is an example what you might see when you enter the project folder.
In a real terminal, the output would be nicely colored.
Here in this readme it only shows black and white.

```
 _____                           _        ____            _           _
| ____|_  ____ _ _ __ ___  _ __ | | ___  |  _ \ _ __ ___ (_) ___  ___| |_
|  _| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ | |_) | '__/ _ \| |/ _ \/ __| __|
| |___ >  < (_| | | | | | | |_) | |  __/ |  __/| | | (_) | |  __/ (__| |_
|_____/_/\_\__,_|_| |_| |_| .__/|_|\___| |_|   |_|  \___// |\___|\___|\__|
                          |_|                          |__/


Setup
 ├─ Dependencies        Run 'pnpm install'
 ├─ Vercel Link         Run 'pnpx vercel link'
 └─ Environment         Run 'pnpx vercel env pull'

Commands
  pnpm install          # Install Node.js dependencies
  pnpm run dev          # Start the Next.js development server
```

## Usage

### 1. Add the library to your flake inputs

```nix
inputs = {
  shell-brief.url = "github:wereHamster/shell-brief";
};
```

### 2. Create the brief script

```nix
brief = shell-brief.lib.mkShellBrief {
  inherit pkgs;

  # The banner is printed at the top of the brief.
  # Use it to print a recognizable introduction for your project.
  banner = ''
    ${pkgs.figlet}/bin/figlet Example Project
  '';

  # Setup steps that need to be completed to allow working on the project.
  # Each condition is a shell expression that must evaluate to true.
  # If it fails, the suggestion is shown to the user.
  setup = [
    {
      name = "Dependencies";
      condition = "[[ -d node_modules && node_modules -nt pnpm-lock.yaml ]]";
      suggestion = "Run 'pnpm install'";
    }
    {
      name = "Vercel Link";
      condition = "[[ -d .vercel ]]";
      suggestion = "Run 'pnpx vercel link'";
    }
    {
      name = "Environment";
      condition = "[[ -f .env.local ]]";
      suggestion = "Run 'pnpx vercel env pull'";
    }
  ];

  # Commands, tools, scripts that are important to be aware.
  # These can be provided by the buildInputs, custom scripts, shell alias or through other means.
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
```

### 3. Invoke the script in your dev shell hook

```nix
devShells.default = pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs
    pkgs.pnpm
    pkgs.biome
  ];

  shellHook = ''
    ${brief}/bin/brief
  '';
};
```

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
  pnpm                  # Manage Node.js dependencies
  dev                   # Start the Next.js development server
```

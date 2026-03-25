# Examples

Below are examples of `setup` steps (especially the `condition` expressions) that are suitable in specific situations.
If you copy the step into your own shell brief, feel free to update the name and suggestion.

## pnpm

Situation: you use `pnpm` and want to ensure that `node_modules` is up to date.

```nix
{
  name = "Dependencies";
  condition = "[[ -f package.json && -f pnpm-lock.yaml && -f node_modules/.modules.yaml && node_modules/.modules.yaml -nt pnpm-lock.yaml && node_modules/.modules.yaml -nt package.json ]]";
  suggestion = "Run 'pnpm install'";
}
```

**Explanation**

* `-f node_modules/.modules.yaml`: Verifies that `pnpm install` actually completed successfully.
* `node_modules/.modules.yaml -nt pnpm-lock.yaml`: Ensures the installed dependencies are newer than the lockfile.
* `node_modules/.modules.yaml -nt package.json`: Ensures the installed dependencies are newer than `package.json`.

{
  description = "Library for generating beautiful nix dev shell briefs";

  outputs =
    { ... }:
    {
      lib = import ./lib.nix { };
    };
}

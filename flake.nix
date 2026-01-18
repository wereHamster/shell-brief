{
  description = "Library for generating beautiful nix dev shell briefs";

  outputs = { self }: {
    lib = import ./lib.nix {};
  };
}

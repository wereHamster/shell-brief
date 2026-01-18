{
  description = "Library for generating beautiful nix dev shell briefs";

  outputs = { self }: {
    lib = pkgs: import ./lib.nix { inherit pkgs; };
  };
}

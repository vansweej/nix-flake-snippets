{
  description = "Local flake that uses github-flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    github-flake.url = "github:vansweej/nix-flake-snippets?dir=include_flake/github-flake";
  };

  outputs = { self, nixpkgs, github-flake, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.writeTextFile {
        name = "example-output";
        text = github-flake.lib.greet "Nix User";
      };
    };
}


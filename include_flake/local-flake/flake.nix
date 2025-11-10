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

      # Expose apps from github-flake
      apps.${system} = {
        # Expose the greet app from github-flake
        greet = github-flake.apps.${system}.greet;

        # Make greet the default app
        default = github-flake.apps.${system}.greet;

        # Wrap the app with custom behavior
        greet-custom = {
          type = "app";
          program = "${pkgs.writeShellScript "greet-wrapper" ''
            echo "Running greet app from github-flake:"
            ${github-flake.apps.${system}.greet.program} "Local Flake User"
          ''}";
        };
      };
    };
}
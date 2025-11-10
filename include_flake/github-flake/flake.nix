{
  description = "Reusable flake with a greet function and app";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      lib = { greet = name: "Hello, ${name}!"; };
      system = "x86_64-linux";

      greetScript = pkgs.writeShellScriptBin "greet" ''
        #!/usr/bin/env bash
        
        #set -euo pipefail

        name=$1
        if [ -z "$name" ]; then
          name="User"
        fi

        echo "${lib.greet "$name"}"
      '';

    in
    {
      lib = lib;

      packages.x86_64-linux.greet = greetScript;

      # App attached to a system — shows in nix flake show
      apps.${system}.greet = {
        type = "app";
        program = "${greetScript}/bin/greet";
      };
    };
}


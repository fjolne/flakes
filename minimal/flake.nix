{
  description = "Minimal template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = { };

        devShells = {
          default = pkgs.mkShell {
            packages = [ ];
            shellHook = ''
              echo hello
            '';
          };
        };
      });
}

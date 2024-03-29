{
  description = "Babashka template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs;
              [
                babashka
                clj-kondo   # supplied by Calva, but we need it to import configs
                clojure-lsp # supplied by Calva, so we don't need it
                just
              ];
          };
        };
      });
}

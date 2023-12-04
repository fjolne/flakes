{
  description = "Clojure template";

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
                jdk21
                clojure
                # NB: already supplied by Calva
                # clojure-lsp
                # NB: also supplied by Calva, but we need to import configs
                clj-kondo
                babashka
                neil
                just
              ];
          };
        };
      });
}

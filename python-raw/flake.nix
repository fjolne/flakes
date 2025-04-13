{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        python = pkgs.python312;
      in
      {
        devShells = with pkgs; {
          default = mkShell {
            packages = [
              pkgs-unstable.poetry
            ];
            shellHook = ''
              export LD_LIBRARY_PATH=${lib.makeLibraryPath [
                zlib
                stdenv.cc.cc.lib
                libGL
                glib
              ]}:$LD_LIBRARY_PATH

              [[ ! -d .venv ]] && poetry env use ${python}/bin/python && poetry install --no-root
              . $(dirname $(poetry env info --executable))/activate
              export PYTHONPATH=$(pwd):$PYTHONPATH
            '';
          };
        };
      });
}

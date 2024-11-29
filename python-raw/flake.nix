{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python313;
      in
      {
        devShells = with pkgs; {
          default = mkShell {
            packages = [
              poetry
            ];
            LD_LIBRARY_PATH = (lib.makeLibraryPath [
              zlib
              stdenv.cc.cc.lib
            ]);
            shellHook = ''
              poetry env use ${python}/bin/python
              poetry install --no-root
              export PYTHONPATH=$(pwd):$PYTHONPATH;
            '';
          };
        };
      });
}

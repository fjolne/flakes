{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              poetry
            ];
            LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
              stdenv.cc.cc.lib
              # zlib # numpy
            ];
            shellHook = ''
              poetry env use ${pkgs.python311}/bin/python
              poetry install --no-root
            '';
          };
        };
      });
}

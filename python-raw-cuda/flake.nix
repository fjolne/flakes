{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        python = pkgs.python311;
      in
      {
        devShells = with pkgs; {
          default = mkShell {
            packages = [
              poetry
              cudaPackages.cudatoolkit
            ];
            LD_LIBRARY_PATH = (lib.makeLibraryPath [
              zlib
              stdenv.cc.cc.lib
              addOpenGLRunpath.driverLink
              cudaPackages.cudatoolkit
            ]);
            CUDA_HOME = cudaPackages.cudatoolkit;
            shellHook = ''
              poetry env use ${python}/bin/python
              poetry install --no-root
              export PYTHONPATH=$(pwd):$PYTHONPATH;
            '';
          };
        };
      });
}

{
  description = "Python template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # config = {
          #   allowUnfree = true;
          #   cudaSupport = true;
          # };
        };
        python = pkgs.python311;
        libs = with pkgs; lib.makeLibraryPath [
          zlib # numpy
          stdenv.cc.cc.lib # torch
          addOpenGLRunpath.driverLink # torch.cuda
          # cudaPackages.libcublas.lib
        ];
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              (pkgs.writeShellScriptBin "python" ''
                export LD_LIBRARY_PATH=${libs}
                exec ${python}/bin/python "$@"
              '')
            ];
          };
        };
      });
}

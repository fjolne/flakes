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
        libs = with pkgs; lib.makeLibraryPath [
          zlib # numpy
          stdenv.cc.cc.lib # torch
          addOpenGLRunpath.driverLink # torch.cuda
          # cudaPackages.libcublas.lib
        ];
        py = pkgs.python311;
        python = pkgs.symlinkJoin {
          name = py.name + "-wow";
          paths = [
            (pkgs.writeShellScriptBin "python3.11" ''
              export LD_LIBRARY_PATH=${libs}
              exec ${py}/bin/python3.11 "$@"
            '')
            py
          ];
        };
        venv = ".venv";
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
            (pkgs.writeShellScriptBin "python" ''
              export LD_LIBRARY_PATH=${libs}
              exec ${py}/bin/python3.11 "$@"
            '')
            ];
            shellHook = ''
              rsync -a ${py}/ .venv && chmod -R 755 .venv
              # [[ ! -e ${venv} ]] && ${py}/bin/python -m venv ${venv}
              #                  # && ln -sf ${py}/bin/python3.11 ${venv}/bin/python3.11
              # # . .venv/bin/activate
            '';
          };
        };
      });
}

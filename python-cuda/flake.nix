{
  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = system != "aarch64-darwin";
          };
        };
        dirs-to-path = dirs: pkgs.lib.concatStringsSep ":" (map (dir: "$(pwd)/${dir}") dirs);
        py = (pkgs.python310.withPackages (ps: with ps; [
          ipykernel
          jupyter
          pip

          matplotlib
          numpy
          pandas
          polars
          pyarrow
          torch
        ]));
      in
      {
        devShells = {
          default = pkgs.mkShell {
            shellHook = ''
              export PYTHONPATH="${dirs-to-path []}"
              rm -rf .venv && ln -s ${py} .venv
            '';
            packages = with pkgs; [
              py
            ];
          };
        };
      });
}

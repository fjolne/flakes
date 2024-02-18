{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  inputs.nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree/nixos-23.11";
  inputs.nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  # inputs.nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree";
  # inputs.nixpkgs-unfree.inputs.nixpkgs.follows = "nixpkgs";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixpkgs-unfree, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        # pkgs = nixpkgs-unfree.legacyPackages.${system};
        dirs-to-path = dirs: pkgs.lib.concatStringsSep ":" (map (dir: "$(pwd)/${dir}") dirs);
        py = (pkgs.python311.withPackages (ps: with ps; [
          # ipykernel
          # jupyter
          # pip

          # matplotlib
          # numpy
          # pandas
          # polars
          # pyarrow
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

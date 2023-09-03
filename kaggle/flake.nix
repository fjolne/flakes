{
  description = "Kaggle template";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ poetry2nix.overlay ];
          # config.permittedInsecurePackages = [ "openssl-1.1.1u" ];
        };
        python = pkgs.python311;
        pypkgs-build-requirements = {
          # sklearn = [ "setuptools" ];
        };
        pypkgs-libs = with pkgs; [
        ];
      in
      {
        packages = rec {
          venv = pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
            preferWheels = true;
            python = python;
            overrides = pkgs.poetry2nix.overrides.withDefaults (self: super:
              builtins.mapAttrs
                (package: build-requirements:
                  (builtins.getAttr package super).overridePythonAttrs (old: {
                    buildInputs = (old.buildInputs or [ ]) ++ (builtins.map (pkg: builtins.getAttr pkg super) build-requirements);
                  }))
                pypkgs-build-requirements);
          };
        };

        devShells = {
          poetry = pkgs.mkShell {
            packages = [ pkgs.poetry ] ++ pypkgs-libs;
            shellHook = ''
              poetry env use ${python}/bin/python
            '';
          };

          default = pkgs.mkShell {
            packages = with pkgs;
              pypkgs-libs ++ [
                self.packages.${system}.venv
              ];
            shellHook = ''
              rm -rf .venv
              ln -s ${self.packages.${system}.venv} .venv
            '';
          };
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
      in
      {
        devShell = (pkgs.buildFHSUserEnv {
          name = "poetry-env";
          targetPkgs = pkgs: [
            pkgs.poetry
          ];
          runScript = "bash";
        }).env;
      });
}

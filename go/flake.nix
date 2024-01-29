{
  description = "Minimal template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go_1_20
              gopls # official language server
              gotools # goimports
              golangci-lint # linter
              delve # debugger
              go-tools # staticcheck
            ];
          };
        };
      });
}

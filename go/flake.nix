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
        lr = pkgs.buildGo122Module {
          name = "lr";
          src = ./.;
          vendorHash = "sha256-7qQ5aOFIan5EpWiXtQdVza8nroP/qGKew48d1t+QeVY=";
          CGO_ENABLED = 0;
          doCheck = false;
        };
      in
      {
        packages.default = lr;
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go_1_22
              gopls # official language server
              gotools # goimports
              golangci-lint # linter
              delve # debugger
              go-tools # staticcheck
              gore # repl
            ];
          };
        };
      });
}

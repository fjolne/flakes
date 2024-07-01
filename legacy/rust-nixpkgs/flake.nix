{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
      in
      {
        defaultPackage = naersk-lib.buildPackage ./.;
        devShell = with pkgs; mkShell {
          buildInputs = [
            cargo
            rustc
            rustfmt
            rust-analyzer
            pre-commit
            rustPackages.clippy
          ];
          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}

# TODO migrate to rust-overlay+crane:
# - https://github.com/DeterminateSystems/flake-checker/blob/main/flake.nix
# - https://github.com/DeterminateSystems/magic-nix-cache/blob/main/flake.nix
# or to fenix+naersk:
# - https://github.com/DeterminateSystems/nix-installer/blob/main/flake.nix

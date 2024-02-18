{
  description = "Minimal template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            rust-bin.beta.latest.default
          ];
        };
      }
    );
}

# TODO migrate to rust-overlay+crane:
# - https://github.com/DeterminateSystems/flake-checker/blob/main/flake.nix
# - https://github.com/DeterminateSystems/magic-nix-cache/blob/main/flake.nix
# or to fenix+naersk:
# - https://github.com/DeterminateSystems/nix-installer/blob/main/flake.nix

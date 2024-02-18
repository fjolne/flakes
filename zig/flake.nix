{
  description = "Minimal template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, zig, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ zig.overlays.default ];
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            pkgs.zigpkgs.master
          ];
        };
      }
    );
}

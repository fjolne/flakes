{
  description = "Minimal template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, nixpkgs, zig, zls, flake-utils, ... }:
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
          buildInputs = with pkgs; [
            zigpkgs.master
            zls.outputs.packages.${system}.default
          ];
        };
      }
    );
}

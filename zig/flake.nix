{
  description = "Minimal template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
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
          buildInputs = with pkgs; [
            zigpkgs."0.11.0"
            zls
          ];
        };
      }
    );
}

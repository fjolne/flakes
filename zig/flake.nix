{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, zig, zls, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # crossPkgs = import nixpkgs {
        #   inherit system;
        #   crossSystem = { system = "riscv32-none-elf"; };
        # };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            zig.packages.${system}.master
            zls.packages.${system}.default
            # pkgs.qemu
            # crossPkgs.stdenv.cc
          ];
        };
      }
    );
}

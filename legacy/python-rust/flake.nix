# From https://github.com/litchipi/nix-build-templates/blob/6e4961dc56a9bbfa3acf316d81861f5bd1ea37ca/rust/maturin.nix
# See also https://discourse.nixos.org/t/pyo3-maturin-python-native-dependency-management-vs-nixpkgs/21739/2
{
  # Build Pyo3 package
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };

        customRustToolchain = pkgs.rust-bin.stable."1.70.0".default;
        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain customRustToolchain;

        projectName = (craneLib.crateNameFromCargoToml { cargoToml = ./Cargo.toml; }).pname;
        projectVersion = (craneLib.crateNameFromCargoToml { cargoToml = ./Cargo.toml; }).version;

        pythonVersion = pkgs.python310;
        wheelSystem = {
          "x86_64-linux" = "manylinux_2_34_x86_64";
          "aarch64-linux" = "manylinux_2_34_aarch64";
        };
        wheelTail = "cp310-cp310-${wheelSystem.${system}}"; # Change if pythonVersion changes
        wheelName = "${projectName}-${projectVersion}-${wheelTail}.whl";

        # Build the library, then re-use the target dir to generate the wheel file with maturin
        crateWheel = (craneLib.buildPackage {
          pname = projectName;
          version = projectVersion;
          src = craneLib.cleanCargoSource (craneLib.path ./.);
          nativeBuildInputs = [ pythonVersion ];
        }).overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.maturin ];
          buildPhase = old.buildPhase + ''
            maturin build --offline --target-dir ./target
          '';
          installPhase = old.installPhase + ''
            cp target/wheels/${wheelName} $out/
          '';
        });
      in
      rec {
        packages = {
          default = crateWheel; # The wheel itself

          # A python version with the library installed
          pythonEnv = pythonVersion.withPackages
            (ps: [ (lib.pythonPackage ps) ] ++ (with ps; [ ipython ]));
        };

        lib = {
          # To use in other builds with the "withPackages" call
          pythonPackage = ps:
            ps.buildPythonPackage {
              pname = projectName;
              format = "wheel";
              version = projectVersion;
              src = "${crateWheel}/${wheelName}";
              doCheck = false;
              pythonImportsCheck = [ projectName ];
            };
        };

        devShells = rec {
          rust = pkgs.mkShell {
            name = "rust-env";
            src = ./.;
            nativeBuildInputs = with pkgs; [ pkg-config rust-analyzer maturin ];
          };
          python = pkgs.mkShell {
            name = "python-env";
            src = ./.;
            nativeBuildInputs = [ packages.pythonEnv ];
          };
          default = python;
        };

        apps = rec {
          ipython = {
            type = "app";
            program = "${packages.pythonEnv}/bin/ipython";
          };
          default = ipython;
        };
      });
}

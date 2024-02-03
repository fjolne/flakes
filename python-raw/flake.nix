{
  description = "Python template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        python = pkgs.python311;
      in
      {
        packages = { };

        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              poetry
            ];
            LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
              zlib # numpy
              stdenv.cc.cc.lib # torch
              addOpenGLRunpath.driverLink # torch.cuda
              # cudaPackages.libcublas.lib
            ];
            shellHook = ''
              poetry env use ${python}/bin/python
            '';
          };
        };
      });
}

      # customOverrides = self: super: {
      #   nvidia-cudnn-cu11 = super.nvidia-cudnn-cu11.overridePythonAttrs (attrs: {
      #     nativeBuildInputs = attrs.nativeBuildInputs or [ ] ++ [ pkgs.autoPatchelfHook ];
      #     preFixup = ''
      #       addAutoPatchelfSearchPath "${self.nvidia-cublas-cu11}/${self.python.sitePackages}/nvidia/cublas/lib"
      #     '';
      #     propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [
      #       self.nvidia-cublas-cu11
      #     ];
      #   });

      #   torch = super.torch.overridePythonAttrs (attrs: {
      #     nativeBuildInputs = attrs.nativeBuildInputs or [ ] ++ [ pkgs.autoPatchelfHook ];
      #     buildInputs = attrs.buildInputs or [ ] ++ [
      #       self.nvidia-cudnn-cu11
      #       self.nvidia-cuda-nvrtc-cu11
      #       self.nvidia-cuda-runtime-cu11
      #     ];
      #     postInstall = ''
      #       addAutoPatchelfSearchPath "${self.nvidia-cublas-cu11}/${self.python.sitePackages}/nvidia/cublas/lib"
      #       addAutoPatchelfSearchPath "${self.nvidia-cudnn-cu11}/${self.python.sitePackages}/nvidia/cudnn/lib"
      #       addAutoPatchelfSearchPath "${self.nvidia-cuda-nvrtc-cu11}/${self.python.sitePackages}/nvidia/cuda_nvrtc/lib"
      #     '';
      #   });
      # };

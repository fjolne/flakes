{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {
      minimal = {
        path = ./minimal;
        description = "Minimal template";
      };

      python-poetry2nix = {
        path = ./python-poetry2nix;
        description = "Python template, using poetry2nix";
      };

      python-cuda = {
        path = ./python-cuda;
        description = "Python CUDA template, using nixpkgs";
      };

      python-raw = {
        path = ./python-raw;
        description = "Python using raw poetry, nothing else";
      };

      python-raw-cuda = {
        path = ./python-raw-cuda;
        description = "Python using raw poetry, with CUDA support";
      };

      clojure = {
        path = ./clojure;
        description = "Clojure template, using deps.edn";
      };

      rust-overlay = {
        path = ./rust-overlay;
        description = "Rust template, using rust-overlay";
      };

      rust-nixpkgs = {
        path = ./rust-nixpkgs;
        description = "Rust template, using nixpkgs";
      };

      rust-cf = {
        path = ./rust-cf;
        description = "Rust template for Codeforces";
      };

      typescript = {
        path = ./typescript;
        description = "Typescript template, using npm";
      };

      go = {
        path = ./go;
        description = "Golang template";
      };

      zig = {
        path = ./zig;
        description = "Zig template";
      };
    };

    defaultTemplate = self.templates.kaggle;

  };
}

{
  outputs = { self }: {
    templates = {
      minimal = {
        path = ./minimal;
        description = "Minimal template";
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
  };
}

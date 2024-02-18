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
        description = "Python using raw poetry, with CUDA support";
      };

      clojure = {
        path = ./clojure;
        description = "Clojure template, using deps.edn";
      };

      typescript = {
        path = ./typescript;
        description = "Typescript template, using npm";
      };

      go = {
        path = ./go;
        description = "Golang template";
      };
    };

    defaultTemplate = self.templates.kaggle;

  };
}

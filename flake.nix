{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {
      minimal = {
        path = ./minimal;
        description = "Minimal template";
      };

      kaggle = {
        path = ./kaggle;
        description = "Kaggle template, using poetry2nix";
      };

      python-cuda = {
        path = ./python-cuda;
        description = "Python CUDA template, using nixpkgs";
      };

      clojure = {
        path = ./clojure;
        description = "Clojure template, using deps.edn";
      };

      typescript = {
        path = ./typescript;
        description = "Typescript template, using npm";
      };
    };

    defaultTemplate = self.templates.kaggle;

  };
}

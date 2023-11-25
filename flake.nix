{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {
      kaggle = {
        path = ./kaggle;
        description = "Kaggle template, using poetry2nix";
      };

      clojure = {
        path = ./clojure;
        description = "Clojure template, using deps.edn";
      };
    };

    defaultTemplate = self.templates.kaggle;

  };
}

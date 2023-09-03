{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {
      kaggle = {
        path = ./kaggle;
        description = "Kaggle template, using poetry2nix";
      };
    };

    defaultTemplate = self.templates.kaggle;

  };
}

{
  outputs = { self }: {
    templates = {
      latex = {
        path = ./templates/latex;
        description = "A flake you can use to kickstart a latex project";
      };
      haskell = {
        path = ./templates/haskell;
        description = "A flake you can use to kickstart a haskell project";
      };
    };
  };
}

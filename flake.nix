{
  outputs = { self }: {
    templates = {
      setup = {
        path = ./templates/latex;
        description = "A flake you can use to kickstart a latex project";
      };
    };
  };
}

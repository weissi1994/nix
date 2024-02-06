{
  plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      indent = true;
    };
    treesitter-context.enable = true;
    ts-context-commentstring.enable = true;
    treesitter-textobjects.enable = true;
    rainbow-delimiters.enable = true;
  };
}

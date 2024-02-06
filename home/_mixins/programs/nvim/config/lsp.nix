{
  plugins.lsp = {
    enable = true;
    servers = {
      ansiblels.enable = true;
      bashls.enable = true;
      clangd.enable = true;
      cmake.enable = true;
      csharp-ls.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      fsautocomplete.enable = true;
      gopls.enable = true;
      helm-ls.enable = true;
      html.enable = true;
      intelephense.enable = true;
      jsonls.enable = true;
      lua-ls.enable = true;
      marksman.enable = true;
      nil_ls.enable = true;
      nixd.enable = true;
      solargraph.enable = true;
      omnisharp.enable = true;
      pylsp.enable = true;
      ruff-lsp.enable = true;
      rust-analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
      terraformls.enable = true;
      tsserver.enable = true;
      yamlls.enable = true;
    };
    keymaps.lspBuf = {
      "gd" = "definition";
      "gD" = "references";
      "gt" = "type_definition";
      "gi" = "implementation";
      "K" = "hover";
    };
  };
  plugins.rust-tools.enable = true;
}

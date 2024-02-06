{
  imports = [
    ./cmp.nix
    ./options.nix
    ./telescope.nix
    ./filetree.nix
    ./none-ls.nix
    ./extras.nix
    ./lsp.nix
    ./treesitter.nix
  ];

  colorschemes.catppuccin.enable = true;
  colorschemes.catppuccin.flavour = "mocha";

  plugins = {
    dap.enable = true;
    helm.enable = true;
    mini.enable = true;
    mini.modules = {
      surround = { };
      indentscope = {
        symbol = "│";
        options = { try_as_border = true; };
      };
      bufremove = { };
    };
    auto-save = {
      enable = true;
      enableAutoSave = true;
    };
    lualine.enable = true;
    lualine.globalstatus = true;
    floaterm.enable = true;
    nvim-autopairs.enable = true;
    bufferline.enable = true;
    bufferline.diagnostics = "nvim_lsp";
    gitsigns = {
      enable = true;
      currentLineBlame = true;
    };
    noice.enable = true;
    lastplace.enable = true;
    notify.enable = true;
    nvim-colorizer.enable = true;
    todo-comments.enable = true;
    obsidian.enable = true;
    surround.enable = true;
    tmux-navigator.enable = true;
    indent-blankline.enable = true;
    illuminate.enable = true;
    which-key.enable = true;
  };

  keymaps = [
    # Global Mappings
    # Default mode is "" which means normal-visual-op
    {
      # Toggle NvimTree
      key = "<C-n>";
      action = "<CMD>Neotree toggle<CR>";
    }
    {
      key = "<space>e";
      action = "<CMD>Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Toggle Neotree";
      };
    }
    {
      # Toggle Lazygit
      key = "<space>gg";
      action = "<CMD>LazyGit<CR>";
    }
    {
      # Format file
      key = "<space>ff";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
    }
    {
      # Start standalone rust-analyzer (fixes issues when opening files from nvim tree)
      mode = "i";
      key = "<Tab>";
      action = "<CMD>RustStartStandaloneServerForBuffer<CR>";
    }
    # Move Lines
    {
      mode = "n";
      key = "<A-Down>";
      action = "<cmd>m .+1<cr>==";
      options = {
        silent = true;
        desc = "Move down";
      };
    }
    {
      mode = "n";
      key = "<A-Up>";
      action = "<cmd>m .-2<cr>==";
      options = {
        silent = true;
        desc = "Move up";
      };
    }
    {
      mode = "i";
      key = "<A-Down>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {
        silent = true;
        desc = "Move down";
      };
    }
    {
      mode = "i";
      key = "<A-Up>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {
        silent = true;
        desc = "Move up";
      };
    }
    {
      mode = "v";
      key = "<A-Down>";
      action = ":m '>+1<cr>gv=gv";
      options = {
        silent = true;
        desc = "Move down";
      };
    }
    {
      mode = "v";
      key = "<A-Up>";
      action = ":m '<-2<cr>gv=gv";
      options = {
        silent = true;
        desc = "Move up";
      };
    }
    # better indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = {
        silent = true;
      };
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = {
        silent = true;
      };
    }
    # Terminal Mappings
    {
      # Escape terminal mode using ESC
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
    }

    # Rust
    {
      # Start standalone rust-analyzer (fixes issues when opening files from nvim tree)
      mode = "n";
      key = "<leader>rs";
      action = "<CMD>RustStartStandaloneServerForBuffer<CR>";
    }

    # Navigation
    {
      mode = "n";
      key = "<C-Left>";
      action = "<C-w>h";
      options = {
        remap = true;
        silent = true;
        desc = "Go to left window";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<C-w>j";
      options = {
        remap = true;
        silent = true;
        desc = "Go to lower window";
      };
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<C-w>k";
      options = {
        remap = true;
        silent = true;
        desc = "Go to upper window";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<C-w>l";
      options = {
        remap = true;
        silent = true;
        desc = "Go to right window";
      };
    }
    {
      mode = "n";
      key = "<A-Right>";
      action = "<cmd>bnext<cr>";
      options = {
        silent = true;
        desc = "Next Tab";
      };
    }
    {
      mode = "n";
      key = "<A-Left>";
      action = "<cmd>bprevious<cr>";
      options = {
        silent = true;
        desc = "Previous Tab";
      };
    }

    # {
    #   # Mode can be a string or a list of strings
    #   mode = "n";
    #   key = "<leader>p";
    #   action = "require('my-plugin').do_stuff";
    #   lua = true;
    #   # Note that all of the mapping options are now under the `options` attrs
    #   options = {
    #     silent = true;
    #     desc = "My plugin does stuff";
    #   };
    # }
  ];

}

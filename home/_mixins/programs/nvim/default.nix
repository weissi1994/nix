{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    options = import ./config/options.nix;
    colorschemes = import ./config/colorschemes.nix;

    plugins = {
      dap.enable = true;
      # helm.enable = true;
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
      # obsidian.enable = true;
      surround.enable = true;
      tmux-navigator.enable = true;
      indent-blankline.enable = true;
      illuminate.enable = true;
      which-key.enable = true;
      copilot-lua = {
        enable = true;
        suggestion.enabled = false;
        panel.enabled = false;
      };
      luasnip.enable = true;
      cmp-buffer = { enable = true; };

      cmp-emoji = { enable = true; };

      cmp-nvim-lsp = { enable = true; };

      cmp-path = { enable = true; };

      cmp_luasnip = { enable = true; };

      nvim-cmp = {
        enable = true;
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "copilot"; }
          { name = "buffer"; }
          { name = "nvim_lua"; }
          { name = "path"; }
        ];

        formatting = {
          fields = [ "abbr" "kind" "menu" ];
          format =
            # lua
            ''
              function(_, item)
                local icons = {
                  Namespace = "󰌗",
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰆧",
                  Constructor = "",
                  Field = "󰜢",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈚",
                  Reference = "󰈇",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "󰙅",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰊄",
                  Table = "",
                  Object = "󰅩",
                  Tag = "",
                  Array = "[]",
                  Boolean = "",
                  Number = "",
                  Null = "󰟢",
                  String = "󰉿",
                  Calendar = "",
                  Watch = "󰥔",
                  Package = "",
                  Copilot = "",
                  Codeium = "",
                  TabNine = "",
                }

                local icon = icons[item.kind] or ""
                item.kind = string.format("%s %s", icon, item.kind or "")
                return item
              end
            '';
        };

        snippet = { expand = "luasnip"; };

        window = {
          completion = {
            winhighlight =
              "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
            scrollbar = false;
            sidePadding = 0;
            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
          };

          documentation = {
            border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
            winhighlight =
              "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
          };
        };

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" =
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action =
              # lua
              ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                  else
                    fallback()
                  end
                end
              '';
          };
          "<S-Tab>" = {
            modes = [ "i" "s" ];
            action =
              # lua
              ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                  else
                    fallback()
                  end
                end
              '';
          };
        };
      };

      neo-tree = {
        enable = true;
        sources = ["filesystem" "buffers" "git_status" "document_symbols"];
        filesystem = {
          bindToCwd = false;
          followCurrentFile = { enabled = true; };
          useLibuvFileWatcher = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          # ansiblels.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          csharp-ls.enable = true;
          cssls.enable = true;
          # dockerls.enable = true;
          eslint.enable = true;
          fsautocomplete.enable = true;
          gopls.enable = true;
          # helm-ls.enable = true;
          html.enable = true;
          intelephense.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          # marksman.enable = true;
          nil_ls.enable = true;
          nixd.enable = true;
          # solargraph.enable = true;
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
      rust-tools.enable = true;

      none-ls = {
        enable = true;
        sources = {
          diagnostics = {
            golangci_lint.enable = true;
            ktlint.enable = true;
            shellcheck.enable = true;
            statix.enable = true;
          };
          formatting = {
            fantomas.enable = true;
            gofmt.enable = true;
            # goimports.enable = true;
            ktlint.enable = true;
            nixfmt.enable = true;
            markdownlint.enable = true;
            rustfmt.enable = true;
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            desc = "Telescope Git Files";
          };
        };
        extensions.fzf-native = { enable = true; };
        # extensions.ui-select.enable = true;
      };

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


    extraPlugins = with pkgs.vimPlugins; [
      vim-helm
      vim-kitty-navigator
      lazygit-nvim
      vim-puppet
      vim-ruby
      plenary-nvim
      nui-nvim
      nvim-web-devicons
    ];
  };
}

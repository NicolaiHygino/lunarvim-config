--[
--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

lvim.colorscheme = "lunar"
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.transparent_window = true
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

lvim.builtin.which_key.mappings["n"] = {
    name = "Neotest",
    c = { '<cmd>lua require("neotest").run.run()<cr>', "Run the nearest test" },
}

-- keymaps for Spectre
lvim.builtin.which_key.mappings["k"] = {
    name = "+Spectre",
    s = { "<cmd>lua require('spectre').open()<CR>", "Spectre" },
    f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Search in file" },
    w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
}

-- persistence keymaps
lvim.builtin.which_key.mappings["S"] = {
    name = "Session",
    c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
    l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
    Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.open_mapping = [[<C-\>]]
lvim.builtin.terminal.size = 15
lvim.builtin.terminal.auto_scroll = false
lvim.builtin.nvimtree.setup.renderer.icons.show.folder_arrow = false
-- lvim.builtin.nvimtree.setup.renderer.group_empty = true
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--   "rust-analyzer",
-- "jdtls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "sumeko_lua" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        command = "prettier",
        extra_args = {
            "--print-with=100",
        },
        filetypes = { "typescript", "typescriptreact" },
    },
}


local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    {
        command = "eslint_d",
        filetypes = { "typescript", "typescriptreact" },
    },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
    commands = "eslint_d",
    filetypes = { "typescript", "typescriptreact" }
}

lvim.plugins = {
    { "catppuccin/nvim" },
    { 'mg979/vim-visual-multi' },
    -- { 'ggandor/leap.nvim',
    --   config = function()
    --     require('leap').add_default_mappings()
    --   end
    -- },
    {
        "windwp/nvim-spectre",
        event = "BufRead",
        config = function()
          require("spectre").setup()
        end,
    },
    {
        "f-person/git-blame.nvim",
        event = "BufRead",
        config = function()
          vim.cmd "highlight default link gitblame SpecialComment"
          vim.g.gitblame_enabled = 0
        end,
    },
    {
        "echasnovski/mini.map",
        branch = "stable",
        config = function()
          require('mini.map').setup()
          local map = require('mini.map')
          map.setup({
              integrations = {
                  map.gen_integration.builtin_search(),
                  map.gen_integration.diagnostic({
                      error = 'DiagnosticFloatingError',
                      warn  = 'DiagnosticFloatingWarn',
                      info  = 'DiagnosticFloatingInfo',
                      hint  = 'DiagnosticFloatingHint',
                  }),
              },
              symbols = {
                  encode = map.gen_encode_symbols.dot('4x2'),
              },
              window = {
                  side = 'right',
                  width = 3, -- set to 1 for a pure scrollbar :)
                  winblend = 15,
                  show_integration_count = false,
              },
          })
        end
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        module = "persistence",
        config = function()
          require("persistence").setup {
              dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
              options = { "buffers", "curdir", "tabpages", "winsize" },
          }
        end,
    },
    -- {
    --   "ggandor/leap.nvim",
    --   config = function()
    --     require("leap").add_default_mappings()
    --   end
    -- }
}
-- UNCOMMENT AFTER INSTALLATION OF MINI.MAP
-- Mini.map configuration
lvim.autocommands = {
    {
        { "BufEnter", "Filetype" },
        {
            desc = "Open mini.map and exclude some filetypes",
            pattern = { "*" },
            callback = function()
              local exclude_ft = {
                  "qf",
                  "NvimTree",
                  "toggleterm",
                  "TelescopePrompt",
                  "alpha",
                  "netrw",
              }

              local map = require('mini.map')
              if vim.tbl_contains(exclude_ft, vim.o.filetype) then
                vim.b.minimap_disable = true
                map.close()
              elseif vim.o.buftype == "" then
                map.open()
              end
            end,
        },
    },
}

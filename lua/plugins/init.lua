return {
    -- Dependencies used multiple plugins
    { "nvim-lua/plenary.nvim", lazy = true },
    { "kyazdani42/nvim-web-devicons", lazy = true },

    -- QoL
    {
        "numToStr/Comment.nvim",
        config = true,
        keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
        dependencies = { "nvim-treesitter", "nvim-cmp" },
    },
    { "kylechui/nvim-surround", version = "*", config = true, event = "VeryLazy" },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<c-\>]],
            direction = "float",
        },
        keys = { [[<c-\>]] },
        cmd = {
            "ToggleTerm",
            "TermExec",
            "ToggleTermToggleAll",
            "ToggleTermSendCurrentLine",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
        },
    },
    {
        "Wansmer/treesj",
        dependencies = "nvim-treesitter",
        keys = {
            { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },
    {
        "ThePrimeagen/harpoon",
        opts = {
            -- Use a dynamic width for the Harpoon popup menu
            menu = {
                width = vim.api.nvim_win_get_width(0) - 4,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Add file to Harpoon" },
            { "<leader>hi", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon UI" },
            { "<leader>hh", function() require("harpoon.ui").nav_next() end, desc = "Next Harpoon file" },
            { "<leader>hl", function() require("harpoon.ui").nav_next() end, desc = "Prev Harpoon file" },
            { "<leader>h1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file #1" },
            { "<leader>h2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file #2" },
            { "<leader>h3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file #3" },
            { "<leader>h4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file #4" },
            { "<leader>fm", ":Telescope harpoon marks<cr>" },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo Tree" },
        },
        cmd = { "UndotreeToggle" },
    },

    -- UI / UX
    {
        "goolord/alpha-nvim",
        config = function()
            require("config.dashboard")
        end,
        event = "VimEnter",
    },
    { "chentoast/marks.nvim", opts = { signs = true, mappings = {} }, event = "BufEnter" },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
        },
        event = "VimEnter",
    },
    {
        "Shatur/neovim-session-manager",
        config = function()
            require("session_manager").setup({
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
            })
        end,
        keys = {
            { "<leader>ss", ":SessionManager save_current_session<cr>", desc = "Save Session" },
            { "<leader>sl", ":SessionManager load_current_dir_session<cr>", desc = "Load Session" },
        },
        event = "VimEnter",
    },
    { "stevearc/dressing.nvim", event = "VeryLazy" },
    { "mechatroner/rainbow_csv", event = "BufEnter *.csv" },
    { "anuvyklack/pretty-fold.nvim", config = true, event = "BufEnter" },
    {
        "anuvyklack/fold-preview.nvim",
        dependencies = { "anuvyklack/keymap-amend.nvim" },
        config = true,
        event = "BufEnter",
    },
    { "ellisonleao/glow.nvim", cmd = { "Glow" }, config = true },
    { "norcalli/nvim-colorizer.lua", config = true, event = "VeryLazy" },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- Git / GitHub
    { "tpope/vim-fugitive", cmd = { "G", "Git" } },
    { "tpope/vim-rhubarb", cmd = { "GBrowse" } },
    -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-sleuth" },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next Hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous Hunk" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage Hunk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset Hunk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "Blame Line" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "Diff This" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle Deleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
            end,
        },
    },
    { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },
    -- { "github/copilot.vim" },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<M-Tab>",
                    accept_word = "<M-w>",
                    accept_line = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            panel = {
                enabled = true,
                auto_refresh = false,
            },
        },
    },
    { "wintermute-cell/gitignore.nvim", cmd = { "Gitignore" } },
}

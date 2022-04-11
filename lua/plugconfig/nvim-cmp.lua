vim.o.completeopt = "menu,menuone,noselect"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp = require("cmp")

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
    ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
    ["<Down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
    ["<Up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping(
      {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      }
    ),
    ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true}),
    ["<Tab>"] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      {"i", "s"}
    ),
    ["<S-Tab>"] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      {"i", "s"}
    )
  },
  sources = cmp.config.sources(
    {
      {name = "nvim_lsp"},
      {name = "luasnip"}
    },
    {
      {name = "buffer"},
      {name = "path"},
      {name = "calc"},
      {name = "emoji"}
    }
  ),
  formatting = {
    format = lspkind.cmp_format(
      {
        mode = "symbol_text"
      }
    )
  }
}

-- git
cmp.setup.filetype(
  "gitcommit",
  {
    sources = cmp.config.sources(
      {
        {name = "cmp_git"}
      },
      {
        {name = "buffer"}
      }
    )
  }
)

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/",
  {
    sources = {
      {name = "buffer"}
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  {
    sources = cmp.config.sources(
      {
        {name = "path"}
      },
      {
        {name = "cmdline"}
      }
    )
  }
)

require("luasnip.loaders.from_vscode").load()

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))

-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
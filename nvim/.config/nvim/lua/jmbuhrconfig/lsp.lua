local lspconfig = require('lspconfig')
local cmp = require('cmp_nvim_lsp')
local configs = require'lspconfig.configs'
local util = require("lspconfig.util")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  client.resolved_capabilities.document_formatting = true
end

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border })


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp.update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.vimls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  }
}

lspconfig.r_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  }
}

lspconfig.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  }
}


lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  },
  root_dir = function(fname)
    return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or
    util.path.dirname(fname)
  end
}

lspconfig.hls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  }
}

lspconfig.diagnosticls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  init_options = {
    formatters = {
      black = {
        command = "black",
        args = {"--quiet", "-"},
        rootPatterns = {".git", "pyproject.toml", "setup.py", "tox."},
      },
      formatFiletypes = {
        python = {"black"}
      }
    }
  }
}

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 250,
  },
  settings = {
    yaml = {
      format = {enable = false},
    },
  },
}

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim', 'table', 'string', 'R', 'P' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.svelte.setup{}

if not lspconfig.emmet_ls then
  configs.emmet_ls = {
    default_config = {
      cmd = {'emmet-ls', '--stdio'};
      filetypes = {'html', 'css', 'blade', 'jsx', 'xml', 'scss'};
      root_dir = function(fname)
        return vim.loop.cwd()
      end;
      settings = {};
    };
  }
end
lspconfig.emmet_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}


lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "rustup", "run", "nightly", "rust-analyzer"},
}

lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.denols.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.csharp_ls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {'csharp-ls'},
  flags = {
    debounce_text_changes = 250,
  },
  -- root_dir = function(fname)
  --   vim.notify("searching root dir for"..fname)
  --   -- return fname..'../'
  --   -- return util.root_pattern(".sln", ".csproj")(fname) or
  --   -- util.path.dirname(fname)
  -- end
}

lspconfig.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- lspconfig.ccls.setup{}

-- local pid = vim.fn.getpid()
-- local omnisharp_bin = "/home/jannik/bin/omnisharp/run"
--
-- lspconfig.omnisharp.setup{
--     cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }



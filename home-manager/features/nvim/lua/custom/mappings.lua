---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = {
      ":",
      "enter command mode",
      opts = { nowait = true }
    },
    ["<leader>s"] = {
      ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
      "Replace text",
      opts = { silent = true }
    },
    ["Q"] = {
      "<nop>"
    },
  },
  v = {
    ["J"] = {
      ":m '>+1<CR>gv=gv",
      "Move text down",
    },
    ["K"] = {
      ":m '<-2<CR>gv=gv",
      "Move text up",
    },
    ["<"] = {
      "<gv",
      "De-indent",
    },
    [">"] = {
      ">gv",
      "Indent",
    },
  },
}

M.dap = {
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Toggle breakpoint"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.crates = {
  n = {
    ["<leader>cv"] = {
      function ()
        require('crates').show_versions_popup()
      end,
      "Show versions"
    },
    ["<leader>cf"] = {
      function ()
        require('crates').show_features_popup()
      end,
      "Show features"
    },
        ["<leader>cd"] = {
      function ()
        require('crates').show_dependencies_popup()
      end,
      "Show dependencies"
    },
    ["<leader>cu"] = {
      function ()
        require('crates').update_crate()
      end,
      "Update crate"
    },
    ["<leader>ca"] = {
      function ()
        require('crates').update_all_crates()
      end,
      "Update all crates"
    },
    ["<leader>cU"] = {
      function ()
        require('crates').upgrade_crate()
      end,
      "Upgrade crate"
    },
    ["<leader>cA"] = {
      function ()
        require('crates').upgrade_all_crates()
      end,
      "Upgrade all crates"
    },
    ["<leader>cH"] = {
      function ()
        require('crates').open_homepage()
      end,
      "Open homepage"
    },
    ["<leader>cR"] = {
      function ()
        require('crates').open_repository()
      end,
      "Open repository"
    },
    ["<leader>cD"] = {
      function ()
        require('crates').open_documentation()
      end,
      "Open documentation"
    },
    ["<leader>cC"] = {
      function ()
        require('crates').open_crates_io()
      end,
      "Open crates io"
    },
  },
  v = {
    ["<leader>cu"] = {
      function ()
        require('crates').update_crates()
      end,
      "Update crates"
    },
    ["<leader>cU"] = {
      function ()
        require('crates').upgrade_crates()
      end,
      "Upgrade crates"
    },
  }
}

return M

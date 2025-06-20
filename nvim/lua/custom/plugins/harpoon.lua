return {
  'ThePrimeagen/harpoon',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'
    vim.keymap.set('n', '<leader>f', mark.add_file, { desc = 'Add file to harpoon' })
    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

    local function setup_harpoon_keys()
      local ok, harpoon = pcall(require, 'harpoon')
      if not ok then
        vim.notify('harpoon not installed', vim.log.levels.ERROR)
        return
      end

      ---------------------------------------------------------------------------
      -- 1.  BOOTSTRAP (only needed for Harpoon v2)
      ---------------------------------------------------------------------------
      if harpoon.list and not harpoon._current then
        harpoon:setup {} -- colon-call is required :contentReference[oaicite:0]{index=0}
      end

      ---------------------------------------------------------------------------
      -- 2.  HELPER → resolve filename for a slot, regardless of Harpoon version
      ---------------------------------------------------------------------------
      local function fname(i)
        -- v2 API ---------------------------------------------------------------
        if harpoon.list then
          local item = (harpoon:list().items or {})[i] -- colon-call = method :contentReference[oaicite:1]{index=1}
          return item and vim.fn.fnamemodify(item.value, ':~:.') or '<empty>'
        end
        -- v1 fallback ----------------------------------------------------------
        local ok_mark, mark = pcall(require, 'harpoon.mark')
        if ok_mark and mark.get_marked_file_name then
          local p = mark.get_marked_file_name(i)
          return p ~= '' and vim.fn.fnamemodify(p, ':~:.') or '<empty>'
        end
        return '<empty>'
      end

      ---------------------------------------------------------------------------
      -- 3.  (RE)CREATE THE ACTUAL KEYMAPS
      ---------------------------------------------------------------------------
      for i = 1, 5 do
        local lhs = ('<leader>%d'):format(i)
        vim.keymap.set('n', lhs, function()
          if harpoon.list then -- v2
            harpoon:list():select(i) -- same call used by LazyVim example :contentReference[oaicite:2]{index=2}
          else -- v1
            require('harpoon.ui').nav_file(i)
          end
        end, {
          desc = ('Harpoon %d → %s'):format(i, fname(i)),
          noremap = true,
          silent = true,
        })
      end
    end

    -- First registration on startup
    setup_harpoon_keys()

    -------------------------------------------------------------------------------
    -- 4.  AUTO-REFRESH THE DESCRIPTIONS WHEN THE LIST CHANGES
    -------------------------------------------------------------------------------
    -- a) Harpoon v2 emits Lua events via `harpoon.extensions`
    pcall(function()
      local Extensions = require 'harpoon.extensions'
      for _, ev in ipairs { Extensions.event_names.APPEND, Extensions.event_names.REMOVE } do
        Extensions.extensions:subscribe(ev, setup_harpoon_keys)
      end
    end)

    -- b) Harpoon v1 – simple User autocommand triggered by its marking function
    vim.api.nvim_create_autocmd('User', {
      pattern = 'HarpoonAfterMark',
      callback = setup_harpoon_keys,
    })
  end,
}

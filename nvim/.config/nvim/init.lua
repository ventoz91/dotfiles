-- =============================================================================
-- OPTIONS
-- =============================================================================
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Line numbers
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"

-- Indentation (4 spaces)
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true
opt.inccommand = "split"   -- live preview of :s substitutions

-- UI
opt.wrap        = false
opt.scrolloff   = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.list        = true
opt.listchars   = { tab = "» ", trail = "·", nbsp = "␣" }
opt.splitright  = true
opt.splitbelow  = true
opt.showmode    = false    -- mode shown in statusline instead

-- Files
opt.undofile  = true       -- persistent undo (~/.local/state/nvim/undo/)
opt.swapfile  = false
opt.backup    = false

-- Misc
opt.mouse       = "a"
opt.clipboard   = "unnamedplus"   -- uses wl-clipboard
opt.updatetime  = 250
opt.timeoutlen  = 300

-- Colorscheme (dark built-in)
vim.cmd.colorscheme("habamax")

-- =============================================================================
-- KEYMAPS
-- =============================================================================
local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>",  "Write file")
map("n", "<leader>q", "<cmd>quit<CR>",   "Quit")
map("n", "<leader>Q", "<cmd>qall!<CR>",  "Quit all")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-l>", "<C-w>l", "Move to right window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")

-- Window resize
map("n", "<C-Up>",    "<cmd>resize +2<CR>",           "Increase window height")
map("n", "<C-Down>",  "<cmd>resize -2<CR>",           "Decrease window height")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>",  "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>",  "Increase window width")

-- Buffer nav
map("n", "[b",        "<cmd>bprevious<CR>", "Previous buffer")
map("n", "]b",        "<cmd>bnext<CR>",     "Next buffer")
map("n", "<leader>bd","<cmd>bdelete<CR>",   "Delete buffer")

-- Scroll and keep cursor centered
map("n", "<C-d>", "<C-d>zz",  "Scroll down (centered)")
map("n", "<C-u>", "<C-u>zz",  "Scroll up (centered)")
map("n", "n",     "nzzzv",    "Next match (centered)")
map("n", "N",     "Nzzzv",    "Prev match (centered)")

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Indent without losing selection
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")

-- Paste over selection without losing register
map("x", "<leader>p", '"_dP', "Paste without overwriting register")

-- Diagnostics
map("n", "[d",        vim.diagnostic.goto_prev,  "Previous diagnostic")
map("n", "]d",        vim.diagnostic.goto_next,  "Next diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic float")

-- =============================================================================
-- AUTOCMDS
-- =============================================================================
local augroup  = vim.api.nvim_create_augroup
local autocmd  = vim.api.nvim_create_autocmd

-- Flash yanked region
autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- Strip trailing whitespace on save
autocmd("BufWritePre", {
    group = augroup("trim_whitespace", { clear = true }),
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- Restore last cursor position when reopening a file
autocmd("BufReadPost", {
    group = augroup("restore_cursor", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Equalise splits when the terminal window is resized
autocmd("VimResized", {
    group = augroup("resize_splits", { clear = true }),
    command = "tabdo wincmd =",
})

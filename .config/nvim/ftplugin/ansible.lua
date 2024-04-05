local api = vim.api
if vim.fn.executable('ansible-doc') then
  vim.bo.keywordprg = ':sp term://ansible-doc'
end
local fname = api.nvim_buf_get_name(0)
if fname:find('tasks/') then
  local paths = {
    vim.bo.path,
    vim.fs.dirname(fname:gsub("tasks/", "files/")),
    vim.fs.dirname(fname)
  }
  vim.bo.path = table.concat(paths, ",")
end

vim.bo.iskeyword = "@,48-57,_,192-255,."
vim.keymap.set('v', '<leader>te', function() require('ansible').run() end, { buffer = true, silent = true })
vim.keymap.set('n', '<leader>te', ":w<CR> :lua require('ansible').run()<CR>", { buffer = true, silent = true })

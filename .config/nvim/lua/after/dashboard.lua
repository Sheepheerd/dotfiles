require('dashboard').setup({
    theme = 'hyper',
    config = {
      week_header = {
       enable = true,
      },
      shortcut = {
        { desc = '󰊳 Update', group = '@property', action = 'PlugInstall', key = 'u' },
        {
          icon = ' ',
          icon_hl = '@variable',
          desc = 'Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          action = 'Config',
          key = 'd',
        },
      },
    footer = {"Why? To Prove Nick Wrong"}
    },
  })


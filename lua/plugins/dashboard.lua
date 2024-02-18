return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local logo = [[
                                                                          !7777!YJ                                                                                           
                                                                     !7777!~~^~J?^                                                                                           
                                                                 !7???7!!~^^^757^                                                                                            
                                                              7???77!!77~^^~??~^                                                                                             
                                                          7???77!!777777!!?Y?^^               !!                                                                             
                                                       ???777!!777777777!JYJ!          !!!777!!!                                                                             
                                                     ?J77!!!7777777!!7777J?!!!!!7?JYY55PGG?!!                                                                                
                                                   !J?!!77J?!77!!777??77777?Y5PG##&&&@@@#J^                                                                                  
                                                   J77??7JJ7!!7??7!!7?YPG#&@@@&&&###&@#Y~                                                                                    
                                                 JJ7?7!~?JJ77?7~!?P#&@@&&&#######B&&BJ~                                                                                      
                                                JY7!~^^~!?YJ7~7P&@@&&############GY7^                                                                                        
                                          7~~^^~!~^^^^^^~?7!JB@@@&###########BPJ!^                                                                                           
                                        7!:::^^^^^^^^^^^!~!5P5B@##BBGGPP5Y?7!                                                                                                
                                       7^:^^^^^^^^^^^^^^^^~^!JJ?7!!!!~!                                                                                                      
                                 77~^^^^^^^!P&P?5@@#!^^^^^^^^~~~~7J?7                                                                                                        
                                 ^~~~!!^^^^^^~!~!Y5P7^^^^^^^~!!!!???J?                                                                                                       
                                 ?Y?^^^^^^^J#&@&##P~^^^^^^^^^^~!!!7J?!!7?J!!!77!!!     !77!       !7Y7                                                                       
                                 77^~^^^^^^^^!777!^^^^^^^^~~!!77777??Y?^~~~~~^:::::^~!7!~^^^~~~~77!?J^         !!7JY7??                                                      
                                 ^7J7~~~^^^^^^^^^^^^^~~~!!!777777?J7!77~^^~^^^^^~7???7~^~^~!7J77~^!Y         7!!!77?J?!                                                      
                                 ~^~??7!!!!!!!~~~~!!!!77777!77777!??!~~~~~^:^~!!!!7??!~~~!!~!!~^^!Y!^~!!7!!~~^^~!7J?                                                         
                                   ^^!???77!!!77777777777!??JJ7??????!~~^^::::::::^^^^~~!!~~~^^~!Y?!7!!~^^^^^~!?J?!^^                                                        
                                        !7????777!7777!77!7Y7!~~~~~~~~^^:::^^::^^^^^^^^^~~~!!7!~7?!~^^^^^^^~!?J7~^^                                                          
                                           !!~!J!?7!?Y?J???J?~~~~~~~~^^^^^:~77!~!!!~~~~~~~~~^^^::::^^^^^~~7?YJ7777777777777?JJ                                               
                                             !~7J7!??J~!~~!!!~~~~~~~^^^^^^::!J?~^^^^^^^^^^^^^^:::::::^^^~!!!!~~~~~^^^^~!77?7!                                                
                                            ?J!^!^~!7?~~~~~~~~~~~~~^::::^:^^:!7~^^^^^^^^^^^^^^:::::::::^^^^^^^^^^~!7???7!                                                    
                                           !7~!^:^~~~~~~~~^^^^^^^^^^:::^^^^?!!!?!^^^^^^^^^^^^^::::::::^^^^^^^~!7??7!~~^^^                                                    
                                          7??J~:^^^^~~^^~~:::::::::7!~^^:::^!!~~~^^^^^^^^^^^^^^^^^:::::^^^^^!??7!~^^^^                                                       
                                            ?^:^:!7:~~^:^^^^^^^^^^:!?!77!:.  ^7~^^^^^^^^^^^^^^^^^^^^::::^^^^^^^~~!!7!                                                        
                                           7. :^!JJ:^^::^~::^:::^^::!7^^~!!!^..!!^^^^^^^^^^^^^^^^^:::::^^^^~7!!7777777                                                       
                                          7.  ~?Y!J~::^:^Y7^:!~^::. ??7^^^^~~!!~!7~~77!~^^^^^^^^^^^^^^^^^^^~7?7    ^^^                                                       
                                         7. :!7~J!?7. ::!7~7:~~!~.  ^?^^^^^^^^^~~7?^^~!77JJ7?Y?7!~^^^^^^^^^^^^!77                                                            
                                        7^.!7 ^ J77J   .J~^~!~^^~~^. ~7^^^^^^^^^^^^^^^^^^~!7~!~!7???7!~^^^^^^^~7??~^                                                         
                                        7!7~^  ^?J!J^  .J^^^^^^^^^~~^.7!^~~~!!777????77!^^^^^^^^^~~!777777!!~~^!?7                                                           
                                        !~^    ^!Y!7?  ^?^^^^^^^^^^^77!Y????J?77!!~!J77??~^^^^^^^^^^^^^^^~J!7777??!^                                                         
                                        ^       ^Y7!?! ?Y^^^^^^^^^~??777!!   ^^^^^^^!J!!7J!^^^^^^^^^^^^^^^Y!^^~~~!!                                                          
                                                ^?J!!7^?Y!^^^^^^^~??^^^^^^^         ^7?!!7J?~^^^^^^^^^^^^~?J^~~~^^             J          77!       ^^^^                     
                                                ^~J~^^~~J7^^^^^^^7?                  ^?7!7!?J!^^^^^^^^^^^!7Y~^                J?^                 ^^  !7                     
                                                 ^?7^^^^?7^^^^^^!J                   ^~J777!7J?~^^^^^^^^^!77J~                5!^        ~^      ^!    G^                    
                                                   J~^^^?!^^^^^~J!^                  ^7Y!7777!7J?77!!!!!!77!?J                P           J^    ^~P    P^                    
                                                  ^77^^^?!^^^^^7J^                 ^^7?77777!7??~~7??J?7!777!7J!              P!          P^    ^!P   5G       !^            
                                                  ^7?^^^J~^^^^^J!^              ^^^!J?!77!!7J?~^ ^^^ !7J?7777!7?!             7P      7!^^?J7    ^!7 !^JY     7              
                                                  ^7J^^~J^^^^^!J^            ^^  7J?7!7!7???~^^      ^^~Y77777!J!              7YJ??JJ7   ^       ^^^^~^!7 !~^^              
                                                  ^J!^^!?^^^^^7?^           ^!?7??7!!77??7~^^        ^~Y?!777!J?^              ^^~!!~^^                 ^^^^                 
                                                 ^!J^^^?7^^^^^?!^           ^JY?Y77???7!~^          ^~Y?!77!7J?^                 ^^^                                         
                                                ^!J~^^^J~^^^^~?^              !777!!~~^^           ~!Y7!77!7J!                                                               
                                                7J~^^~?7^^^^^?!^              ^^^^^^             7???7!7!7??~                                                                
                                              ^!P?!~77~^^^^^77^                                ^?Y!?7!!7?J!^                                                                 
                                              ~~7???Y!^~~~!77^                                   J?YJ???7                                                                    
                                                ^^  !8!?77! ^                                                                                                                

    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
          { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
          { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
          { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return opts
  end,
}

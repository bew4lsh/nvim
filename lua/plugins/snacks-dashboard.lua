-- Snacks.nvim dashboard with custom ASCII art and theme
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      -- Available examples: doom, startify, advanced, github, files, compact_files, chafa, pokemon
      example = "files", -- Try: "advanced", "github", "compact_files", etc.
      preset = {
        header = [[
     J          77!       ^^^^           
    J?^                 ^^  !7           
    5!^        ~^      ^!    G^          
    P           J^    ^~P    P^          
    P!          P^    ^!P   5G       !^  
    7P      7!^^?J7    ^!7 !^JY     7    
     7YJ??JJ7   ^       ^^^^~^!7 !~^^    
     ^^~!!~^^                 ^^^^       
       ^^^                               
        ]],
      },
    },
  },
}

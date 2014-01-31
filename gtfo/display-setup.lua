-- {{{ Display setup
local awful     = require("awful")

return function (names, layouts)
   display = {
      tags = {
         names = names,
         layout = { layouts[1], layouts[2], layouts[3], layouts[1], layouts[4] }
      },
      layouts = layouts
   }

   for s = 1, screen.count() do
      display["tags"][s] =
         awful.tag(names, s, layouts)
   end

   if screen.count() == 1 then
      display["specials"] = {
         browser = {screen = 1, tag = 1},
         music = {screen = 1, tag = 2},
         torrent = {screen = 1, tag = 4}
      }
   else
      display["specials"] = {
         browser = {screen = 2, tag = 1},
         music = {screen = 1, tag = 2},
         torrent = {screen = 2, tag = 4}
      }
   end

   return display
end
-- }}}

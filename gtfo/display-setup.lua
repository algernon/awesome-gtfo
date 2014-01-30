-- {{{ Display setup
local awful     = require("awful")

return function (names, layouts)
   screen_setup = {
      tags = {
         names = names,
         layout = { layouts[1], layouts[2], layouts[3], layouts[1], layouts[4] }
      },
      layouts = layouts
   }

   for s = 1, screen.count() do
      screen_setup["tags"][s] =
         awful.tag(names, s, layouts)
   end

   if screen.count() == 1 then
      browser_tag = {screen = 1, tag = 1}
      music_tag = {screen = 1, tag = 2}
      torrent_tag = {screen = 1, tag = 4}
   else
      browser_tag = {screen = 2, tag = 1}
      music_tag = {screen = 1, tag = 2}
      torrent_tag = {screen = 2, tag = 4}
   end

   return screen_setup
end
-- }}}

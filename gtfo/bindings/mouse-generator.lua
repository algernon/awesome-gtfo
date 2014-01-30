-- {{{ Mouse Bindings
local awful     = require("awful")

return function (mainmenu)
   return awful.util.table.join(
      awful.button({ }, 3, function () mainmenu:toggle() end),
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev)
   )
end
-- }}}

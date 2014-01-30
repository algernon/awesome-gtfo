return function (panel, mainmenu, layouts, modkey, altkey,
                 terminal, browser, browser2)
   local global_keygen  = require("gtfo/bindings/global-keygen")
   local desktop_keygen = require("gtfo/bindings/desktop-keygen")
   local awful          = require("awful")

   return awful.util.table.join(
      global_keygen(panel, mainmenu, layouts, modkey, altkey,
                    terminal, browser, browser2),
      desktop_keygen(modkey))
end

local awful     = require("awful")
local beautiful = require("beautiful")

return function (keys, buttons)
   return {
      -- All clients will match this rule.
      { rule = { },
        properties = { border_width = beautiful.border_width,
                       border_color = beautiful.border_normal,
                       focus = awful.client.focus.filter,
                       keys = keys,
                       buttons = buttons,
                       size_hints_honor = false }
      }
   }
end

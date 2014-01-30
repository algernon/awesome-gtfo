local awful     = require("awful")

return function (modkey)
   -- Bind all key numbers to tags.
   -- Be careful: we use keycodes to make it works on any keyboard layout.
   -- This should map on the top row of your keyboard, usually 1 to 9.
   for i = 1, 9 do
      desktop_keys = awful.util.table.join(
         desktop_keys,
         awful.key({ modkey }, "#" .. i + 9,
                   function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewonly(tag)
                      end
         end),

         awful.key({ modkey, "Control" }, "#" .. i + 9,
                   function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
         end),

         awful.key({ modkey, "Shift" }, "#" .. i + 9,
                   function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                         awful.client.movetotag(tag)
                      end
         end),

         awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                   function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                         awful.client.toggletag(tag)
                      end
      end))
   end

   return desktop_keys
end

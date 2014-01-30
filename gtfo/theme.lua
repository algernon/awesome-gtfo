local beautiful = require("beautiful")
local gears     = require("gears")

beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker/theme.lua")
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/wallpaper/debian.png"

if beautiful.wallpaper then
   for s = 1, screen.count() do
      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
   end
end

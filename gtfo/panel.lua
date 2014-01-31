-- {{{ Wibox
local lain      = require("lain")
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")

return function (layouts, settings)
   -- Textclock
   local clockicon = wibox.widget.imagebox(beautiful.widget_clock)
   local mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")
   -- calendar
   lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

   -- MEM
   local memicon = wibox.widget.imagebox(beautiful.widget_mem)
   local memwidget = lain.widgets.mem(
      {
         settings = function()
            widget:set_text(" " .. mem_now.used .. "MB ")
         end
      }
   )

   -- CPU
   local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
   local cpuwidget =
      wibox.widget.background(
         lain.widgets.cpu(
            {
               settings = function()
                  widget:set_text(" " .. cpu_now.usage .. "% ")
               end
            }
         ),
         "#313131")

   -- Coretemp
   local tempicon = wibox.widget.background(
      wibox.widget.imagebox(beautiful.widget_temp), "#313131")
   local tempwidget =
      wibox.widget.background(
         lain.widgets.temp(
            {
               settings = function()
                  widget:set_text(" " .. coretemp_now .. "°C ")
               end
            }
         ),
         "#313131")

   -- Battery
   local batticon = wibox.widget.imagebox(beautiful.widget_battery)
   local battwidget = lain.widgets.bat(
      {
         settings = function()
            if bat_now.perc == "N/A" then
               widget:set_markup(" AC ")
               batticon:set_image(beautiful.widget_ac)
               return
            elseif tonumber(bat_now.perc) <= 5 then
               batticon:set_image(beautiful.widget_battery_empty)
            elseif tonumber(bat_now.perc) <= 15 then
               batticon:set_image(beautiful.widget_battery_low)
            else
               batticon:set_image(beautiful.widget_battery)
            end
            widget:set_markup(" " .. bat_now.perc .. "% ")
         end
      }
   )

   -- ALSA volume
   local volicon = wibox.widget.imagebox(beautiful.widget_vol)
   local volumewidget =
      lain.widgets.alsa(
         {
            settings = function()
               if volume_now.status == "off" then
                  volicon:set_image(beautiful.widget_vol_mute)
               elseif tonumber(volume_now.level) == 0 then
                  volicon:set_image(beautiful.widget_vol_no)
               elseif tonumber(volume_now.level) <= 50 then
                  volicon:set_image(beautiful.widget_vol_low)
               else
                  volicon:set_image(beautiful.widget_vol)
               end

               widget:set_text(" " .. volume_now.level .. "% ")
            end
         }
      )

   -- Separators
   local spr = wibox.widget.textbox(' ')
   local arrl = wibox.widget.imagebox()
   arrl:set_image(beautiful.arrl)
   local arrl_dl = wibox.widget.imagebox()
   arrl_dl:set_image(beautiful.arrl_dl)
   local arrl_ld = wibox.widget.imagebox()
   arrl_ld:set_image(beautiful.arrl_ld)

   -- Keyboard changer
   -- Keyboard map indicator and changer
   local kbdcfg = {}
   kbdcfg.cmd = "setxkbmap"
   kbdcfg.layout = { { "us", "" }, { "hu", "" } }
   kbdcfg.current = 1  -- us is our default layout
   kbdcfg.widget = wibox.widget.textbox()
   kbdcfg.widget:set_text(" " .. kbdcfg.layout[kbdcfg.current][1] .. " ")
   kbdcfg.switch = function ()
      kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
      local t = kbdcfg.layout[kbdcfg.current]
      kbdcfg.widget:set_text(" " .. t[1] .. " ")
      os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
   end
   kbdcfg.widgetbg = wibox.widget.background(kbdcfg.widget, "#313131")

   -- Mouse bindings
   kbdcfg.widget:buttons(
      awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
   )

   local panel = {}
   local promptbox = {}
   local layoutbox = {}
   local taglist = {}
   local tasklist = {}

   taglist.buttons = awful.util.table.join(
      awful.button({ }, 1, awful.tag.viewonly),
      awful.button({ modkey }, 1, awful.client.movetotag),
      awful.button({ }, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, awful.client.toggletag),
      awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
      awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
   )

   tasklist.buttons = awful.util.table.join(
      awful.button({ }, 1, function (c)
                      if c == client.focus then
                         c.minimized = true
                      else
                         -- Without this, the following
                         -- :isvisible() makes no sense
                         c.minimized = false
                         if not c:isvisible() then
                            awful.tag.viewonly(c:tags()[1])
                         end
                         -- This will also un-minimize
                         -- the client, if needed
                         client.focus = c
                         c:raise()
                      end
      end),

      awful.button({ }, 3, function ()
                      if instance then
                         instance:hide()
                         instance = nil
                      else
                         instance = awful.menu.clients({ width=250 })
                      end
      end),

      awful.button({ }, 4, function ()
                      awful.client.focus.byidx(1)
                      if client.focus then client.focus:raise() end
      end),

      awful.button({ }, 5, function ()
                      awful.client.focus.byidx(-1)
                      if client.focus then client.focus:raise() end
   end))

   -- Create a panel on every screen
   for s = 1, settings["max_screen"] do
      promptbox[s] = awful.widget.prompt()
      layoutbox[s] = awful.widget.layoutbox(s)

      layoutbox[s]:buttons(
         awful.util.table.join(
            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

      -- Create a taglist widget
      taglist[s] =
         awful.widget.taglist(s, awful.widget.taglist.filter.all,
                              taglist.buttons)

      -- Create a tasklist widget
      tasklist[s] =
         awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
                               tasklist.buttons)

      -- Create the wibox
      panel[s] = awful.wibox({ position = settings["position"],
                               screen = s, height = 18 })
      panel[s].ontop = settings["ontop"]

      -- Widgets that are aligned to the upper left
      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(spr)
      left_layout:add(taglist[s])
      left_layout:add(spr)
      left_layout:add(arrl)
      left_layout:add(spr)
      left_layout:add(promptbox[s])
      left_layout:add(spr)
      left_layout:add(arrl)
      left_layout:add(spr)


      -- Widgets that are aligned to the upper right
      local right_layout = wibox.layout.fixed.horizontal()
      right_layout:add(arrl)
      right_layout:add(spr)
      if s == 1 then right_layout:add(wibox.widget.systray()) end
      right_layout:add(spr)
      right_layout:add(arrl)
      right_layout:add(arrl_ld)
      right_layout:add(kbdcfg.widgetbg)
      right_layout:add(arrl_dl)
      right_layout:add(volicon)
      right_layout:add(volumewidget)
      right_layout:add(arrl_ld)
      right_layout:add(cpuicon)
      right_layout:add(cpuwidget)
      right_layout:add(arrl_dl)
      right_layout:add(memicon)
      right_layout:add(memwidget)
      right_layout:add(arrl_ld)
      right_layout:add(tempicon)
      right_layout:add(tempwidget)
      right_layout:add(arrl_dl)
      right_layout:add(batticon)
      right_layout:add(battwidget)
      right_layout:add(arrl)
      right_layout:add(mytextclock)
      right_layout:add(spr)
      right_layout:add(arrl_ld)
      right_layout:add(layoutbox[s])

      -- Now bring it all together (with the tasklist in the middle)
      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_middle(tasklist[s])
      layout:set_right(right_layout)
      panel[s]:set_widget(layout)
   end

   if settings["auto_hide"] == true then
      local ahtimer = timer({ timeout = 1 })

      ahtimer:connect_signal(
         "timeout",
         function ()
            if mouse.coords().y <= 18 then
               panel[mouse.screen].visible = true
            end

            if mouse.coords().y > 36 then
               panel[mouse.screen].visible = false
            end
      end)
      panel.timer = ahtimer
      ahtimer:start ()
   end

   panel.volumewidget = volumewidget
   panel.promptbox = promptbox

   return panel
end
-- }}}

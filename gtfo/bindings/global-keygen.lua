-- {{{ Key bindings
return function (panel, mainmenu, layouts, modkey, altkey,
                 terminal, browser, browser2)
   local awful     = require("awful")
   local lain      = require("lain")

   return awful.util.table.join(
      -- Take a screenshot
      -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
      awful.key({ altkey }, "p", function() os.execute("screenshot") end),

      -- Tag browsing
      awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
      awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
      awful.key({ modkey }, "Escape", awful.tag.history.restore),

      -- Default client focus
      awful.key({ altkey }, "k",
                function ()
                   awful.client.focus.byidx( 1)
                   if client.focus then client.focus:raise() end
      end),
      awful.key({ altkey }, "j",
                function ()
                   awful.client.focus.byidx(-1)
                   if client.focus then client.focus:raise() end
      end),

      -- By direction client focus
      awful.key({ modkey }, "j",
                function()
                   awful.client.focus.bydirection("down")
                   if client.focus then client.focus:raise() end
      end),
      awful.key({ modkey }, "k",
                function()
                   awful.client.focus.bydirection("up")
                   if client.focus then client.focus:raise() end
      end),
      awful.key({ modkey }, "h",
                function()
                   awful.client.focus.bydirection("left")
                   if client.focus then client.focus:raise() end
      end),
      awful.key({ modkey }, "l",
                function()
                   awful.client.focus.bydirection("right")
                   if client.focus then client.focus:raise() end
      end),

      -- Show Menu
      awful.key({ modkey }, "w",
                function ()
                   mainmenu:show({ keygrabber = true })
      end),

      -- Show/Hide Wibox
      awful.key({ modkey }, "b", function ()
                   if panel.timer then
                      panel.timer:stop()
                   end

                   if panel[mouse.screen] then
                      panel[mouse.screen].visible = not panel[mouse.screen].visible
                      if not panel[mouse.screen].visible and panel.timer then
                         panel.timer:start()
                      end
                   end
      end),

      -- Layout manipulation
      awful.key({ modkey, "Shift"   }, "j",
                function () awful.client.swap.byidx(  1) end),
      awful.key({ modkey, "Shift"   }, "k",
                function () awful.client.swap.byidx( -1) end),
      awful.key({ modkey, "Control" }, "j",
                function () awful.screen.focus_relative( 1) end),
      awful.key({ modkey, "Control" }, "k",
                function () awful.screen.focus_relative(-1) end),
      awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
      awful.key({ modkey,           }, "Tab",
                function ()
                   awful.client.focus.history.previous()
                   if client.focus then
                      client.focus:raise()
                   end
      end),
      awful.key({ altkey,           }, "Tab",
                function ()
                   awful.client.focus.byidx(-1)
                   if client.focus then
                      client.focus:raise()
                   end
      end),
      awful.key({ altkey, "Shift"   }, "l",
                function () awful.tag.incmwfact( 0.05)     end),
      awful.key({ altkey, "Shift"   }, "h",
                function () awful.tag.incmwfact(-0.05)     end),
      awful.key({ modkey, "Shift"   }, "l",
                function () awful.tag.incnmaster(-1)       end),
      awful.key({ modkey, "Shift"   }, "h",
                function () awful.tag.incnmaster( 1)       end),
      awful.key({ modkey, "Control" }, "l",
                function () awful.tag.incncol(-1)          end),
      awful.key({ modkey, "Control" }, "h",
                function () awful.tag.incncol( 1)          end),
      awful.key({ modkey,           }, "space",
                function () awful.layout.inc(layouts,  1)  end),
      awful.key({ modkey, "Shift"   }, "space",
                function () awful.layout.inc(layouts, -1)  end),
      awful.key({ modkey, "Control" }, "n",
                awful.client.restore),

      -- Standard program
      awful.key({ modkey,           }, "Return",
                function () awful.util.spawn(terminal) end),
      awful.key({ modkey, "Control" }, "r",      awesome.restart),
      awful.key({ modkey, "Shift"   }, "q",      awesome.quit),
      awful.key({ modkey, "Control" }, "l",
                function ()
                   awful.util.spawn("gnome-screensaver-command --lock")
      end),

      -- Widgets popups
      awful.key({ altkey,           }, "c",
                function () lain.widgets.calendar:show(7) end),

      -- ALSA volume control
      awful.key({ altkey }, "Up",
                function ()
                   awful.util.spawn("amixer -q set Master 1%+")
                   panel.volumewidget.update()
      end),
      awful.key({ altkey }, "Down",
                function ()
                   awful.util.spawn("amixer -q set Master 1%-")
                   panel.volumewidget.update()
      end),
      awful.key({ altkey }, "m",
                function ()
                   awful.util.spawn("amixer -q set Master playback toggle")
                   panel.volumewidget.update()
      end),
      awful.key({ altkey, "Control" }, "m",
                function ()
                   awful.util.spawn("amixer -q set Master playback 100%")
                   panel.volumewidget.update()
      end),

      -- Music control
      awful.key({ altkey, "Control" }, "Up",
                function ()
                   awful.util.spawn_with_shell("banshee --toggle-playing")
      end),
      awful.key({ altkey, "Control" }, "Down",
                function ()
                   awful.util.spawn_with_shell("banshee --stop")
      end),
      awful.key({ altkey, "Control" }, "Left",
                function ()
                   awful.util.spawn_with_shell("banshee --previous")
      end),
      awful.key({ altkey, "Control" }, "Right",
                function ()
                   awful.util.spawn_with_shell("banshee --next")
      end),

      -- Copy to clipboard
      awful.key({ modkey }, "c",
                function () os.execute("xsel -p -o | xsel -i -b") end),

      -- User programs
      awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
      awful.key({ modkey }, "i", function () awful.util.spawn(browser2) end),

      -- Prompt
      awful.key({ modkey }, "r",
                function () panel.promptbox[mouse.screen]:run() end),
      awful.key({ modkey }, "x",
                function ()
                   awful.prompt.run({ prompt = "Run Lua code: " },
                                    panel.promptbox[mouse.screen].widget,
                                    awful.util.eval, nil,
                                    awful.util.getdir("cache") .. "/history_eval")
      end)
   )
end

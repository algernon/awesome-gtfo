--[[ -*- lua -*-
   The GTFO config, based on Powerarrow Darker from awesome-copycats
   CC-BY-NC-SA
--]]

-- {{{ Settings
-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "roxterm"

browser    = "chromium"
browser2   = "dwb"
-- }}}

-- {{{ Required libraries
local awful     = require("awful")
local beautiful = require("beautiful")
local rules     = require("awful.rules")

require("awful.autofocus")
-- }}}

require("gtfo/error-handling")

-- {{{ Startup
require("gtfo/autostart")

run_once("unclutter")
run_once("gnome-screensaver")
run_once("nm-applet")
-- }}}

-- {{{ Theme

require("gtfo/theme")

-- }}}

-- {{{ Display (tags & screens)

local display_setup = require("gtfo/display-setup")
local display = display_setup({ "☭", "♫", "✆", "⌘", "✉"}, {
                                 awful.layout.suit.floating,
                                 awful.layout.suit.tile,
                                 awful.layout.suit.tile.bottom,
                                 awful.layout.suit.fair,
                                 awful.layout.suit.fair.horizontal,
})

-- }}}

-- {{{ Panel

local panel_generator = require("gtfo/panel")
local panel = panel_generator(layouts, {
                                 auto_hide = true,
                                 max_screen = 1,
                                 position = "top",
                                 ontop = true
})

-- }}}

-- {{{ Key bindings

local mouse_gen = require("gtfo/bindings/mouse-generator")
local keygen = require("gtfo/bindings/key-generator")
local keymap = keygen(panel, mainmenu, layouts, modkey, altkey,
                      terminal, browser, browser2)

root.buttons(mouse_gen(mainmenu))
root.keys(keymap)

-- }}}

-- {{{ Client keymaps & rules

local client_keygen = require("gtfo/bindings/client-keygen")
local client_bindings = client_keygen (modkey)

local base_rules = require ("gtfo/rules")
local tags = display["tags"]
rules.rules = awful.util.table.join(
   base_rules(client_bindings["keys"], client_bindings["buttons"]),

   { rule = { class = "Chromium" },
     properties = { tag = tags[2][1],
                    maximized_horizontal = true,
                    maximized_vertical = true
     }
   },

   { rule = { class = "banshee" },
     properties = { tag = tags[1][2],
                    fullscreen = true
     }
   },

   { rule = { class = "Roxterm" },
     properties = { fullscreen = true }
   },

   { rule = { class = "Transmission-gtk" },
     properties = { tag = tags[1][4] }
   },

   { rule = { class = "MPlayer" },
     properties = { floating = true } },

   { rule = { class = "Dwb" },
     properties = { tag = tags[2][1],
                    fullscreen = true } },

   { rule = { instance = "plugin-container" },
     properties = { tag = tags[1][1] } },

   { rule = { class = "Gimp" },
     properties = { tag = tags[1][4] } },

   { rule = { class = "Gimp", role = "gimp-image-window" },
     properties = { maximized_horizontal = true,
                    maximized_vertical = true } }
)

-- }}}

-- {{{ Features & behaviours

require ("gtfo/feature/sloppy-focus")
require ("gtfo/feature/borderless-maximized")

require ("gtfo/arrange/placement")
require ("gtfo/arrange/arrange")

-- }}}

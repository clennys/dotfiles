-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
-- Standard awesome library
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
--local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local chosen_theme = "orca"
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
Terminal = "kitty"
Editor = os.getenv("EDITOR") or "vim"
Editor_cmd = Terminal .. " -e " .. Editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
awful.layout.layouts = {
	awful.layout.suit.tile,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
	awful.layout.suit.floating,
}
-- }}}


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{ raise = true }
			)
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

screen.connect_signal("arrange", function(s)
	local max = s.selected_tag.layout.name == "max"
	local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
	-- but iterate over clients instead of tiled_clients as tiled_clients doesn't include maximized windows
	for _, c in pairs(s.clients) do
		if (max or only_one) and not c.floating or c.maximized then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey, }, "s", hotkeys_popup.show_help,
		{ description = "show help", group = "awesome" }),
	awful.key({ modkey, }, "Left", awful.tag.viewprev,
		{ description = "view previous", group = "tag" }),
	awful.key({ modkey, }, "Right", awful.tag.viewnext,
		{ description = "view next", group = "tag" }),
	awful.key({ modkey, }, "Escape", awful.tag.history.restore,
		{ description = "go back", group = "tag" }),

	awful.key({ modkey, }, "j",
		function()
			awful.client.focus.byidx(1)
		end,
		{ description = "focus next by index", group = "client" }
	),
	awful.key({ modkey, }, "k",
		function()
			awful.client.focus.byidx(-1)
		end,
		{ description = "focus previous by index", group = "client" }
	),
	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
		{ description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
		{ description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey }, ".", function() awful.screen.focus_relative(1) end,
		{ description = "focus the next screen", group = "screen" }),
	awful.key({ modkey }, ",", function() awful.screen.focus_relative(-1) end,
		{ description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }),
	awful.key({ modkey, "Shift" }, ".", function()
		local c = client.focus
		if c then c:move_to_screen(1)
		end
	end,
		{ description = "focus the next screen +1", group = "screen" }),
	awful.key({ modkey, "Shift" }, ",", function()
		local c = client.focus
		if c then c:move_to_screen(-1)
		end
	end,
		{ description = "focus the next screen -1", group = "screen" }),

	awful.key({ modkey }, "b", function()
		local s = awful.screen.focused()
		s.mywibox.visible = not s.mywibox.visible
	end,
		{ description = "toggle wibox on focused screen", group = "screen" }),


	-- Standard program
	awful.key({ modkey, "Shift" }, "Return", function() awful.spawn(Terminal) end,
		{ description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart,
		{ description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit,
		{ description = "quit awesome", group = "awesome" }),

	awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
		{ description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
		{ description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, }, "i", function() awful.tag.incnmaster(1, nil, true) end,
		{ description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey }, "d", function() awful.tag.incnmaster(-1, nil, true) end,
		{ description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "i", function() awful.tag.incncol(1, nil, true) end,
		{ description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Shift" }, "d", function() awful.tag.incncol(-1, nil, true) end,
		{ description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
		{ description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
		{ description = "select previous", group = "layout" }),


	-- Prompt
	awful.key({ modkey, "Control" }, "r", function() awful.screen.focused().mypromptbox:run() end,
		{ description = "run prompt", group = "launcher" }),

	awful.key({ modkey, "Control" }, "x",
		function()
			awful.prompt.run {
				prompt       = "Run Lua code: ",
				textbox      = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
		end,
		{ description = "lua execute prompt", group = "awesome" }),

	-- Personal
	awful.key({ modkey }, "w", function()
		awful.util.spawn("firefox")
	end,
		{ description = "launch firefox", group = "browsing" }),
	awful.key({ modkey, "Shift" }, "w", function()
		awful.util.spawn("brave-browser")
	end,
		{ description = "launch brave", group = "browsing" }),
	awful.key({ modkey }, "n", function()
		awful.util.spawn("dmenu_run")
	end,
		{ description = "application launcher", group = "dmenu" }),
	awful.key({ modkey, "Shift" }, "m", function()
		awful.util.spawn("dman")
	end,
		{ description = "files university", group = "dmenu" }),
	awful.key({ modkey, "Shift" }, "o", function()
		awful.util.spawn("dopen.sh")
	end,

		{ description = "lookup manpages", group = "dmenu" }),
	awful.key({ modkey, "Shift" }, "a", function()
		awful.util.spawn("dklay.sh")
	end,
		{ description = "change keyboardlayout", group = "dmenu" }),
	awful.key({ modkey, "Shift" }, "x", function()
		awful.util.spawn("dpower.sh")
	end,
		{ description = "poweroff menu", group = "dmenu" }),

	awful.key({ modkey, "Shift" }, "s", function()
		awful.util.spawn("flameshot gui -p " .. os.getenv("HOME") .. "/Downloads/screenshots")
	end,
		{ description = "take a screenshot", group = "utils" }),

	awful.key({ modkey, "Shift" }, "l", function()
		awful.util.spawn("slock")
	end,
		{ description = "lock screen", group = "utils" }),

	awful.key({ modkey, "Shift" }, "f", function()
		awful.util.spawn("kitty -e vifm")
	end,
		{ description = "change keyboardlayout", group = "dmenu" }),


	-- Brightness
	awful.key({}, "XF86MonBrightnessUp", function() os.execute("light -A 5") end,
		{ description = "brightness +5%", group = "brightness" }),
	awful.key({}, "XF86MonBrightnessDown", function() os.execute("light -U 5") end,
		{ description = "brightness -5%", group = "brightness" }),

	-- Sound
	awful.key({}, "XF86AudioRaiseVolume",
		function()
			awful.util.spawn("amixer set Master 5%+", false)
		end, { description = "volume master +5%", group = "audio" }),
	awful.key({}, "XF86AudioLowerVolume",
		function()
			awful.util.spawn("amixer set Master 5%-", false)
		end, { description = "volume master -5%", group = "audio" }),
	awful.key({}, "XF86AudioPrev",
		function()
			awful.util.spawn("playerctl previous", false)
		end, { description = "previous Track", group = "audio" }),
	awful.key({}, "XF86AudioNext",
		function()
			awful.util.spawn("playerctl next", false)
		end, { description = "next Track", group = "audio" }),
	awful.key({}, "XF86AudioPlay",
		function()
			awful.util.spawn("playerctl play-pause", false)
		end, { description = "play/pause Track", group = "audio" }),
	awful.key({}, "XF86AudioStop",
		function()
			awful.util.spawn("playerctl stop", false)
		end, { description = "stop Track", group = "audio" }),

	awful.key({ modkey }, "bracketleft",
		function()
			awful.util.spawn("playerctl -p spotify previous", false)
		end, { description = "spotify previous song", group = "audio" }),
	awful.key({ modkey }, "bracketright",
		function()
			awful.util.spawn("playerctl -p spotify next", false)
		end, { description = "spotify next song", group = "audio" }),
	awful.key({ modkey }, "grave",
		function()
			awful.util.spawn("playerctl -p spotify play-pause", false)
		end, { description = "play-pause track", group = "audio" })
)

clientkeys = gears.table.join(
	awful.key({ modkey, }, "f",
		function()
			awful.layout.set(awful.layout.suit.max.fullscreen)
		end,
		{ description = "toggle max layout", group = "layout" }),
	awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
		{ description = "close", group = "client" }),
	awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }),
	awful.key({ modkey }, "Return", function(c) c:swap(awful.client.getmaster()) end,
		{ description = "move to master", group = "client" }),
	awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
		{ description = "move to screen", group = "client" }),
	awful.key({ modkey, }, "t", function() awful.layout.set(awful.layout.suit.tile) end,
		{ description = "select tiling layout", group = "layout" }),
	awful.key({ modkey, }, "m",
		function()
			awful.layout.set(awful.layout.suit.max)
		end,
		{ description = "monocle layout", group = "layout" }),
	awful.key({ modkey, "Control" }, "m",
		function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end,
		{ description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m",
		function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end,
		{ description = "(un)maximize horizontally", group = "client" }),

	awful.key({ modkey }, "Tab", function()
		awesome.emit_signal("bling::window_switcher::turn_on")
	end, { description = "Window Switcher", group = "bling" }),
	awful.key({ modkey, '>' }, 'o', function(c)
		c:move_to_screen()
	end, { description = 'move to screen', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{ description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ "Mod5" }, "#" .. i + 9,
			function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{ description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{ description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{ description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = {},
		properties = { border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered,
		}
	},

	-- Floating clients.
	{ rule_any = {
		instance = {
			"DTA", -- Firefox addon DownThemAll.
			"copyq", -- Includes session name in class.
			"pinentry",
		},
		class = {
			"Arandr",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin", -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Pavucontrol",
			"Wpa_gui",
			"veromix",
			"xtightvncviewer",
			"xdman-Main"
		},

		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester", -- xev.
		},
		role = {
			"AlarmWindow", -- Thunderbird's calendar.
			"ConfigManager", -- Thunderbird's about:config.
			"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
		}
	}, properties = { floating = true } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("property::position", function(c)
	if c.class == 'Steam' then
		local g = c.screen.geometry
		if c.y + c.height > g.height then
			c.y = g.height - c.height
			naughty.notify {
				text = "restricted window: " .. c.name,
			}
		end
		if c.x + c.width > g.width then
			c.x = g.width - c.width
		end
	end
end)

for _, preset in pairs(naughty.config.presets) do
	preset.position = "top_middle"
end


-- }}}

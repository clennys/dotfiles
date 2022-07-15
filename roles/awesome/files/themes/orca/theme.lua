local gears     = require("gears")
local lain      = require("lain")
local awful     = require("awful")
local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")
local bling     = require("bling")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                         = {}
theme.default_dir                   = require("awful.util").get_themes_dir() .. "default"
theme.dir                           = os.getenv("HOME") .. "/.config/awesome/themes/orca"
theme.wallpaper                     = theme.dir .. "/iceland.jpg"
theme.font                          = "Terminus 12"
theme.fg_normal                     = "#9E9E9E"
theme.fg_focus                      = "#eaebed"
theme.bg_normal                     = "#1c2023"
theme.bg_focus                      = "#1c2023"
theme.fg_urgent                     = "#000000"
theme.bg_urgent                     = "#bf616a"
theme.border_width                  = dpi(2)
theme.border_normal                 = "#1c2023"
theme.border_focus                  = "#005577"
theme.taglist_fg_focus              = "#eaebed"
theme.taglist_bg_focus              = "#005577"
theme.menu_height                   = dpi(16)
theme.menu_width                    = dpi(140)
theme.ocol                          = "<span color='" .. theme.fg_normal .. "'>"
theme.tasklist_sticky               = theme.ocol .. "[S]</span>"
theme.tasklist_ontop                = theme.ocol .. "[T]</span>"
theme.tasklist_floating             = theme.ocol .. "[F]</span>"
theme.tasklist_maximized_horizontal = theme.ocol .. "[M] </span>"
theme.tasklist_maximized_vertical   = ""
theme.tasklist_disable_icon         = true
theme.awesome_icon                  = theme.dir .. "/icons/awesome.png"
theme.menu_submenu_icon             = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = theme.dir .. "/icons/square_unsel.png"
theme.useless_gap                   = dpi(2)
theme.gap_single_client             = false
theme.border_single_client          = false
theme.layout_txt_tile               = "[]="
theme.layout_txt_tileleft           = "[l]"
theme.layout_txt_tilebottom         = "[b]"
theme.layout_txt_tiletop            = "[tt]"
theme.layout_txt_fairv              = "[fv]"
theme.layout_txt_fairh              = "[fh]"
theme.layout_txt_spiral             = "[s]"
theme.layout_txt_dwindle            = "[d]"
theme.layout_txt_max                = "[m]"
theme.layout_txt_fullscreen         = "[F]"
theme.layout_txt_magnifier          = "[M]"
theme.layout_txt_floating           = "[*]"

theme.systray_icon_spacing = dpi(10)

theme.notification_fg = theme.fg_focus
theme.notification_font = "TerminessTTF Nerd Font 12"
theme.notification_icon_size = dpi(128)
theme.notification_width = dpi(400)
theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.border_focus


local markup = lain.util.markup
local white  = theme.fg_focus

-- Textclock
local mytextclock = wibox.widget.textclock(markup(white, " %Y-%m-%d %a %H:%M "))
mytextclock.font = theme.font

-- Separators
local first  = wibox.widget.textbox(markup.font("Terminus 4", " "))
local spr    = wibox.widget.textbox(' ')
local bspr   = wibox.widget.textbox(markup.font("Terminus 12", "  "))
local hyphen = wibox.widget.textbox(markup.font("Terminus 12", " - "))

local function update_txt_layoutbox(s)
	-- Writes a string representation of the current layout in a textbox widget
	local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
	s.mytxtlayoutbox:set_text(txt_l)
end

function theme.at_screen_connect(s)
	-- Quake application
	s.quake = lain.util.quake({ app = awful.util.terminal })

	-- If wallpaper is a function, call it with the screen
	local wallpaper = theme.wallpaper
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Textual layoutbox
	s.mytxtlayoutbox = wibox.widget.textbox(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
	awful.tag.attached_connect_signal(s, "property::selected", function() update_txt_layoutbox(s) end)
	awful.tag.attached_connect_signal(s, "property::layout", function() update_txt_layoutbox(s) end)
	s.mytxtlayoutbox:buttons(my_table.join(
		awful.button({}, 1, function() awful.layout.inc(1) end),
		awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
		awful.button({}, 3, function() awful.layout.inc(-1) end),
		awful.button({}, 4, function() awful.layout.inc(1) end),
		awful.button({}, 5, function() awful.layout.inc(-1) end)))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

	-- Create a tasklist widget
	-- s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, awful.util.tasklist_buttons)

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

	local art = wibox.widget {
		image = "default_image.png",
		resize = true,
		forced_height = dpi(80),
		forced_width = dpi(80),
		widget = wibox.widget.imagebox
	}

	local name_widget = wibox.widget {
		markup = 'No players',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local title_widget = wibox.widget {
		markup = 'Nothing Playing',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local artist_widget = wibox.widget {
		markup = 'Nothing Playing',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	-- Get Song Info
	local playerctl = bling.signal.playerctl.lib({
		ignore = "%any",
		player = "spotify"
	})
	playerctl:connect_signal("metadata",
		function(_, title, artist, album_path, album, new, player_name)
			-- Set art widget
			art:set_image(gears.surface.load_uncached(album_path))

			-- Set player name, title and artist widgets
			name_widget:set_markup_silently(player_name)
			title_widget:set_markup_silently(title)
			artist_widget:set_markup_silently(artist)
		end)
	title_widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			playerctl:play_pause()
		end)
	))
	artist_widget:buttons(gears.table.join(
		awful.button({}, 1, function()
			playerctl:next()
		end)
	))


	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			first,
			s.mytaglist,
			spr,
			s.mytxtlayoutbox,
			--spr,
			s.mypromptbox,
			spr,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			title_widget,
			hyphen,
			artist_widget,
			bspr,
			wibox.widget.systray({}),
			spr,
			mytextclock,
			spr,
		},
	}
end

bling.widget.window_switcher.enable {
	type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

	-- keybindings (the examples provided are also the default if kept unset)
	hide_window_switcher_key = "Escape", -- The key on which to close the popup
	minimize_key = "n", -- The key on which to minimize the selected client
	unminimize_key = "N", -- The key on which to unminimize all clients
	kill_client_key = "q", -- The key on which to close the selected client
	cycle_key = "Tab", -- The key on which to cycle through all clients
	previous_key = "Left", -- The key on which to select the previous client
	next_key = "Right", -- The key on which to select the next client
	vim_previous_key = "h", -- Alternative key on which to select the previous client
	vim_next_key = "l", -- Alternative key on which to select the next client

	cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
	filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
}


return theme

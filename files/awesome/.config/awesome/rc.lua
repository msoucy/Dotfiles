-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Themes
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
-- Override the theme wallpaper with my own choice
beautiful.get().wallpaper = os.getenv("HOME") .. "/.wallpaper/void.png"
-- }}}

-- {{{ Defaults
-- This is used later as the default terminal and editor to run.
terminal = "urxvt256c"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end }
}

function xprop(...)
    local activestr = "xprop -root 32x '$0' _NET_ACTIVE_WINDOW"
    local suffix = table.concat({...}, " ")
    return function()
        awful.spawn.easy_async(activestr, function(stdout)
            local id = string.match(stdout, "(0x.-)$")
            local cmdstr = "xprop -id " .. id .. " " .. suffix
            awful.spawn.easy_async(cmdstr, function(output)
                naughty.notify({
                    text = output,
                    timeout = 20,
                    font = "Monospace 8"
                })
            end)
        end)
    end
end

mymainmenu = awful.menu({ items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "Properties", {
        { "xprop", xprop("WM_CLASS", "WM_NAME") },
        { "xprop-all", xprop() },
    }},
    { "(un)dock", "~/bin/dock" },
    { "open terminal", terminal }
}})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.easy_async("cal -3", function(stdout)
            naughty.notify({
                text = stdout,
                timeout = 7,
                font = "Monospace 8"
            })
        end)
    end)
))

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                               if client.focus then
                                                   client.focus:move_to_tag(t)
                                               end
                                           end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                               if client.focus then
                                                   client.focus:toggle_tag(t)
                                               end
                                           end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )
local tasklist_buttons = gears.table.join(
     awful.button({ }, 1, function (c)
                              if c == client.focus then
                                  c.minimized = true
                              else
                                  -- Without this, the following
                                  -- :isvisible() makes no sense
                                  c.minimized = false
                                  if not c:isvisible() and c.first_tag then
                                      c.first_tag:view_only()
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
                          end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.suit.fair)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
    }

    local volume_widget = require("volume")
    local weather = require("weather")
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout {
        layout = wibox.layout.fixed.horizontal,
        { widget = wibox.widget.systray },
        volume_widget,
        require("battery"),
        require("fish"),
        weather("03054"),
        mytextclock,
        s.mylayoutbox,
    }

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout {
        layout = wibox.layout.align.horizontal,
        left_layout,
        s.mytasklist,
        right_layout,
    }

    s.mywibox.widget = layout
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Convenience Functions {{{
function extern(cmd, sn)
    return function() awful.spawn(cmd, sn or false) end
end

brightness = { value = 100.0 }
function brightness.update(mod)
    return function ()
        nv = brightness.value
        nv = math.max(20, math.min(100, nv + mod))
        cmd = string.format('xrandr --output LVDS2 --brightness %1.2f', nv/100.0)
        awful.spawn(cmd)
        brightness.value = nv
    end
end
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey, "Control" }, "Left", function()
        awful.screen.connect_for_each_screen(function(i)
            awful.tag.viewprev(i)
        end)
    end ),

    awful.key({ modkey, "Control" }, "Right", function()
        awful.screen.connect_for_each_screen(function(i)
            awful.tag.viewnext(i)
        end)
    end ),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", extern(terminal)),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Layout
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end),

    awful.key({ modkey }, "x",
          function ()
              awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
              }
          end),
    -- Menubar
    awful.key({ modkey }, "p", menubar.show),
    -- Volume
    awful.key({ }, "XF86AudioRaiseVolume", function() volume_widget.up() end),
    awful.key({ }, "XF86AudioLowerVolume", function() volume_widget.down() end),
    awful.key({ }, "XF86AudioMute", function() volume_widget.toggle() end),
    -- Print Screen
    awful.key({ }, "Print",
              extern("scrot 'Pictures/screenshots/%Y-%m-%d_%H%M%S.png'")),
    -- Lock
    awful.key({ modkey, "Control" }, "l", extern("xscreensaver-command -lock")),
    awful.key({ modkey, "Shift", "Control" }, "l", extern("pyxtrlock")),
    awful.key({ modkey }, "XF86ScreenSaver", extern("xscreensaver-command -lock")),
    -- Buzzer
    awful.key({ }, "XF86Launch1", extern("mplayer Documents/bzzzzzt/buzzer.ogg")),
    awful.key({ "Shift" }, "XF86Launch1", extern("mplayer Documents/bzzzzzt/trainbuzzer.ogg")),
    awful.key({ "Control" }, "XF86Launch1", extern("mplayer Documents/Aiya.mp3")),
    -- Displays
    awful.key({ modkey }, "XF86Display", extern("~/bin/dock")),
    awful.key({ modkey }, "F8", brightness.update(-7)),
    awful.key({ modkey, "Shift" }, "F8", brightness.update(-15)),
    awful.key({ }, "XF86MonBrightnessDown", brightness.update(-7)),
    awful.key({ modkey }, "F9", brightness.update(7)),
    awful.key({ modkey, "Shift" }, "F9", brightness.update(15)),
    awful.key({ }, "XF86MonBrightnessUp", brightness.update(7)),
        awful.key({ modkey, "Control" }, "t",
                   function (c)
                       naughty.notify({text="I'm in ur computer, toggling ur stuff!"})
                       -- toggle titlebar
                       awful.titlebar.toggle(c)
                   end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    awful.key({ modkey,           }, "n",      function (c) c.minimized = true                end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local t = screen.tags[i]
                        if t then
                            t:view_only()
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        local t = screen.tags[i]
                        if t then
                            t:view_toggle()
                        end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if not client.focus then return end
                      local tag = client.focus.screen.tags[i]
                      if tag then
                          client.focus:move_to_tag(tag)
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if not client.focus then return end
                      local tag = client.focus.screen.tags[i]
                      if tag then
                          client.focus:toggle_tag(tag)
                      end
                  end))
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     lacement = awful.placement.no_overlap+awful.placement.no_offscreen
             } },
    { rule_any = { class = {"MPlayer", "pinentry", "gimp", "Nautical Game!"} },
      properties = { floating = true } },
    { rule = { class = "Google-chrome-stable", role = "pop-up" },
      properties = { floating = true } },
    { rule = { role = "bubble" },
      properties = { floating = true } },
    { rule_any = { class = {"XTerm", "URxvt", "st-256color", "terminology"} },
      properties = { size_hints_honor = false } },
    { rule_any = { instance = {"plugin-container", "exe"} },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = gears.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout {
            layout = wibox.layout.fixed.horizontal,
            awful.titlebar.widget.iconwidget(c),
        }
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout {
            layout = wibox.layout.fixed.horizontal,
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
        }

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title.align = "center"
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        awful.titlebar(c).widget = wibox.layout {
            layout = wibox.layout.align.horizontal,
            left_layout,
            middle_layout,
            right_layout,
        }
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Applets {{{

function run_once(prg, arg_string) -- {{{
    if (not prg) or prg == "" then do return nil end end
    local cmd = prg
    if arg_string and arg_string ~= "" then
        cmd = cmd .. " " .. (arg_string or "")
    end
    -- Look for process, if it doesn't exist then spawn it
    return awful.spawn({
        "/bin/sh", "-c",
        "pgrep -f -u $USER -x '" .. cmd .. "' || (" .. cmd .. ")"
    })
end -- }}}

-- If the programs don't exist, bash will just silently fail
run_once("xscreensaver", "-no-splash")
run_once("amixer", "-c 0 set Headphone 100%")
run_once("nm-applet")
run_once("gnome-keyring-daemon")
-- run_once("keepass")
--- }}}

-- vim: fdm=marker et ts=4 sw=4

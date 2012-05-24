-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("revelation")
require("vicious")

-- function run_once(prg)
--    awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
-- end

-- awful.util.spawn_with_shell("cairo-compmgr &")
awful.util.spawn_with_shell("dropboxd")
awful.util.spawn_with_shell("dropbox start")
awful.util.spawn_with_shell("xxkb")
awful.util.spawn_with_shell("run_once workrave")
awful.util.spawn_with_shell("kbdd")
awful.util.spawn_with_shell("setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led:caps'")
-- awful.util.spawn_with_shell("wicd-client")




-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

baticon = widget({ type = "imagebox", align = "left" })

-- This is used later as the default terminal and editor to run.
terminal = "sakura"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor



-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "reboot" , "sudo reboot"}
}


finances = {
   { "&gnucash", "gnucash"}
}

internet = {
   { "&psi", "psi"},
   { "&firefox", "firefox"},
   { "&thunderbird", "thunderbird"},
   { "&chromium", "chromium"}
}

office = {
   { "&LibreOffice", "soffice"},
   { "&Evince", "evince"},
   { "&FBReader", "FBReader"},
   { "emacs", terminal .. " -e emacs -nw"}
}

other = {
   { "&4pane", "4pane"},
   { "&stardict", "stardict"},
   { "&2gis", "wine '/home/merlin/.wine/drive_c/Program\ Files/2gis/3.0/grym.exe'"}
}

admins = {
   { "Cluster SSH", "cssh"},
   { "pbx.sutel", terminal .. " -e ssh sutel"},
   { "mail.sutel", terminal .. " -e ssh 95.167.164.14 -p 2222"},
   { "flk.ssh", terminal .. " -e ssh flk"},
   { "flk_ek.ssh", terminal .. " -e ssh flk_ek"},
   { "flk_ek.rdp", "rdesktop 77.233.162.52:33389 -u merlin -p ';jgf c hexrjq'"}

}



mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "finances", finances },
                                    { "internet", internet },
                                    { "office", office},
                                    { "other", other},
                                    { "admins", admins},
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Initialize widget
mboxcwidget = widget({ type = "textbox" }) 
mboxcwidget1 = widget({ type = "textbox" })
--mboxcwidget2 = widget({ type = "textbox" })
gmailwidget = widget({ type = "textbox" })
wifiwidget = widget({ type = "textbox" })
netwidget = widget({ type = "textbox" })
cpuwidget = widget({ type = "textbox" })
batwidget = widget({ type = "textbox" })
-- pkgwidget = widget({ type = "textbox" })
-- mpdwidget = widget({ type = "textbox" })
-- support2widget = widget({ type = "textbox" })
orgwidget = widget({ type = "textbox" })
-- fswidget = widget({ type = "textbox" })
-- batwidget = awful.widget.progressbar()
-- batwidget:set_width(8)
-- batwidget:set_height(10)
-- batwidget:set_vertical(true)
-- batwidget:set_background_color("#494B4F")
-- batwidget:set_border_color(nil)
-- batwidget:set_color("#AECF96")
-- batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })


-- register widget

--os=awful.util.spawn_with_shell("head -1 /etc/issue | awk '{print $1}'")

-- vicious.register(pkgwidget, vicious.widgets.pkg, '<span color="green"> $1 pkg </span>', 720, "Arch")
--vicious.register(pkgwidget, vicious.widgets.pkg, '<span color="green"> $1 pkg </span>', 720, )
vicious.register(cpuwidget, vicious.widgets.cpu, " CPU: $1%")
vicious.register(batwidget, vicious.widgets.bat, function(widget,args)
                                                    if args[1] == '+' then 
                                                       return  ' BAT: <span color="yellow"> ' .. args[2] .. "% " .. "(" .. args[3] .. ")</span>" 
                                                    elseif args[1] == '-' then
                                                       if args[2] < 20  then
                                                          naughty.notify({ title = "Battery Warning", text = "Battery low! "..args[2].."% left!\nBetter get some power.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
                                                          return ' BAT: <span color="red"> ' .. args[2] .. "% " .. "(" .. args[3] .. ")</span>" 
                                                       else return ' BAT: <span color="red"> ' .. args[2] .. "% " .. "(" .. args[3] .. ")</span>" 
                                                       end
                                                    else  
                                                       return ' BAT: <span color="green"> charged </span>' 
                                                    end
                                                 end, 20, "BAT0")

--vicious.register(wifiwidget, vicious.widgets.wifi, " ${ssid} ${link}% ", 5, "wlan0")
vicious.register(wifiwidget, vicious.widgets.wifi, function(widget,args)
                                                      if args["{link}"] >= 75 then 
                                                         return '<span color="blue">WiFi: </span>' .. args["{ssid}"] .. ' <span color="blue">' .. args["{link}"] .. '%</span>'
                                                      elseif args["{link}"] < 75 and args["{link}"] > 50 then
                                                         return '<span color="blue">WiFi: </span>' .. args["{ssid}"] .. ' <span color="green">' .. args["{link}"] .. '%</span>'
                                                      elseif args["{link}"] < 50 and args["{link}"] > 20 then
                                                         return '<span color="blue">WiFi: </span>' .. args["{ssid}"] .. ' <span color="yellow">' .. args["{link}"] .. '%</span>'
                                                      elseif args["{link}"] < 20 then
                                                         return '<span color="blue">WiFi: </span>' .. args["{ssid}"] .. ' <span color="red">' .. args["{link}"] .. '%</span>'
                                                      end
                                                   end, 5, "wlan0")

vicious.register(netwidget, vicious.widgets.net, "${wlan0 carrier}", 5)
-- vicious.register(mpdwidget, vicious.widgets.mpd, " ${Artist} ", 5)
-- vicious.register(gmailwidget, vicious.widgets.gmail, " Gmail: ${count} Last ${subject} ", 600, 10)
vicious.register(gmailwidget, vicious.widgets.gmail, " Gmail: ${count} ", 600, 10)
local mboxc = {
      mbox = {"/home/merlin/Mail/mbox"},
      tt = {"/home/merlin/Mail/tt"},
--      syseng = {"/home/merlin/Mail/sys.eng"},
}
vicious.register(mboxcwidget, vicious.widgets.mboxc, " General: $3.", 600, mboxc.mbox)
vicious.register(mboxcwidget1, vicious.widgets.mboxc, " TT: $3.", 600, mboxc.tt)
--vicious.register(mboxcwidget2, vicious.widgets.mboxc, " sys.eng: $3.", 60, mboxc.syseng)
-- vicious.register(fswidget, vicious.widgets.fs, " / ${/ avail_gb} GB /home ${/home avail_gb} GB /usr ${/usr avail_gb} ", 5)

-- vicious.register(fswidget, vicious.widgets.fs, function(widget,args)
--                                                   if args["{/ avail_gb}"] <= 7 then
--                                                      naughty.notify({ title = "Battery Warning", text = "Battery low! "..args[2].."% left!\nBetter get some power.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })
--                                                   end
--                                                end, 5)



local orgmode = {
  files = { "/home/merlin/org/personal.org","/home/merlin/org/sutel.org", "/home/merlin/org/ipserver.org","/home/merlin/org/enforta.org","/home/merlin/org/weblancer.org", "/home/merlin/org/flk.org","/home/merlin/org/copy74.org","/home/merlin/org/kipriyanov.org","/home/merlin/org/cvetochka.org","/home/merlin/org/anvik.org"
         },
}

vicious.register(orgwidget, vicious.widgets.org, '<span color="red">Overdue $1</span>.<span color="yellow"> Today $2 </span>. <span color="blue">Next 3  days $3 </span>.<span color="green"> Next week $4 </span> ', 10, orgmode.files)

-- Battery widget
-- vicious.register(batwidget, vicious.widgets.bat,
--                      function (widget, args)
--                         if args[2] >= 50 and args[2] < 75 then
--                            return "" .. colyel .. "" .. coldef .. colbyel .. args[2] .. "% " .. "(" .. args[3] .. ") " .. coldef .. ""
--                         elseif args[2] >= 20 and args[2] < 50 then
--                            return "" .. colred .. "" .. coldef .. colbred .. args[2] .. "% " .. "(" .. args[3] .. ") " .. coldef .. ""
--                         elseif args[2] < 20 and args[1] == "-" then
--                            naughty.notify({ title = "Battery Warning", text = "Battery low! "..args[2].."% left!\nBetter get some power.", timeout = 10, position = "top_right", fg = beautiful.fg_urgent, bg = beautiful.bg_urgent })                           return "" .. colred .. "" .. coldef .. colbred .. args[2] .. "% " .. "(" .. args[3] .. ") " .. coldef .. ""
--                         elseif args[2] < 20 then 
--                            return "" .. colred .. "" .. coldef .. colbred .. args[2] .. "% " .. "(" .. args[3] .. ") " .. coldef .. ""
--                         else
--                            return "" .. colwhi .. "" .. coldef .. colbwhi .. args[2] .. "% " .. "(" .. args[3] .. ") " .. coldef .. ""
--                         end
--                      end, 23, "BAT0" )


-- Create a wibox for each screen and add it

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
--  mywiboxbottom[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        -- support2widget,
        s == 1 and mysystray or nil,
        -- mpdwidget,
        gmailwidget,
        mboxcwidget,
        mboxcwidget1,
--        mboxcwidget2,
        cpuwidget,
        batwidget,
        wifiwidget,
        -- netwidget,
--        fswidget,
        -- pkgwidget,
        orgwidget,
       -- mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    mywibox[s] = awful.wibox({ position = "bottom", screen = s })
    mywibox[s].widgets = {
           mytasklist[s],
           layout = awful.widget.layout.horizontal.rightleft
    }

    -- mywibox[s] = awful.wibox({ position = "right", screen = s })

    -- mywibox[s].widgets = {
    --    gmailwidget,
    --    layout = awful.widget.layout.vertical.bottomtop

    -- }

end
-- }}}



-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),
    awful.key({modkey}, "e", revelation),
    awful.key({ modkey }, "b", function () awful.util.spawn("firefox") end),
    awful.key({ modkey }, "t", function () awful.util.spawn("twinkle") end),
    awful.key({ modkey }, "p", function () awful.util.spawn("psi") end),
    awful.key({ modkey }, "s", function () awful.util.spawn("/home/merlin/bin/touchpad.sh") end),
    awful.key({ modkey }, "h", function () awful.util.spawn("rdesktop 10.74.0.228 -u m.klopotnyuk -p ';jgfchexrjq'") end),
    awful.key({ modkey }, "F12", function () awful.util.spawn("xlock") end),
    awful.key({ modkey }, "g", function () awful.util.spawn("gnucash") end),
    -- awful.key({ modkey }, "m", function () awful.util.spawn("kill `ps aux | grep 'alert.sh' | grep -v grep | awk '{print $2}'`") end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

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
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
     { rule = { class = "Thunderbird" },
       properties = { tag = tags[1][3] } },
     { rule = { class = "psi" },
       properties = { tag = tags[1][4] } },
     { rule = { class = "Pidgin" },
       properties = { tag = tags[1][4] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2]} },
    { rule = { class = "Gnucash" },
      properties = { tag = tags[1][8]} },
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[1][7]} },
    { rule = { class = "rdesktop" },
      properties = { tag = tags[1][7]} },
    { rule = { class = "libreoffice-calc" },
      properties = { tag = tags[1][5]} },
    { rule = { class = "libreoffice-writer" },
      properties = { tag = tags[1][5]} },
    { rule = { class = "libreoffice-startcenter" },
      properties = { tag = tags[1][5]} },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

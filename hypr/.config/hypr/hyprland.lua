-- #######################################################################################
-- TREVOR'S CUSTOM HYPRLAND CONFIG (Lua, Hyprland 0.57+)
-- Ported 2026-11-08 from hyprland.conf (kept in git history / alongside as reference)
-- #######################################################################################

-----------------
---- SOURCES ----
-----------------
require("conf.monitors")

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "rofi -show run"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("dunst")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("~/.config/waybar/startup.sh")
    hl.exec_cmd("~/.config/hypr/random-wallpaper.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("numlockx on")
    -- Startup workspace layout (staggered — see startup-apps.sh)
    hl.exec_cmd("sleep 2 && ~/.config/hypr/startup-apps.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "arch-")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border        = true,
        extend_border_grab_area = 5,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.85,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            vibrancy          = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        enable_swallow          = true,
        swallow_regex           = "^(kitty)$",
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

-- Animations (same values as the old config — bezier everywhere, no springs)
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Smart gaps — no gaps/borders when only one window on a workspace
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

---------------
---- INPUT ----
---------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"
local function key(k) return mainMod .. " + " .. k end
local function sh(cmd) return hl.dsp.exec_cmd(cmd) end

hl.bind(key("B"),              sh("firefox"))
hl.bind(key("Return"),         sh(terminal))
hl.bind(key("Q"),              hl.dsp.window.close())
hl.bind(key("M"),              sh("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(key("E"),              sh(fileManager))
hl.bind(key("V"),              hl.dsp.window.float({ action = "toggle" }))
hl.bind(key("CTRL + Return"),  sh(menu))
hl.bind(key("P"),              hl.dsp.window.pseudo())
hl.bind(key("J"),              hl.dsp.layout("togglesplit"))
hl.bind(key("SHIFT + B"),      sh("~/.config/waybar/startup.sh"))
hl.bind(key("L"),              sh("hyprlock"))
hl.bind(key("Print"),          sh("~/.config/scripts/screenshot.sh"))
hl.bind(key("SHIFT + Print"),  sh("~/.config/scripts/record.sh"))
hl.bind(key("SHIFT + P"),      sh("~/.config/scripts/record.sh"))
hl.bind(key("F"),              hl.dsp.window.fullscreen())
hl.bind(key("SHIFT + V"),      sh("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(key("CTRL + V"),       sh("~/.local/bin/vr-session toggle"))  -- questdesk VR workspace
hl.bind(key("SHIFT + E"),      sh("wlogout"))
hl.bind(key("SHIFT + N"),      sh("~/.config/scripts/nightmode-toggle.sh"))
hl.bind(key("C"),              sh("hyprpicker -a"))
hl.bind(key("grave"),          sh("~/.config/scripts/scratchpad.sh"))
hl.bind(key("T"),              sh("~/.config/scripts/focus-toggle.sh"))
hl.bind(key("N"),              sh("~/Documents/Projects/Daily/scripts/rofi-note.sh"))
hl.bind(key("Tab"),            sh("rofi -show window"))
hl.bind(key("W"),              sh("waypaper"))
hl.bind(key("CTRL + N"),       sh("dunstctl history-pop"))
hl.bind(key("Y"),              sh("~/.config/scripts/yt.sh"))
hl.bind(key("SHIFT + Y"),      sh("~/.config/scripts/ytmusic-toggle.sh"))
hl.bind(key("U"),              sh("~/.config/scripts/ytui-toggle.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(key("left"),  hl.dsp.focus({ direction = "left" }))
hl.bind(key("right"), hl.dsp.focus({ direction = "right" }))
hl.bind(key("up"),    hl.dsp.focus({ direction = "up" }))
hl.bind(key("down"),  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10 (key 0 = workspace 10)
for i = 1, 10 do
    local k = tostring(i % 10)
    hl.bind(key(k),             hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(key("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (bindel = locked + repeating)
local le = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  sh("~/.config/scripts/osd.sh volume up"),       le)
hl.bind("XF86AudioLowerVolume",  sh("~/.config/scripts/osd.sh volume down"),     le)
hl.bind("XF86AudioMute",         sh("~/.config/scripts/osd.sh volume mute"),     le)
hl.bind("XF86AudioMicMute",      sh("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), le)
hl.bind("XF86MonBrightnessUp",   sh("~/.config/scripts/osd.sh brightness up"),   le)
hl.bind("XF86MonBrightnessDown", sh("~/.config/scripts/osd.sh brightness down"), le)

-- Requires playerctl (bindl = locked)
hl.bind("XF86AudioNext",  sh("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  sh("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  sh("playerctl previous"),   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Pin workspaces to monitors — persistent keeps them alive when empty
hl.workspace_rule({ workspace = "1", monitor = "DP-1",     default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-1",     persistent = true })

hl.window_rule({
    name  = "wlogout-fullscreen",
    match = { class = "wlogout" },
    fullscreen = true,
})

hl.window_rule({
    name  = "no-dim-firefox",
    match = { class = "firefox" },
    opacity = "1.0 1.0",
})

hl.window_rule({
    name  = "firefox-pip",
    match = { class = "firefox", title = "Picture-in-Picture" },
    float   = true,
    pin     = true,
    size    = "30% 30%",
    move    = "69% 67%",
    opacity = "1.0 1.0",
})

hl.window_rule({
    name  = "scratchpad",
    match = { class = "scratch-term" },
    float  = true,
    size   = "80% 70%",
    center = true,
})

hl.window_rule({
    -- Only floats/sizes like this while parked in the special workspace —
    -- normal tiled use on workspace 5 is untouched.
    name  = "ytmusic-scratchpad",
    match = { class = "com.github.th-ch.youtube-music", workspace = "special:ytmusic" },
    float  = true,
    size   = "45% 75%",
    center = true,
})

hl.window_rule({
    name  = "ytui-scratchpad",
    match = { class = "ytui" },
    float  = true,
    size   = "70% 80%",
    center = true,
})

hl.window_rule({
    name  = "focus-term",
    match = { class = "dn-focus-term" },
    float  = true,
    size   = "45% 40%",
    center = true,
})

hl.window_rule({
    name  = "float-update-manager",
    match = { class = "update-manager" },
    float  = true,
    size   = "860 560",
    center = true,
})

hl.window_rule({
    name  = "float-mpv",
    match = { class = "mpv" },
    float  = true,
    center = true,
    size   = "1280 720",
})

hl.window_rule({
    -- Proton remembers a stale off-screen position (x<0) — force it onto the main monitor
    name  = "cyberpunk-onscreen",
    match = { class = "steam_app_1091500" },
    monitor = "DP-1",
    center  = true,
})

hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "pavucontrol" },
    float  = true,
    size   = "700 450",
    center = true,
})

hl.window_rule({
    name  = "float-nm-editor",
    match = { class = "nm-connection-editor" },
    float  = true,
    size   = "900 550",
    center = true,
})

hl.window_rule({
    -- Pear Desktop (YouTube Music) — glass-pill look to match kitty/rofi
    name  = "ytm-transparency",
    match = { class = "com.github.th-ch.youtube-music" },
    opacity = "0.90 0.82",
})

hl.window_rule({
    -- Ignore maximize requests from all apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Blur behind rofi
hl.layer_rule({
    name  = "blur-rofi",
    match = { namespace = "rofi" },
    blur  = true,
})

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles managed with GNU Stow. Each top-level directory is a stow package whose internal path mirrors `~/.config/` so that `stow <package>` symlinks it into `$HOME`.

`zsh/` and `ohmyposh/` are exceptions — they link into `$HOME` directly (not `~/.config/`).

## Deployment

```bash
# From ~/dotfiles, symlink a package into $HOME
stow hypr waybar kitty rofi nvim dunst wlogout scripts fastfetch zsh ohmyposh dolphin waypaper bin crandle

# Remove symlinks
stow -D hypr
```

## Package structure

Each package follows the pattern `<package>/.config/<package>/...` → `~/.config/<package>/...`.

Exceptions:
- `zsh/` maps `.zshrc` → `~/.zshrc`
- `ohmyposh/` maps `.config/ohmyposh/` → `~/.config/ohmyposh/`
- `bin/` maps `.local/bin/` → `~/.local/bin/` (user executables)

The `scripts` package maps to `~/.config/scripts/` and scripts are referenced in Hyprland keybinds and waybar modules.

## Components

### Dolphin (`dolphin/`)
- `dolphinrc` — show hidden files by default, details view, home as start location, file previews enabled
- `kdeglobals` — KDE-wide dark color scheme (`TrevorDark`) matching the cyan/dark palette; read directly by KF6 apps; sets Papirus-Dark icon theme
- `.local/share/dolphin/view_properties/global/.directory` — global view defaults: details mode, folders first, hidden files shown
- Note: `dolphin/` is an exception — it maps both `.config/` and `.local/share/dolphin/` into `$HOME`
- Requires: `plasma-integration` (KDE Qt platform theme plugin), `breeze` (Qt widget style)

### Zsh (`zsh/`)
- `.zshrc` — shell config; sources `zsh-autosuggestions`, `zsh-syntax-highlighting`, fzf key bindings, and zoxide; sets history options, aliases, launches fastfetch on start
- Plugins (installed via pacman): `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf`, `zoxide`
- fzf loaded via `/usr/share/fzf/key-bindings.zsh` + `completion.zsh`; themed via `FZF_DEFAULT_OPTS`; binds `Ctrl+R` (history), `Ctrl+T` (file), `Alt+C` (cd)
- zoxide init via `zoxide init zsh --cmd cd`; replaces `cd` with frecency-based jumping
- Default shell set via `chsh -s /bin/zsh`

### Oh My Posh (`ohmyposh/`)
- `config.toml` — two-line prompt: full path (dim) + git branch/status (green/orange/red), dim clock rprompt, cyan `❯` that turns red on non-zero exit
- Loaded in `.zshrc` via `eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"`

### Hyprland (`hypr/`)
- `hyprland.conf` — main config; sources `conf/monitors.conf` for display layout
- `conf/monitors.conf` — dual monitor: DP-1 (3440×1440@100, primary ultrawide) + HDMI-A-1 (1920×1080@60, right of primary)
- `random-wallpaper.sh` — daemon loop: picks a random image from `~/Pictures/wallpaper/`, applies it via `awww img` with a grow transition, then sleeps 30 minutes and repeats; waits for `awww-daemon` on startup
- `startup-apps.sh` — staggered workspace layout on login: disables `follow_mouse`, switches to each workspace and launches its app, re-enables `follow_mouse` after all windows appear. Order: Firefox ws1 → Firefox ws2 → kitty bot ws5 → Discord ws3 (last, slowest)
- `hypridle.conf` — locks session after 900s idle via `loginctl lock-session`
- `hyprlock.conf` — lock screen config

Active features: `inactive_opacity = 0.85`, window swallowing (kitty), smart gaps (collapse when 1 window), blur on rofi layer, `QT_QPA_PLATFORMTHEME=kde` for Dolphin theming.

Key keybinds (`$mainMod` = Super):
- `Return` → kitty, `B` → firefox, `E` → dolphin, `CTRL+Return` → rofi run
- `SHIFT+B` → restart waybar, `L` → hyprlock, `Super+Print` → screenshot
- `F` → fullscreen, `V` → toggle float, `Q` → kill active
- `SHIFT+V` → clipboard history via cliphist + rofi
- `SHIFT+E` → power menu (wlogout)
- `SHIFT+N` → toggle night mode (hyprsunset 3500K, toggle off to reset)
- `Tab` → rofi window switcher
- `W` → waypaper wallpaper picker
- `C` → hyprpicker (screen color → clipboard)
- `CTRL+N` → dunstctl history-pop (re-show last notification)
- `grave` → scratchpad terminal (spawn-on-demand kitty)
- `N` → rofi quick-capture prompt → `dn note "<text>"` (appends to today's daily note)
- `Y` → `yt.sh` (YouTube → mpv floating window)
- `XF86Audio*` / `XF86Brightness*` → `osd.sh` (dunst progress bar OSD)

### Kitty (`kitty/`)
- `kitty.conf` — font (JetBrainsMono Nerd Font Propo 13), background opacity 0.85, beam cursor with `cursor_trail 1`, dark colorscheme matching waybar/rofi palette, powerline tab bar

### Waybar (`waybar/`)
- `config.jsonc` — primary bar pinned to `DP-1`; height 34, font 14px; includes `modules.json`; clock `Mon 29  14:32`; pulseaudio scroll-wheel volume; left: `appmenu`, `files`, `tray`, `sysinfo`, `habits`; right: `mpd`, `mpris`, `pulseaudio`, `network`, `updates`, `weather`, `clock`, `power`
- `config-secondary.jsonc` — minimal bar pinned to `HDMI-A-1`; left: `appmenu`, `files`; center: `hyprland/workspaces`, `hyprland/window`; includes `modules.json` for shared definitions
- `modules.json` — defines `hyprland/workspaces` (numbered, all outputs), `hyprland/window` (active title, rewrites Firefox/kitty titles, hides when empty), `custom/appmenu` (click → rofi drun), `custom/sysinfo` (click → btop), `custom/updates`, `tray`
- `style.css` — pill backgrounds (`border-radius: 20px`) for all modules; active workspace cyan solid; `habits-all` green / `habits-partial` white / `habits-none` red / `habits-no-note` dimmed; files hover cyan; power button red on hover; `#window` pill hides when empty
- `sysinfo.sh` — outputs JSON for `custom/sysinfo` (CPU%, RAM)
- `updates.sh` — outputs pending pacman + AUR update count
- `weather.sh` — outputs current weather via wttr.in; caches last good result to `~/.cache/waybar-weather.json` so failed polls silently return stale data instead of a blank widget
- `startup.sh` — kills all waybar instances and relaunches both (`config.jsonc` + `config-secondary.jsonc`) in background; bound to `Super+Shift+B`
- `power_menu.xml` — legacy GTK menu (kept for reference; power button now launches wlogout)

Custom modules defined inline in `config.jsonc`:
- `custom/files` — "Files" button, click opens Dolphin
- `custom/habits` — polls `dn waybar` every 5 min; shows habit completion from today's note (falls back to yesterday with `(yday)` marker if no note yet); `WAYBAR_HABITS` in `daily.py` lists habits to show individually in bar text as `Name █/░` blocks followed by overall ratio (e.g. `Fitness ░  Programming █  3/4`); empty list shows ratio only

### Waypaper (`waypaper/`)
- `config.ini` — wallpaper picker config; backend set to `awww`; bound to `Super+W` (note: transition settings like grow/1.5s/60fps are configured in `random-wallpaper.sh`, not here — the `swww_transition_*` keys in config.ini are unused legacy from a prior swww setup)

### Rofi (`rofi/`)
- `config.rasi` — dark semi-transparent theme matching waybar; modes: drun (app launcher) + run (command); font: JetBrainsMono Nerd Font Propo Bold 13

### Neovim (`nvim/`)
- `init.lua` — single-file minimal config; no plugins
- Leader: `Space`
- Key options: relative numbers, 4-space indent, persistent undo, system clipboard (`unnamedplus` → wl-clipboard), `habamax` colorscheme
- Keybinds: `<C-hjkl>` window nav, `[b`/`]b` buffer nav, `<C-d/u>` centered scroll, visual `J/K` line move, `[d`/`]d` diagnostic nav
- Autocmds: yank flash, trailing whitespace strip on save, restore last cursor position, auto-equalise splits on resize

### Dunst (`dunst/`)
- `dunstrc` — notification styling matching the dark theme (rgba(20,20,20) bg, `#33ccff` frame, JetBrainsMono font, `corner_radius = 12`, Papirus-Dark icons); low/normal/critical urgency levels with distinct frame colors

### Wlogout (`wlogout/`)
- `layout` — 6 actions: lock (l), logout (e), suspend (u), hibernate (h), shutdown (s), reboot (r)
- `style.css` — dark glassmorphism theme matching waybar; cyan accent on hover; uses `/usr/share/wlogout/icons/` for button images
- Triggered by waybar power button or `Super+Shift+E`
- Requires: `yay -S wlogout`

### Scripts (`scripts/`)
- `screenshot.sh` — rofi picker for region / fullscreen / active-window; saves timestamped PNG to `~/Pictures/Screenshots/`, copies to clipboard, fires dunst notification with thumbnail
- `scratchpad.sh` — spawns kitty with `--class scratch-term` into `special:scratch` if not running, then toggles the workspace
- `osd.sh` — dunst progress-bar OSD for volume (`up`/`down`/`mute`) and brightness (`up`/`down`); called by Hyprland XF86 keybinds; uses `x-dunst-stack-tag:osd` so notifications stack rather than spam
- `discord-bot.sh` — launched by startup-apps.sh on ws5; cd into Discord_Bot project and runs `run.sh`
- `yt.sh` — open a YouTube URL in a floating mpv window; priority: Firefox address bar (via `ydotool` key injection) → clipboard → rofi prompt (pre-filled if clipboard looks like a URL); bound to `Super+Y`

Note: `~/Documents/Projects/Daily/scripts/rofi-note.sh` is part of the Daily project (not stowed), but is triggered by a Hyprland keybind (`Super+N`). It opens a minimal rofi dmenu prompt, passes the result to `dn note`, and fires a dunst confirmation notification.

### Fastfetch (`fastfetch/`)
- `config.jsonc` — system info display with custom PNG logo (`mt.png`); uses chafa for image rendering in terminal

## Package lists

- `package-list.txt` — pacman packages (`pacman -Qqe > package-list.txt`)
- `aur-package-list.txt` — AUR packages (`yay -Qqem > aur-package-list.txt`)

To restore packages on a new install:
```bash
pacman -S --needed - < package-list.txt
yay -S --needed - < aur-package-list.txt
```

### Crandle (`crandle/`)
- Systemd user units for the homelab inventory scanner (`~/Documents/Projects/crandle`)
- `crandle.service` — runs `inventory.py --master` via the project venv; writes/overwrites `~/Documents/Notes/Ventoz/Reference/HardwareSurvey.md` and saves a timestamped archive alongside it
- `crandle.timer` — fires every Sunday at 02:00; `Persistent=true` catches missed runs on next boot
- Requires a Proxmox API token set in `~/Documents/Projects/crandle/inventory.yml` (`token_id` / `token_secret`) for non-interactive auth; SSH hosts use key auth

## Runtime dependencies

Scripts rely on: `grim`, `slurp`, `wl-copy` (wl-clipboard), `hyprctl`, `awww`, `playerctl`, `wpctl` (pipewire), `cliphist`, `dunst`, `rofi`, `nm-applet`, `numlockx`, `hypridle`, `hyprlock`, `wlogout`, `hyprsunset`, `oh-my-posh`, `brightnessctl`.

Shell tools (pacman):
```bash
sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting fzf zoxide
```

Dolphin theming (pacman):
```bash
sudo pacman -S plasma-integration breeze
```

Extra packages (AUR):
```bash
yay -S wlogout hyprsunset oh-my-posh
```

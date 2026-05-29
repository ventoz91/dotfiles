# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles managed with GNU Stow. Each top-level directory is a stow package whose internal path mirrors `~/.config/` so that `stow <package>` symlinks it into `$HOME`.

## Deployment

```bash
# From ~/dotfiles, symlink a package into $HOME
stow hypr
stow waybar
stow kitty
stow fastfetch
stow scripts
stow rofi
stow nvim
stow dunst
stow wlogout

# Remove symlinks
stow -D hypr
```

## Package structure

Each package follows the pattern `<package>/.config/<package>/...` → `~/.config/<package>/...`.

The `scripts` package maps to `~/.config/scripts/` and scripts are referenced in Hyprland keybinds and waybar modules.

## Components

### Hyprland (`hypr/`)
- `hyprland.conf` — main config; sources `conf/monitors.conf` for display layout
- `conf/monitors.conf` — dual monitor: DP-1 (3440×1440@100, primary ultrawide) + HDMI-A-1 (1920×1080@60, right of primary)
- `random-wallpaper.sh` — picks a random image from `~/Pictures/wallpaper/` and sets it on both monitors via `hyprctl hyprpaper`
- `hypridle.conf` — locks session after 900s idle via `loginctl lock-session`
- `hyprlock.conf` / `hyprpaper.conf` — lock screen and wallpaper daemon config

Key keybinds (`$mainMod` = Super):
- `Return` → kitty, `B` → firefox, `E` → dolphin, `CTRL+Return` → rofi run
- `SHIFT+B` → restart waybar, `L` → hyprlock, `Print` → screenshot
- `F` → fullscreen, `V` → toggle float, `Q` → kill active
- `SHIFT+V` → clipboard history via cliphist + rofi
- `SHIFT+E` → power menu (wlogout)
- `SHIFT+N` → toggle night mode (hyprsunset 3500K, toggle off to reset)
- `Tab` → rofi window switcher
- `W` → waypaper wallpaper picker
- `C` → hyprpicker (screen color → clipboard)
- `CTRL+N` → dunstctl history-pop (re-show last notification)
- `grave` → scratchpad terminal (spawn-on-demand kitty)

### Kitty (`kitty/`)
- `kitty.conf` — font (JetBrainsMono Nerd Font Propo 13), background opacity 0.85, dark colorscheme matching waybar/rofi palette, powerline tab bar

### Waybar (`waybar/`)
- `config.jsonc` — bar layout; includes `modules.json` for shared module definitions
- `modules.json` — defines `hyprland/workspaces`, `custom/appmenu` (rofi drun), `custom/sysinfo`, and `tray`
- `sysinfo.sh` — outputs JSON for the `custom/sysinfo` module (CPU%, RAM via `/proc/stat` + `free`)
- `startup.sh` — kills and restarts waybar (used by `SUPER+SHIFT+B`)
- `style.css` — bar appearance
- `power_menu.xml` — legacy GTK menu (kept for reference; power button now launches wlogout)

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
- Requires: `paru -S wlogout`

### Scripts (`scripts/`)
- `screenshot.sh` — rofi picker for region / fullscreen / active-window; saves timestamped PNG to `~/Pictures/Screenshots/`, copies to clipboard, fires dunst notification with thumbnail
- `scratchpad.sh` — spawns kitty with `--class scratch-term` into `special:scratch` if not running, then toggles the workspace

### Fastfetch (`fastfetch/`)
- `config.jsonc` — system info display with custom PNG logo (`mt.png`); uses chafa for image rendering in terminal

## Package lists

- `package-list.txt` — pacman packages (`pacman -Qqe > package-list.txt`)
- `aur-package-list.txt` — AUR packages (`paru -Qqem > aur-package-list.txt`)

To restore packages on a new install:
```bash
pacman -S --needed - < package-list.txt
paru -S --needed - < aur-package-list.txt
```

## Runtime dependencies

Scripts rely on: `grim`, `slurp`, `wl-copy` (wl-clipboard), `hyprctl`, `hyprpaper`, `playerctl`, `wpctl` (pipewire), `cliphist`, `dunst`, `rofi`, `nm-applet`, `numlockx`, `hypridle`, `hyprlock`, `wlogout`, `hyprsunset`.

Extra packages not in `package-list.txt` (AUR):
```bash
paru -S wlogout hyprsunset
```

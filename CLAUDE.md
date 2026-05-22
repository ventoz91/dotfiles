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

### Waybar (`waybar/`)
- `config.jsonc` — bar layout; includes `modules.json` for shared module definitions
- `modules.json` — defines `hyprland/workspaces`, `custom/appmenu` (rofi drun), `custom/sysinfo`, and `tray`
- `sysinfo.sh` — outputs JSON for the `custom/sysinfo` module (CPU%, RAM via `/proc/stat` + `free`)
- `startup.sh` — kills and restarts waybar (used by `SUPER+SHIFT+B`)
- `style.css` — bar appearance
- `power_menu.xml` — GTK menu for the power button widget (shutdown, reboot, lock)

### Scripts (`scripts/`)
- `screenshot.sh` — interactive region screenshot using `grim` + `slurp`; saves to `~/Pictures/Screenshots/` and copies to clipboard via `wl-copy`

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

Scripts rely on: `grim`, `slurp`, `wl-copy` (wl-clipboard), `hyprctl`, `hyprpaper`, `playerctl`, `wpctl` (pipewire), `cliphist`, `dunst`, `rofi`, `nm-applet`, `numlockx`, `hypridle`, `hyprlock`.

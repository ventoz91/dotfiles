# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Arch Linux dotfiles managed with GNU Stow. Each top-level directory is a stow package whose internal path mirrors `~/.config/` so that `stow <package>` symlinks it into `$HOME`.

This is the `laptop` branch: a single-panel, dual-monitor-free variant of the desktop `main` branch. Homelab tooling (`crandle`), the daily-notes CLI (`bin/`, `dn`), the Discord bot launcher, and the YouTube-grab script were dropped as personal/desktop-only integrations. Battery and backlight waybar modules were added since this machine has neither on the desktop.

`zsh/` and `ohmyposh/` are exceptions — they link into `$HOME` directly (not `~/.config/`).

## Deployment

```bash
# From ~/dotfiles, symlink a package into $HOME
stow hypr waybar kitty rofi nvim dunst wlogout scripts fastfetch zsh ohmyposh dolphin waypaper

# Remove symlinks
stow -D hypr
```

## Package structure

Each package follows the pattern `<package>/.config/<package>/...` → `~/.config/<package>/...`.

Exceptions:
- `zsh/` maps `.zshrc` → `~/.zshrc`
- `ohmyposh/` maps `.config/ohmyposh/` → `~/.config/ohmyposh/`

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
- Default shell set via `chsh -s /usr/bin/zsh`

### Oh My Posh (`ohmyposh/`)
- `config.toml` — two-line prompt: full path (dim) + git branch/status (green/orange/red), dim clock rprompt, cyan `❯` that turns red on non-zero exit
- Loaded in `.zshrc` via `eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"`

### Hyprland (`hypr/`)
- `hyprland.conf` — main config; sources `conf/monitors.conf` for display layout
- `conf/monitors.conf` — single laptop panel: eDP-1 (1920×1080@60, scale 1.5)
- `random-wallpaper.sh` — daemon loop: picks a random image from `~/Pictures/wallpaper/`, applies it via `awww img` with a grow transition, then sleeps 30 minutes and repeats; waits for `awww-daemon` on startup
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
- `XF86Audio*` / `XF86Brightness*` → `osd.sh` (dunst progress bar OSD)

### Kitty (`kitty/`)
- `kitty.conf` — font (JetBrainsMono Nerd Font Propo 13), background opacity 0.85, beam cursor with `cursor_trail 1`, dark colorscheme matching waybar/rofi palette, powerline tab bar

### Waybar (`waybar/`)
- `config.jsonc` — single bar pinned to `eDP-1`; height 34, font 14px; includes `modules.json`; clock `Mon 29  14:32`; pulseaudio scroll-wheel volume; left: `appmenu`, `files`, `tray`, `sysinfo`; center: `hyprland/workspaces`, `hyprland/window`; right: `nightmode`, `backlight`, `pulseaudio`, `network`, `updates`, `battery`, `clock`, `power`
- `modules.json` — defines `hyprland/workspaces` (numbered, all outputs), `hyprland/window` (active title, rewrites Firefox/kitty titles, hides when empty), `custom/appmenu` (click → rofi drun), `custom/sysinfo` (click → htop), `custom/updates`, `tray`
- `style.css` — pill backgrounds (`border-radius: 20px`) for all modules; active workspace cyan solid; battery blinks red under 10%, amber under 20%; files hover cyan; power button red on hover; `#window` pill hides when empty
- `sysinfo.sh` — outputs JSON for `custom/sysinfo` (CPU%, RAM)
- `updates.sh` — outputs pending pacman + AUR update count
- `startup.sh` — kills all waybar instances and relaunches (`config.jsonc`) in background; bound to `Super+Shift+B`

Custom modules defined inline in `config.jsonc`:
- `custom/files` — "Files" button, click opens Dolphin
- `custom/nightmode` — ☀/☾ indicator reading `hyprsunset` process state; `Super+Shift+N` toggles

Built-in `battery`/`backlight` modules (added for this machine, absent on the desktop):
- `battery` — icon + percentage, warning under 20%, blinking critical under 10%
- `backlight` — `intel_backlight` device, scroll to adjust via `brightnessctl`

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
- `screenshot.sh` — rofi picker for region / timed region / fullscreen / active-window; saves timestamped PNG to `~/Pictures/Screenshots/`, copies to clipboard, fires dunst notification with thumbnail
- `scratchpad.sh` — spawns kitty with `--class scratch-term` into `special:scratch` if not running, then toggles the workspace
- `osd.sh` — dunst progress-bar OSD for volume (`up`/`down`/`mute`) and brightness (`up`/`down`); called by Hyprland XF86 keybinds; uses `x-dunst-stack-tag:osd` so notifications stack rather than spam
- `update-manager.sh` — interactive terminal UI for previewing/applying pacman+AUR updates and cleanup, launched from the waybar updates module

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

## Runtime dependencies

Scripts rely on: `grim`, `slurp`, `wl-copy` (wl-clipboard), `hyprctl`, `awww`, `playerctl`, `wpctl` (pipewire), `cliphist`, `dunst`, `rofi`, `nm-applet`, `numlockx`, `hypridle`, `hyprlock`, `wlogout`, `hyprsunset`, `oh-my-posh`, `brightnessctl`, `htop`.

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
yay -S wlogout waypaper oh-my-posh-bin
```

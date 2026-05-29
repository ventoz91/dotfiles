# dotfiles

Arch Linux + Hyprland desktop configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

| Component         | Tool                         |
|-------------------|------------------------------|
| Window Manager    | Hyprland                     |
| Status Bar        | Waybar                       |
| Terminal          | Kitty                        |
| App Launcher      | Rofi                         |
| Notifications     | Dunst                        |
| Lock Screen       | Hyprlock                     |
| Idle Daemon       | Hypridle                     |
| Wallpaper         | Hyprpaper + waypaper         |
| Power Menu        | wlogout                      |
| Night Mode        | hyprsunset                   |
| Clipboard Manager | cliphist                     |
| Screenshots       | grim + slurp                 |
| Text Editor       | Neovim                       |
| System Info       | Fastfetch                    |
| File Manager      | Dolphin                      |

## Prerequisites

Install all packages from the included lists:

```bash
# Official repos
sudo pacman -S --needed - < package-list.txt

# AUR (requires paru)
paru -S --needed - < aur-package-list.txt

# Extra tools used by these configs
paru -S wlogout hyprsunset
```

## Install

```bash
git clone https://github.com/ventoz91/dotfiles ~/dotfiles
cd ~/dotfiles
stow hypr waybar rofi kitty nvim dunst wlogout scripts fastfetch
```

To remove a package's symlinks:

```bash
stow -D <package>
```

## Monitors

Configured for a dual-monitor setup:
- **DP-1** — 3440×1440 @ 100Hz (primary ultrawide)
- **HDMI-A-1** — 1920×1080 @ 60Hz (right of primary)

Edit `hypr/.config/hypr/conf/monitors.conf` for your display layout.

## Keybindings

`$mainMod` = Super (Windows key)

### Applications

| Bind                  | Action                      |
|-----------------------|-----------------------------|
| `Super + Return`      | Terminal (Kitty)            |
| `Super + B`           | Browser (Firefox)           |
| `Super + E`           | File manager (Dolphin)      |
| `Super + Ctrl+Return` | App launcher (Rofi run)     |

### Desktop

| Bind                  | Action                           |
|-----------------------|----------------------------------|
| `Super + Q`           | Kill active window               |
| `Super + F`           | Fullscreen                       |
| `Super + V`           | Toggle float                     |
| `Super + L`           | Lock screen (hyprlock)           |
| `Super + Shift+E`     | Power menu (wlogout)             |
| `Super + Shift+B`     | Restart waybar                   |
| `Super + Print`       | Screenshot picker (region / fullscreen / active window) |
| `Super + Shift+V`     | Clipboard history (cliphist)     |
| `Super + Shift+N`     | Toggle night mode (hyprsunset)   |
| `Super + Tab`         | Window switcher (rofi)           |
| `Super + W`           | Wallpaper picker (waypaper)      |
| `Super + C`           | Color picker → clipboard         |
| `Super + Ctrl+N`      | Pop last notification            |
| `Super + \``          | Toggle scratchpad terminal       |

### Workspaces

| Bind                      | Action                        |
|---------------------------|-------------------------------|
| `Super + [1-0]`           | Switch to workspace           |
| `Super + Shift + [1-0]`   | Move window to workspace      |
| `Super + Scroll`          | Cycle workspaces              |
| `Super + Arrow keys`      | Move focus                    |

### Media

| Bind              | Action            |
|-------------------|-------------------|
| `XF86AudioPlay`   | Play/pause        |
| `XF86AudioNext`   | Next track        |
| `XF86AudioPrev`   | Previous track    |
| `XF86AudioMute`   | Mute              |
| `XF86AudioRaiseVolume` / `LowerVolume` | Volume ±5% |

## Structure

Each top-level directory is a stow package whose internal path mirrors `~/.config/`:

```
dotfiles/
├── hypr/           # Hyprland WM config
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── hypridle.conf
│       ├── hyprlock.conf
│       ├── hyprpaper.conf
│       ├── random-wallpaper.sh
│       └── conf/monitors.conf
├── waybar/         # Status bar
│   └── .config/waybar/
│       ├── config.jsonc
│       ├── modules.json
│       ├── style.css
│       ├── sysinfo.sh
│       ├── updates.sh
│       └── startup.sh
├── kitty/          # Terminal emulator
│   └── .config/kitty/kitty.conf
├── rofi/           # App launcher
│   └── .config/rofi/config.rasi
├── dunst/          # Notifications
│   └── .config/dunst/dunstrc
├── wlogout/        # Power menu
│   └── .config/wlogout/
│       ├── layout
│       └── style.css
├── scripts/        # Utility scripts
│   └── .config/scripts/screenshot.sh
└── fastfetch/      # System info
    └── .config/fastfetch/config.jsonc
```

## Restoring packages

```bash
sudo pacman -S --needed - < package-list.txt
paru -S --needed - < aur-package-list.txt
```

Update the lists after installing new packages:

```bash
pacman -Qqe > package-list.txt
paru -Qqem > aur-package-list.txt
```

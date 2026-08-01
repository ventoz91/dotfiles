# dotfiles (laptop)

Arch Linux + Hyprland laptop configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

This is the `laptop` branch — a trimmed-down variant of the desktop `main` branch. It drops
dual-monitor layout, homelab tooling, and other desktop/personal-workflow integrations, and adds
laptop essentials (battery, backlight, single-panel waybar).

## Stack

| Component          | Tool                        |
|--------------------|-----------------------------|
| Window Manager     | Hyprland                    |
| Status Bar         | Waybar (single bar)         |
| Terminal           | Kitty                       |
| Shell              | Zsh                         |
| Shell Prompt       | oh-my-posh                  |
| App Launcher       | Rofi                        |
| Notifications      | Dunst                       |
| Lock Screen        | Hyprlock                    |
| Idle Daemon        | Hypridle                    |
| Wallpaper Daemon   | awww (30-min random rotation) |
| Wallpaper Picker   | Waypaper                    |
| Power Menu         | wlogout                     |
| Night Mode         | hyprsunset                  |
| Clipboard Manager  | cliphist                    |
| Screenshots        | grim + slurp                |
| Text Editor        | Neovim                      |
| System Info        | Fastfetch                   |
| File Manager       | Dolphin (KDE, dark-themed)  |

## Install

### 1. Prerequisites

```bash
# Official repos
sudo pacman -S --needed stow zsh zsh-autosuggestions zsh-syntax-highlighting fzf zoxide \
    wl-clipboard cliphist brightnessctl neovim hypridle hyprlock hyprpicker hyprsunset \
    plasma-integration breeze awww numlockx

# AUR (requires yay)
yay -S --needed wlogout waypaper oh-my-posh-bin

# Set zsh as default shell
chsh -s /usr/bin/zsh
```

### 2. Clone and stow

```bash
git clone https://github.com/ventoz91/dotfiles ~/dotfiles
cd ~/dotfiles
git checkout laptop
stow hypr waybar kitty rofi nvim dunst wlogout scripts fastfetch zsh ohmyposh dolphin waypaper
```

To remove a package's symlinks:

```bash
stow -D <package>
```

### 3. Install the pacman hook

The `hooks/` package can't be stowed (pacman hooks must live at `/etc/pacman.d/hooks/` as root). Copy it manually:

```bash
sudo cp ~/dotfiles/hooks/update-pkg-lists.hook /etc/pacman.d/hooks/
```

This hook auto-regenerates `package-list.txt` and `aur-package-list.txt` after every pacman transaction, so the lists stay in sync without manual effort.

### 4. Create your wallpaper directory

`random-wallpaper.sh` expects images in `~/Pictures/wallpaper/`. Create it and drop some wallpapers in before first login:

```bash
mkdir -p ~/Pictures/wallpaper
```

If the directory is missing or empty on startup, the script logs a warning and retries every 30 minutes rather than crashing.

## Monitor

Single laptop panel:

| Output    | Resolution    | Refresh | Scale |
|-----------|---------------|---------|-------|
| eDP-1     | 1920×1080     | 60 Hz   | 1.5   |

Edit `hypr/.config/hypr/conf/monitors.conf` if your panel differs.

## Keybindings

`$mainMod` = Super (Windows key)

### Applications

| Bind                  | Action                                          |
|-----------------------|-------------------------------------------------|
| `Super + Return`      | Terminal (Kitty)                                |
| `Super + B`           | Browser (Firefox)                               |
| `Super + E`           | File manager (Dolphin)                          |
| `Super + Ctrl+Return` | App launcher (Rofi run)                         |
| `Super + Tab`         | Window switcher (Rofi)                          |

### Desktop

| Bind                  | Action                                          |
|-----------------------|-------------------------------------------------|
| `Super + Q`           | Kill active window                              |
| `Super + F`           | Fullscreen                                      |
| `Super + V`           | Toggle float                                    |
| `Super + L`           | Lock screen (hyprlock)                          |
| `Super + Shift+E`     | Power menu (wlogout)                            |
| `Super + Shift+B`     | Restart waybar                                  |
| `Super + Print`       | Screenshot picker (region / timed region / fullscreen / active window) |
| `Super + Shift+V`     | Clipboard history (cliphist + rofi)             |
| `Super + Shift+N`     | Toggle night mode (hyprsunset 3500K)            |
| `Super + W`           | Wallpaper picker (waypaper)                     |
| `Super + C`           | Color picker → clipboard (hyprpicker)           |
| `Super + Ctrl+N`      | Re-show last notification (dunstctl history-pop)|
| `Super + \``          | Toggle scratchpad terminal (Kitty)              |

### Workspaces

| Bind                    | Action                  |
|-------------------------|-------------------------|
| `Super + [1–0]`         | Switch to workspace     |
| `Super + Shift + [1–0]` | Move window to workspace|
| `Super + Scroll`        | Cycle workspaces        |
| `Super + Arrow keys`    | Move focus              |

### Media / hardware keys

| Bind                          | Action              |
|-------------------------------|---------------------|
| `XF86AudioPlay/Pause`         | Play/pause          |
| `XF86AudioNext/Prev`          | Next/previous track |
| `XF86AudioMute`               | Mute                |
| `XF86AudioRaiseVolume/Lower`  | Volume ±5% (OSD)    |
| `XF86MonBrightnessUp/Down`    | Brightness ±5% (OSD)|

Volume and brightness changes show a dunst progress-bar OSD via `osd.sh`.

## Structure

All packages follow `<package>/.config/<package>/` → `~/.config/<package>/`. Exceptions: `zsh/` links into `$HOME`, `dolphin/` links into both `~/.config/` and `~/.local/share/dolphin/`.

```
dotfiles/
├── dolphin/                    # KDE file manager config
│   ├── .config/
│   │   ├── dolphinrc           # Hidden files, details view, file previews
│   │   └── kdeglobals          # TrevorDark color scheme, Papirus-Dark icons
│   └── .local/share/dolphin/view_properties/global/.directory
├── dunst/                      # Notifications
│   └── .config/dunst/dunstrc
├── fastfetch/                  # System info (launch on shell start)
│   └── .config/fastfetch/config.jsonc
├── hooks/                      # Pacman hooks
│   └── update-pkg-lists.hook   # Auto-updates package-list.txt after any pacman transaction
├── hypr/                       # Hyprland WM
│   └── .config/hypr/
│       ├── hyprland.conf       # Main config; sources monitors.conf
│       ├── hypridle.conf       # Lock after 900s idle
│       ├── hyprlock.conf       # Lock screen appearance
│       ├── random-wallpaper.sh # 30-min rotation loop via awww with grow transition
│       └── conf/monitors.conf  # Display layout — edit this for your setup
├── kitty/                      # Terminal emulator
│   └── .config/kitty/kitty.conf
├── nvim/                       # Text editor (minimal, no plugins)
│   └── .config/nvim/init.lua
├── ohmyposh/                   # Shell prompt theme
│   └── .config/ohmyposh/config.toml
├── rofi/                       # App launcher / dmenu
│   └── .config/rofi/config.rasi
├── scripts/                    # Utility scripts (~/.config/scripts/)
│   └── .config/scripts/
│       ├── nightmode-toggle.sh # Toggle hyprsunset + signal waybar
│       ├── osd.sh              # Dunst progress-bar OSD for volume/brightness
│       ├── scratchpad.sh       # Spawn/toggle scratchpad kitty terminal
│       ├── screenshot.sh       # Region / timed region / fullscreen / window screenshot picker
│       └── update-manager.sh   # Interactive update panel (floating kitty)
├── waybar/                     # Status bar
│   └── .config/waybar/
│       ├── config.jsonc        # Single bar (eDP-1): battery, backlight, night mode, sysinfo, updates
│       ├── modules.json        # Shared module definitions
│       ├── style.css           # Pill style, cyan accent
│       ├── nightmode.sh        # ☀/☾ indicator; reads hyprsunset state
│       ├── startup.sh          # Kill + relaunch waybar
│       ├── sysinfo.sh          # CPU% and RAM for the sysinfo module
│       └── updates.sh          # Pending pacman/AUR update count
├── waypaper/                   # Wallpaper picker GUI
│   └── .config/waypaper/config.ini
├── wlogout/                    # Power menu
│   └── .config/wlogout/
│       ├── layout
│       └── style.css
└── zsh/                        # Shell config (links to $HOME)
    └── .zshrc
```

## Package lists

Package lists are kept in sync automatically — a pacman hook (`hooks/update-pkg-lists.hook`) regenerates both files after every install, upgrade, or remove transaction.

To restore packages on a fresh install:

```bash
sudo pacman -S --needed - < package-list.txt
yay -S --needed - < aur-package-list.txt
```

To update manually:

```bash
pacman -Qqen > package-list.txt
pacman -Qqem > aur-package-list.txt
```

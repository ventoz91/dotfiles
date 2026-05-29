# dotfiles

Arch Linux + Hyprland desktop configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

| Component         | Tool                         |
|-------------------|------------------------------|
| Window Manager    | Hyprland                     |
| Status Bar        | Waybar                       |
| Terminal          | Kitty                        |
| Shell             | Zsh                          |
| Shell Prompt      | oh-my-posh                   |
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

```bash
# Official repos
sudo pacman -S --needed - < package-list.txt
sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting

# AUR (requires yay)
yay -S --needed - < aur-package-list.txt
yay -S wlogout hyprsunset oh-my-posh

# Set zsh as default shell
chsh -s /bin/zsh
```

## Install

```bash
git clone https://github.com/ventoz91/dotfiles ~/dotfiles
cd ~/dotfiles
stow hypr waybar rofi kitty nvim dunst wlogout scripts fastfetch zsh ohmyposh
```

To remove a package's symlinks:

```bash
stow -D <package>
```

## Monitors

Configured for a dual-monitor setup:
- **DP-1** — 3440×1440 @ 100Hz (primary ultrawide, left)
- **HDMI-A-1** — 1920×1080 @ 60Hz (right of primary)

Edit `hypr/.config/hypr/conf/monitors.conf` for your display layout.

## Workspace layout

Workspaces 1–5 are persistent (always visible in the bar even when empty) and pinned to their monitor at login.

| Workspace | Monitor        | Startup app                          |
|-----------|----------------|--------------------------------------|
| 1         | DP-1           | Firefox                              |
| 2         | HDMI-A-1       | Firefox                              |
| 3         | HDMI-A-1       | Discord                              |
| 4         | DP-1           | *(empty)*                            |
| 5         | HDMI-A-1       | Kitty → `Discord_Bot/run.sh`         |
| 6–10      | follows window | *(dynamic)*                          |

Workspaces 1–5 are pinned with `workspace = <id>, monitor:<mon>, persistent:true` rules in `hyprland.conf`.

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

`zsh/` links into `$HOME`; all others link into `~/.config/`.

```
dotfiles/
├── zsh/                # Shell config
│   └── .zshrc
├── hypr/               # Hyprland WM config
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── hypridle.conf
│       ├── hyprlock.conf
│       ├── hyprpaper.conf
│       ├── random-wallpaper.sh
│       ├── startup-apps.sh
│       └── conf/monitors.conf
├── waybar/             # Status bar
│   └── .config/waybar/
│       ├── config.jsonc
│       ├── modules.json
│       ├── style.css
│       ├── sysinfo.sh      # CPU/RAM stats for waybar module
│       ├── updates.sh      # Pending pacman/AUR update count
│       ├── weather.sh      # Current weather via wttr.in
│       └── startup.sh      # Kill + restart waybar
├── kitty/              # Terminal emulator
│   └── .config/kitty/kitty.conf
├── ohmyposh/           # Shell prompt
│   └── .config/ohmyposh/config.toml
├── rofi/               # App launcher
│   └── .config/rofi/config.rasi
├── dunst/              # Notifications
│   └── .config/dunst/dunstrc
├── wlogout/            # Power menu
│   └── .config/wlogout/
│       ├── layout
│       └── style.css
├── nvim/               # Text editor
│   └── .config/nvim/init.lua
├── scripts/            # Utility scripts
│   └── .config/scripts/
│       ├── screenshot.sh       # Region / fullscreen / window screenshot picker
│       ├── scratchpad.sh       # Spawn/toggle scratchpad kitty terminal
│       └── discord-bot.sh      # Launch Discord bot in kitty on ws5
└── fastfetch/          # System info display
    └── .config/fastfetch/config.jsonc
```

## Restoring packages

```bash
sudo pacman -S --needed - < package-list.txt
yay -S --needed - < aur-package-list.txt
```

Update the lists after installing new packages:

```bash
pacman -Qqe > package-list.txt
yay -Qqem > aur-package-list.txt
```

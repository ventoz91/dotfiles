# TODO

## README

- [ ] **Screenshots** — add desktop preview to README; at minimum one full-desktop shot showing the waybar, active workspace, and floating window; a second showing the lock screen would be a bonus

## CLI / shell tool upgrades

- [x] **bat** — syntax-highlighted `cat` replacement; `alias cat='bat'` in `.zshrc`

- [x] **fd** — modern `find`; `FZF_DEFAULT_COMMAND`/`FZF_CTRL_T_COMMAND` wired in `.zshrc`

- [x] **yazi** — TUI file manager; `y()` wrapper in `.zshrc` cds to wherever you were browsing on quit

- [x] **eza** — modern `ls` replacement; `ls`/`ll` aliases updated in `.zshrc`

- [x] **zoxide** — `eval "$(zoxide init zsh --cmd cd)"` in `.zshrc`; replaces `cd` with frecency jumping

- [x] **fzf** — `source <(fzf --zsh)` in `.zshrc`; themed to match palette; Ctrl+R, Ctrl+T, Alt+C wired

- [x] **lazygit** — full-screen git TUI; `alias lg='lazygit'` in `.zshrc`

- [x] **btop** — resource monitor; installed, wired to waybar `custom/sysinfo` click (`kitty -e btop`)

## Pending upgrades

- [x] **awww** (formerly swww) — `awww-daemon` in autostart; `random-wallpaper.sh` rewritten as 30-min rotation loop with grow transition; hyprpaper removed

- [ ] **matugen — whole-desktop dynamic color theming from wallpaper**
  - `matugen` generates a Material You palette from any image and outputs theme
    variables for every tool simultaneously
  - Wire it into `random-wallpaper.sh` so every wallpaper rotation recolors
    waybar CSS, rofi theme, kitty colors, dunstrc frame color, and hyprlock
    background — the entire desktop repaints itself on each wallpaper change
  - Pairs perfectly with awww: fade to new wallpaper → palette regenerates → configs reload
  - Install: `yay -S matugen`
  - Scope: new `scripts/apply-theme.sh`, template files for each config,
    hook into `random-wallpaper.sh` and `waybar/startup.sh`

- [ ] **hyprexpo — Mission Control-style workspace overview**
  - Official Hyprland plugin that tiles all workspaces into a zoomable overview
    on a single keypress, like macOS Mission Control / GNOME Activities
  - One key (`Super+grave` or remap) shows every workspace live, click to jump
  - Install via hyprpm (ships with Hyprland):
    ```bash
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprexpo
    ```
  - Scope: add `plugin { hyprexpo { ... } }` block to `hyprland.conf`,
    bind `Super+SHIFT+Tab` to `hyprexpo:expo, toggle`

- [x] **Volume/brightness OSD via dunst** — `scripts/osd.sh`, keybinds updated in `hyprland.conf`

- [x] **Active window title in waybar** — `hyprland/window` in `modules.json` + `config.jsonc` + `style.css`

- [x] **Inactive window dimming** — `inactive_opacity = 0.85` in `hyprland.conf`

- [x] **Workspace icons in waybar** — Nerd Font icons per workspace in `modules.json` `format-icons`

- [x] **Window swallowing** — `enable_swallow = true` + `swallow_regex` in `misc {}` in `hyprland.conf`

- [x] **Blur layerrules** — `layerrule = blur, waybar/rofi` + bumped blur quality in `hyprland.conf`

- [x] **Smart gaps** — uncommented workspace rules in `hyprland.conf`; gaps collapse to 0 when only one window open

- [x] **Kitty cursor trail** — `cursor_trail 1` in `kitty.conf`

- [ ] **Now-playing dunst notification on track change** — no install required
  - Script running `playerctl --follow metadata` that fires `notify-send` on each track change
  - Shows artist + title + album art (if available via `playerctl metadata mpris:artUrl`)
  - Add to autostart in `hyprland.conf`; stack tag so it never spams

- [x] **Sysinfo click → btop** — `on-click` added to `custom/sysinfo` in `modules.json`

- [ ] **Picture-in-picture keybind** — no install required
  - `Super+P` floats the focused window, resizes to ~30% width, moves to bottom-right corner, pins across all workspaces
  - Bind: `hyprctl dispatch togglefloating` + `setfloatingsize` + `movewindow` + `pin`
  - Scope: one `bind` line + a small shell script in `scripts/`

- [ ] **AGS / Astal — full custom desktop shell**
  - Replace waybar entirely with a TypeScript-powered desktop shell:
    animated notification center that slides in from the right, OSD popups
    for volume/brightness/media with progress bars, a proper app dock,
    and a clock widget on the desktop
  - Every pixel is yours — no module format strings, just code
  - This is endgame Hyprland customization; budget a weekend
  - Install: `yay -S ags` (AGS v1) or `yay -S astal-git` (AGS v2 / Astal)
  - Reference configs: end-4/dots-hyprland on GitHub is the gold standard
  - Scope: new `ags/` stow package, full rewrite of the status bar surface,
    remove waybar once feature-parity is reached

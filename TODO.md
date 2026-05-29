# TODO

## Pending upgrades

- [ ] **swww** — animated wallpaper transitions
  - Replace hyprpaper with swww for smooth crossfade/grow transitions on wallpaper change
  - Update `hyprland.conf` autostart: swap `hyprpaper` for `swww-daemon`
  - Update `random-wallpaper.sh`: replace `hyprctl hyprpaper wallpaper` calls with `swww img <path> --transition-type grow --transition-pos center`
  - `hyprpaper.conf` can be removed once migrated
  - Install: `paru -S swww`

- [ ] **matugen — whole-desktop dynamic color theming from wallpaper**
  - `matugen` generates a Material You palette from any image and outputs theme
    variables for every tool simultaneously
  - Wire it into `random-wallpaper.sh` so every wallpaper rotation recolors
    waybar CSS, rofi theme, kitty colors, dunstrc frame color, and hyprlock
    background — the entire desktop repaints itself on each wallpaper change
  - Pairs perfectly with swww: fade to new wallpaper → palette regenerates → configs reload
  - Install: `paru -S matugen`
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

- [ ] **AGS / Astal — full custom desktop shell**
  - Replace waybar entirely with a TypeScript-powered desktop shell:
    animated notification center that slides in from the right, OSD popups
    for volume/brightness/media with progress bars, a proper app dock,
    and a clock widget on the desktop
  - Every pixel is yours — no module format strings, just code
  - This is endgame Hyprland customization; budget a weekend
  - Install: `paru -S ags` (AGS v1) or `paru -S astal-git` (AGS v2 / Astal)
  - Reference configs: end-4/dots-hyprland on GitHub is the gold standard
  - Scope: new `ags/` stow package, full rewrite of the status bar surface,
    remove waybar once feature-parity is reached

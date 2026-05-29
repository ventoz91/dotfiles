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

- [ ] **Volume/brightness OSD via dunst** — no install required
  - Update the XF86 volume and brightness keybinds in `hyprland.conf` to also
    fire a `notify-send` call alongside the existing `wpctl`/`brightnessctl` command
  - Pass the new value as a hint (`-h int:value:<0-100>`) so dunst renders it
    as a progress bar — instant visual feedback on every key press
  - Scope: update 4 keybind lines in `hyprland.conf`, optionally add a small
    helper script to calculate and format the current percentage cleanly

- [ ] **Active window title in waybar** — no install required
  - Waybar ships a built-in `hyprland/window` module that shows the focused
    window's title; add it to `modules-center` alongside the workspaces widget
  - Trim long titles with `max-length` and add a matching pill style in
    `style.css` so it blends with the rest of the bar
  - Scope: one module entry in `config.jsonc`, one CSS selector in `style.css`

- [ ] **Inactive window dimming** — no install required
  - Set `inactive_opacity = 0.85` in the `decoration` block of `hyprland.conf`
    so unfocused windows dim slightly, making the active window visually pop
    without any blur or border changes
  - Optional: pair with `dim_inactive = true` and `dim_strength = 0.1` for a
    subtler overlay-based dimming instead of opacity
  - Scope: two lines in `hyprland.conf`

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

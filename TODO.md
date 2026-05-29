# TODO

## Pending upgrades

- [ ] **swww** — animated wallpaper transitions
  - Replace hyprpaper with swww for smooth crossfade/grow transitions on wallpaper change
  - Update `hyprland.conf` autostart: swap `hyprpaper` for `swww-daemon`
  - Update `random-wallpaper.sh`: replace `hyprctl hyprpaper wallpaper` calls with `swww img <path> --transition-type grow --transition-pos center`
  - `hyprpaper.conf` can be removed once migrated
  - Install: `paru -S swww`

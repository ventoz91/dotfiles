#!/bin/bash
# update-manager — interactive system update panel

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

LOG=$(mktemp /tmp/pacman-update-XXXX.log)
trap 'rm -f "$LOG"' EXIT

_count() { [ -z "$1" ] && echo 0 || printf '%s\n' "$1" | grep -c .; }

fetch_updates() {
    printf "  ${DIM}Checking for updates...${RESET}\r"
    pac_raw=$(checkupdates 2>/dev/null)
    aur_raw=$(yay -Qua 2>/dev/null)
    pac_count=$(_count "$pac_raw")
    aur_count=$(_count "$aur_raw")
    total=$((pac_count + aur_count))
}

header() {
    clear
    printf "\n  ${CYAN}${BOLD}󰚰  Update Manager${RESET}\n"
    printf "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    printf "\n  pacman ${BOLD}%d${RESET}  ·  AUR ${BOLD}%d${RESET}  ·  total ${BOLD}%d${RESET}\n\n" \
        "$pac_count" "$aur_count" "$total"
}

draw_menu() {
    header
    if [ "$total" -eq 0 ]; then
        printf "  ${GREEN}  System is up to date.${RESET}\n\n"
    fi
    [ "$total" -gt 0 ] && printf "  ${BOLD}u${RESET}  Update now\n"
    [ "$total" -gt 0 ] && printf "  ${BOLD}p${RESET}  Preview packages\n"
    printf                       "  ${BOLD}c${RESET}  Cleanup  ${DIM}(orphans + cache)${RESET}\n"
    [ "$total" -gt 0 ] && printf "  ${BOLD}a${RESET}  Update + cleanup\n"
    printf                       "  ${BOLD}q${RESET}  Quit\n\n"
    printf "  → "
}

do_preview() {
    header
    if [ "$pac_count" -gt 0 ]; then
        printf "  ${BOLD}Pacman  (${pac_count}):${RESET}\n"
        printf '%s\n' "$pac_raw" | awk '{printf "    %-28s  %s → %s\n", $1, $2, $4}'
        printf "\n"
    fi
    if [ "$aur_count" -gt 0 ]; then
        printf "  ${BOLD}AUR  (${aur_count}):${RESET}\n"
        printf '%s\n' "$aur_raw" | awk '{printf "    %-28s  %s → %s\n", $1, $2, $4}'
        printf "\n"
    fi
    printf "  ${DIM}Press enter to go back...${RESET} "
    read -r _
}

show_notable() {
    notable=$(grep -iE \
        '(warning:|error:|manual intervention|\.pacnew|\.pacsave|conflict|failed to|attention:)' \
        "$LOG" \
        | grep -viE '(checking for conflicts|looking for|resolving dependencies)' \
        | sort -u)

    printf "\n  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

    if [ -z "$notable" ]; then
        printf "  ${GREEN}  No warnings or notable messages.${RESET}\n"
    else
        printf "  ${YELLOW}${BOLD}  Notable:${RESET}\n\n"
        printf '%s\n' "$notable" | while IFS= read -r line; do
            if printf '%s' "$line" | grep -qiE '(error:|failed|conflict)'; then
                printf "  ${RED}%s${RESET}\n" "$line"
            else
                printf "  ${YELLOW}%s${RESET}\n" "$line"
            fi
        done
    fi

    printf "\n  ${DIM}L = full log   enter = continue:${RESET}  "
    read -r key
    [[ "${key,,}" == "l" ]] && less -R "$LOG"
}

do_update() {
    header
    printf "  ${YELLOW}Running yay -Syu ...${RESET}\n"
    printf "  ${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"
    yay -Syu 2>&1 | tee "$LOG"
    show_notable
    pkill -SIGRTMIN+10 waybar 2>/dev/null
}

do_cleanup() {
    header
    printf "  ${YELLOW}Cleaning up...${RESET}\n\n"

    orphans=$(yay -Qdtq 2>/dev/null)
    if [ -n "$orphans" ]; then
        printf "  ${BOLD}Orphaned packages:${RESET}\n"
        printf '%s\n' "$orphans" | sed 's/^/    /'
        printf "\n"
        # shellcheck disable=SC2086
        yay -Rns $orphans
        printf "\n"
    else
        printf "  ${DIM}  No orphaned packages.${RESET}\n\n"
    fi

    printf "  ${BOLD}Package cache  ${DIM}(keeping last 2 versions):${RESET}\n"
    paccache -rk2
    printf "\n  ${GREEN}  Done.${RESET}\n\n"
    printf "  ${DIM}Press enter to continue...${RESET} "
    read -r _
    pkill -SIGRTMIN+10 waybar 2>/dev/null
}

# ── main ──────────────────────────────────────────────────────────────────
fetch_updates

while true; do
    draw_menu
    read -r choice
    case "${choice,,}" in
        u) [ "$total" -gt 0 ] && do_update; fetch_updates ;;
        p) [ "$total" -gt 0 ] && do_preview ;;
        c) do_cleanup; fetch_updates ;;
        a) [ "$total" -gt 0 ] && do_update; do_cleanup; fetch_updates ;;
        q|"") printf "\n"; break ;;
    esac
done

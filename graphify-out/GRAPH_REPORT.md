# Graph Report - dotfiles  (2026-07-27)

## Corpus Check
- Large corpus: 427 files · ~5,894,178 words. Semantic extraction will be expensive (many Claude tokens). Consider running on a subfolder.

## Summary
- 797 nodes · 686 edges · 279 communities (127 shown, 152 thin omitted)
- Extraction: 94% EXTRACTED · 5% INFERRED · 1% AMBIGUOUS · INFERRED: 36 edges (avg confidence: 0.82)
- Token cost: 283,275 input · 0 output

## Community Hubs (Navigation)
- SwayNC Core Notification Config
- Yazi MTP Mount Plugin
- Screenshot and Rofi Editor Actions
- Quickshell Overview and Theming Pipeline
- Wallpaper Effect Pipeline
- SwayNC Notification Widget Fields
- Yazi Mount Plugin
- Oh My Posh Prompt Config
- SDDM Install Script
- Yazi Restore (Trash) Plugin
- Brand Logo Icon Assets
- Screenshot Text Extractor (OCR)
- Power Menu Actions Script
- Wlogout Power Menu Icons
- Wallpaper Apply Script
- Yazi Git Status Plugin
- Yazi Mount Platform Backends
- Astro Nvim Snippets
- Hypr
- Hyprland Keybinding Helpers
- Neovim Install Script
- Nvidia Driver Install Script
- Waybar Theme Starter Docs
- Session Logout Commands
- Yazi Mount Cross-Platform Ops
- Yazi MTP Plugin Migration
- Ml4w
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Nvim Snippets
- Plugins Bookmarks Yazi
- Plugins Smart Enter Yazi
- Applications Kitty Icon
- Astro Nvim
- Hypr Scripts
- Hypr Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Version
- Ohmyposh
- Waybar
- Plugins Git Yazi
- Ml4w Assets
- Hypr Lib
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Ml4w Bin
- Ml4w
- Ml4w Listeners
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Version
- Quickshell Overview
- Shared Icons
- Shared Icons
- Plugins Chmod Yazi
- Plugins Mount Yazi
- Plugins Restore Yazi
- Applications Kitty Icon
- Hypr Assets
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Hypr Scripts
- Matugen Templates
- Ml4w Bin
- Ml4w Bin
- Ml4w Bin
- Ml4w Bin
- Ml4w Listeners
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Scripts
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Ml4w Settings
- Themes Glass
- Themes Glass Walker
- Themes Modern
- Themes Modern Walker
- Ml4w Themes
- Themes Transparent
- Nwg Dock Hyprland
- Quickshell Overview
- Quickshell Overview
- Quickshell
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Sesh
- Sesh Scripts
- Sesh Scripts
- Sesh Scripts
- Sesh Scripts
- Walker
- Waybar
- Themes Assets
- Themes Default
- Ml4w Black
- Ml4w Default
- Ml4w Glass Center Default
- Ml4w Glass Default
- Themes Ml4w Minimal
- Ml4w Modern Black
- Ml4w Modern Colored
- Ml4w Modern Default
- Ml4w Modern Minimal
- Ml4w Modern White
- Ml4w Transparent Centered Default
- Ml4w Transparent Default
- Ml4w White
- Themes Starter
- Waybar
- Plugins Full Border Yazi
- Overview Assets
- Quickshell
- Quickshell
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Shared Icons
- Themes Assets

## God Nodes (most connected - your core abstractions)
1. `WaybarApp (waybar clone in Quickshell)` - 9 edges
2. `widgets` - 8 edges
3. `error()` - 8 edges
4. `mount_action()` - 8 edges
5. `widget-config` - 7 edges
6. `wlogout power menu UI (concept)` - 7 edges
7. `get_latest_trashed_items()` - 6 edges
8. `M:entry()` - 6 edges
9. `mount_mtp()` - 6 edges
10. `list_mtp_device_by_status()` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Waybar Theme Starter (ml4w-minimal README content)` --semantically_similar_to--> `Waybar Theme Starter`  [AMBIGUOUS] [semantically similar]
  .config/waybar/themes/ml4w-minimal/README.md → .config/waybar/themes/starter/README.md
- `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)` --semantically_similar_to--> `ML4W logo icon, 20px raster variant (teal squircle with stylized 'lm' glyph)`  [INFERRED] [semantically similar]
  .config/waybar/themes/assets/ml4w-icon.png → .config/waybar/themes/assets/ml4w-icon-20.png
- `ML4W logo icon, dark-theme raster variant (black background, light glyph)` --semantically_similar_to--> `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)`  [INFERRED] [semantically similar]
  .config/waybar/themes/assets/ml4w-icon-dark.png → .config/waybar/themes/assets/ml4w-icon.png
- `ML4W logo icon, white/light-background vector variant (SVG, #f2f2f2 squircle with dark glyph)` --semantically_similar_to--> `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)`  [INFERRED] [semantically similar]
  .config/waybar/themes/assets/ml4w-icon-white.svg → .config/waybar/themes/assets/ml4w-icon.png
- `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)` --semantically_similar_to--> `ML4W logo icon, main vector (SVG, teal/cyan #19cddb squircle with dark glyph, docname ml4w_logo.svg)`  [INFERRED] [semantically similar]
  .config/waybar/themes/assets/ml4w-icon.png → .config/waybar/themes/assets/ml4w-icon.svg

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Yazi Plugin Install & Configure Pattern (ya pkg add + keymap.toml/init.lua)** — config_yazi_plugins_bookmarks_yazi_readme_bookmarks, config_yazi_plugins_chmod_yazi_readme_chmod, config_yazi_plugins_full_border_yazi_readme_full_border, config_yazi_plugins_git_yazi_readme_git, config_yazi_plugins_mount_yazi_readme_mount, config_yazi_plugins_restore_yazi_readme_restore, config_yazi_plugins_simple_mtpfs_yazi_readme_simple_mtpfs, config_yazi_plugins_smart_enter_yazi_readme_smart_enter [INFERRED 0.85]
- **Matugen Wallpaper-to-QML Theming Pipeline** — config_quickshell_readme_matugen, config_quickshell_readme_customtheme_theme_qml, config_quickshell_overview_readme_matugen, config_quickshell_overview_readme_appearance_colors_qml [INFERRED 0.85]
- **Shared Lucide-derived SVG icon set used across quickshell shell UI components (notifications, brightness, navigation)** — config_quickshell_shared_icons_bell_icon, config_quickshell_shared_icons_bell_filled_icon, config_quickshell_shared_icons_brightness_icon, config_quickshell_shared_icons_chevron_left_icon [INFERRED 0.85]
- **Brand/logo image assets identifying the two ecosystems this config is built from (Hyprland, ML4W)** — config_hypr_assets_hyprland_logo, config_ml4w_assets_ml4w_png_logo, config_ml4w_assets_ml4w_svg_logo [INFERRED 0.75]
- **Power-menu action icons (lock, logout, power, reboot) shared across quickshell power/session UI** — config_quickshell_shared_icons_lock_icon, config_quickshell_shared_icons_logout_icon, config_quickshell_shared_icons_power_icon, config_quickshell_shared_icons_reboot_icon [INFERRED 0.85]
- **Quick-action/utility icons (theme toggle, color picker, screenshot, package/update) likely used in sidebar or quick-action UI** — config_quickshell_shared_icons_darklight_icon, config_quickshell_shared_icons_picker_icon, config_quickshell_shared_icons_screenshot_icon, config_quickshell_shared_icons_package_icon [INFERRED 0.60]
- **Quickshell shared power/quick-action icons all sourced from the lucide icon library (settings, suspend/monitor-pause, terminal, theme/swatch-book, volume, volume-muted, wallpaper)** — config_quickshell_shared_icons_settings_icon, config_quickshell_shared_icons_suspend_icon, config_quickshell_shared_icons_terminal_icon, config_quickshell_shared_icons_theme_icon, config_quickshell_shared_icons_volume_muted_icon, config_quickshell_shared_icons_volume_icon, config_quickshell_shared_icons_wallpaper_icon [INFERRED 0.85]
- **ML4W logo icon variant set: same brand mark across raster/vector formats, sizes (20px vs full), and color themes (teal main, black, white, dark)** — config_waybar_themes_assets_ml4w_icon_icon, config_waybar_themes_assets_ml4w_icon_svg_icon, config_waybar_themes_assets_ml4w_icon_20_icon, config_waybar_themes_assets_ml4w_icon_black_icon, config_waybar_themes_assets_ml4w_icon_dark_icon, config_waybar_themes_assets_ml4w_icon_white_icon [INFERRED 0.85]
- **wlogout power menu action icon set (hibernate, lock, logout, reboot, shutdown, suspend)** — config_wlogout_icons_hibernate_icon, config_wlogout_icons_lock_icon, config_wlogout_icons_logout_icon, config_wlogout_icons_reboot_icon, config_wlogout_icons_shutdown_icon, config_wlogout_icons_suspend_icon [INFERRED 0.85]

## Communities (279 total, 152 thin omitted)

### Community 0 - "SwayNC Core Notification Config"
Cohesion: 0.05
Nodes (38): control-center-height, control-center-margin-left, control-center-margin-right, control-center-margin-top, control-center-width, cssPriority, app-name, state (+30 more)

### Community 1 - "Yazi MTP Mount Plugin"
Cohesion: 0.24
Nodes (19): count_yazi_instances(), error(), get_device_from_path(), get_mount_path(), info(), jump_to_device_dir_action(), jump_to_prev_cwd_action(), list_mtp_device() (+11 more)

### Community 2 - "Screenshot and Rofi Editor Actions"
Cohesion: 0.16
Nodes (18): copy_save_editor_cmd(), copy_save_editor_exit(), copy_save_editor_run(), GRIMBLAST_EDITOR, rofi_cmd(), run_cmd(), run_rofi(), screenshot.sh script (+10 more)

### Community 3 - "Quickshell Overview and Theming Pipeline"
Cohesion: 0.12
Nodes (20): Appearance.colors.qml (matugen-generated), quickshell-overview-git (AUR package), end-4 (upstream author), Hyprland, illogical-impulse (upstream dots-hyprland), Overview IPC commands (toggle/open/close), Matugen, Qt 6 (+12 more)

### Community 4 - "Wallpaper Effect Pipeline"
Cohesion: 0.31
Nodes (16): ml4w-wallpaper_v2 script, apply_effect(), error(), generate_image_variants(), info(), reload_nwg_dock(), reload_pywalfox(), reload_quickshell() (+8 more)

### Community 6 - "SwayNC Notification Widget Fields"
Cohesion: 0.12
Nodes (16): label, actions, text, image-radius, image-size, button-text, clear-all-button, text (+8 more)

### Community 7 - "Yazi Mount Plugin"
Cohesion: 0.20
Nodes (3): M.fillin(), M.obtain(), M.split()

### Community 8 - "Oh My Posh Prompt Config"
Cohesion: 0.18
Nodes (10): blocks, final_space, patch_pwsh_bleed, $schema, transient_prompt, background, foreground, newline (+2 more)

### Community 9 - "SDDM Install Script"
Cohesion: 0.35
Nodes (10): ml4w-install-sddm script, activate_sddm(), apply_theme(), check_sddm_active(), check_sddm_installed(), copy_wallpaper_to_sddm(), deactivate_sddm(), disable_other_dms() (+2 more)

### Community 10 - "Yazi Restore (Trash) Plugin"
Cohesion: 0.42
Nodes (9): error(), get_components(), get_file_type(), get_latest_trashed_items(), get_trash_volume(), M:entry(), path_quote(), restore_files() (+1 more)

### Community 11 - "Brand Logo Icon Assets"
Cohesion: 0.24
Nodes (10): Hyprland logo icon, 20px raster variant (teal/cyan wave mark on rounded square), Hyprland logo icon, full-size raster (teal/cyan wave mark on rounded square), ML4W logo icon, 20px raster variant (teal squircle with stylized 'lm' glyph), ML4W logo icon, dark/black-background vector variant (SVG, #242424 squircle with light glyph), ML4W logo icon, dark-theme raster variant (black background, light glyph), ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph), ML4W logo icon, main vector (SVG, teal/cyan #19cddb squircle with dark glyph, docname ml4w_logo.svg), ML4W logo icon, white/light-background vector variant (SVG, #f2f2f2 squircle with dark glyph) (+2 more)

### Community 12 - "Screenshot Text Extractor (OCR)"
Cohesion: 0.36
Nodes (5): check_deps(), cleanup(), die(), safe_kill(), text-extractor.sh script

### Community 13 - "Power Menu Actions Script"
Cohesion: 0.46
Nodes (7): ml4w-power script, lock_action(), logout_action(), poweroff_action(), reboot_action(), show_help(), suspend_action()

### Community 14 - "Wlogout Power Menu Icons"
Cohesion: 0.25
Nodes (8): Hibernate action icon (wlogout power menu), Lock action icon (wlogout power menu), Logout action icon (wlogout power menu), Reboot action icon (wlogout power menu), Shutdown action icon (wlogout power menu), Suspend action icon (wlogout power menu), Noise background texture (wlogout), wlogout power menu UI (concept)

### Community 15 - "Wallpaper Apply Script"
Cohesion: 0.48
Nodes (5): ml4w-wallpaper script, error(), info(), send_notification(), show_help()

### Community 16 - "Yazi Git Status Plugin"
Cohesion: 0.48
Nodes (5): bubble_up(), fetch(), match(), propagate_down(), root()

### Community 17 - "Yazi Mount Platform Backends"
Cohesion: 0.33
Nodes (7): diskutil (macOS), eject, keymap.toml, lsblk, mount.yazi, udisksctl, util-linux

### Community 18 - "Astro Nvim Snippets"
Cohesion: 0.33
Nodes (5): contributes, snippets, engines, vscode, name

### Community 19 - "Hypr"
Cohesion: 0.73
Nodes (5): M.load(), parse_extra_flags(), parse_monitor_line(), split_csv(), trim()

### Community 20 - "Hyprland Keybinding Helpers"
Cohesion: 0.60
Nodes (5): build_combo(), decode_modmask(), M.get_formatted_binds(), M.show(), prettify_key()

### Community 21 - "Neovim Install Script"
Cohesion: 0.47
Nodes (3): ml4w-install-nvim script, info(), success()

### Community 22 - "Nvidia Driver Install Script"
Cohesion: 0.47
Nodes (3): ml4w-nvidia script, success(), warn()

### Community 23 - "Waybar Theme Starter Docs"
Cohesion: 0.33
Nodes (6): config.sh (theme name entry), Waybar Theme Starter (ml4w-minimal README content), Waybar Themeswitcher (SUPER+CTRL+T), config.sh (theme name entry), Waybar Theme Starter, Waybar Themeswitcher (SUPER+CTRL+T)

### Community 24 - "Session Logout Commands"
Cohesion: 0.33
Nodes (6): Display Manager logout command (hyprctl dispatch exit), hyprctl, loginctl, wlogout Logout Command Selection, sddm (display manager), Arch text-login logout command (loginctl terminate-user)

### Community 25 - "Yazi Mount Cross-Platform Ops"
Cohesion: 0.60
Nodes (5): M.diskutil(), M.eject(), M.fail(), M.operate(), M.udisksctl()

### Community 26 - "Yazi MTP Plugin Migration"
Cohesion: 0.33
Nodes (6): gvfs.yazi (successor plugin), init.lua, keymap.toml, simple-mtpfs.yazi, simple-mtpfs (underlying FUSE/MTP tool), yazi.toml (preloaders/previewers)

### Community 27 - "Ml4w"
Cohesion: 0.90
Nodes (4): restart_listener(), listeners.sh script, start_listener(), stop_listener()

### Community 28 - "Ml4w Scripts"
Cohesion: 0.60
Nodes (3): ml4w-autostart script, info(), warn()

### Community 29 - "Ml4w Scripts"
Cohesion: 0.60
Nodes (3): ml4w-check-dotfiles-update script, testvercomp(), vercomp()

### Community 31 - "Ml4w Scripts"
Cohesion: 0.60
Nodes (3): ml4w-wallpaper-app script, error(), info()

### Community 32 - "Nvim Snippets"
Cohesion: 0.40
Nodes (4): contributes, snippets, name, version

### Community 33 - "Plugins Bookmarks Yazi"
Cohesion: 0.40
Nodes (5): bookmarks.yazi, Yazi DDS (bookmark persistence state file), init.lua, keymap.toml, Yazi

### Community 34 - "Plugins Smart Enter Yazi"
Cohesion: 0.40
Nodes (5): enter action (mgr.enter), init.lua, keymap.toml, open action (mgr.open), smart-enter.yazi

### Community 35 - "Applications Kitty Icon"
Cohesion: 0.40
Nodes (5): k0nserv/kitty-icon (alternative icon), Kitty (terminal emulator), kitty.app (macOS bundle), Kitty Application Icon, node/npx (build tooling)

### Community 36 - "Astro Nvim"
Cohesion: 0.50
Nodes (4): neovim.yml (lua_ls type-checking config), vim global (Lua global for Neovim API), AstroNvim, AstroNvim Template

### Community 37 - "Hypr Scripts"
Cohesion: 0.83
Nodes (3): _launch_rofi(), _launch_walker(), launcher.sh script

### Community 38 - "Hypr Scripts"
Cohesion: 0.83
Nodes (3): focus(), move(), workspace.sh script

### Community 43 - "Ml4w Version"
Cohesion: 0.67
Nodes (3): library.sh script, testvercomp(), vercomp()

### Community 44 - "Ohmyposh"
Cohesion: 0.50
Nodes (3): blocks, $schema, version

### Community 46 - "Plugins Git Yazi"
Cohesion: 0.50
Nodes (4): git.yazi, init.lua, theme.toml/flavor.toml (status sign styling), yazi.toml (git fetcher registration)

### Community 47 - "Ml4w Assets"
Cohesion: 0.67
Nodes (3): Hyprland brand logo (teal/cyan gradient waterdrop mark) used as Hypr ecosystem branding asset, ML4W logo raster (teal rounded-square badge with 'ml.' wordmark), ML4W logo vector source (Inkscape SVG: teal rounded square with 'ml' wordmark glyphs)

### Community 61 - "Quickshell Overview"
Cohesion: 0.67
Nodes (3): GlobalStates.qml (global state management), HyprlandData.qml (Hyprland data provider), shell.qml (overview entry point)

### Community 62 - "Shared Icons"
Cohesion: 0.67
Nodes (3): darklight.svg (lucide sun icon, used as dark/light theme toggle), picker.svg (lucide pipette icon, color picker tool), screenshot.svg (lucide camera icon, screenshot action)

### Community 63 - "Shared Icons"
Cohesion: 0.67
Nodes (3): settings.svg - lucide 'settings' gear icon (white stroke), theme.svg - lucide 'swatch-book' icon (color swatch book), used for theme/appearance action, ml4w.svg - ML4W brand logo (Inkscape SVG, teal rounded-square with 'lm' lettermark), used as quickshell shared branding asset

### Community 64 - "Plugins Chmod Yazi"
Cohesion: 0.67
Nodes (3): chmod.yazi, chmod(2) syscall, keymap.toml

### Community 66 - "Plugins Restore Yazi"
Cohesion: 0.67
Nodes (3): keymap.toml, restore.yazi, trash-cli

### Community 68 - "Applications Kitty Icon"
Cohesion: 1.00
Nodes (3): Kitty terminal app icon - dark variant (navy cat head), Kitty terminal app icon - light variant (cream cat head), Kitty terminal emulator app (concept)

## Ambiguous Edges - Review These
- `Waybar Theme Starter (ml4w-minimal README content)` → `Waybar Theme Starter`  [AMBIGUOUS]
  .config/waybar/themes/ml4w-minimal/README.md · relation: semantically_similar_to
- `chevron-right.svg (lucide chevron-right icon)` → `launcher.svg (lucide layout-grid icon, app launcher)`  [AMBIGUOUS]
  .config/quickshell/shared/icons/chevron-right.svg · relation: conceptually_related_to
- `settings.svg - lucide 'settings' gear icon (white stroke)` → `ml4w.svg - ML4W brand logo (Inkscape SVG, teal rounded-square with 'lm' lettermark), used as quickshell shared branding asset`  [AMBIGUOUS]
  .config/quickshell/shared/ml4w.svg · relation: conceptually_related_to
- `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)` → `OpenAI logo icon, black fill variant (official OpenAI mark, per embedded <title>OpenAI icon</title>)`  [AMBIGUOUS]
  .config/waybar/themes/assets/openai-black.svg · relation: conceptually_related_to

## Knowledge Gaps
- **246 isolated node(s):** `name`, `vscode`, `snippets`, `cleanup.sh script`, `gtk.sh script` (+241 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **152 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Waybar Theme Starter (ml4w-minimal README content)` and `Waybar Theme Starter`?**
  _Edge tagged AMBIGUOUS (relation: semantically_similar_to) - confidence is low._
- **What is the exact relationship between `chevron-right.svg (lucide chevron-right icon)` and `launcher.svg (lucide layout-grid icon, app launcher)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `settings.svg - lucide 'settings' gear icon (white stroke)` and `ml4w.svg - ML4W brand logo (Inkscape SVG, teal rounded-square with 'lm' lettermark), used as quickshell shared branding asset`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `ML4W logo icon, main raster (teal/cyan #19cddb squircle with dark glyph)` and `OpenAI logo icon, black fill variant (official OpenAI mark, per embedded <title>OpenAI icon</title>)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `widget-config` connect `SwayNC Notification Widget Fields` to `SwayNC Core Notification Config`?**
  _High betweenness centrality (0.002) - this node is a cross-community bridge._
- **What connects `name`, `vscode`, `snippets` to the rest of the system?**
  _246 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwayNC Core Notification Config` be split into smaller, more focused modules?**
  _Cohesion score 0.05128205128205128 - nodes in this community are weakly interconnected._
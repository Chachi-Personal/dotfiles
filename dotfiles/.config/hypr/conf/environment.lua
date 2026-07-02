local env = hl.env

-- -----------------------------------------------------
-- Environment Variables
-- name: "Default Apps"
-- -----------------------------------------------------
env("BROWSER", "helium-browser")
env("TERMINAL", "kitty")

-- -----------------------------------------------------
-- Environment Variables
-- name: "Default Apps"
-- -----------------------------------------------------
env("ML4W_PERSONAL_DIR", "/home/chachi/Documents/personal")
env("ML4W_PROJECTS_DIR", "/home/chachi/Documents/projects")
env("ML4W_UNIVERSITY_DIR", "/home/chachi/Documents/uni")
env("ML4W_WALLPAPERS_DIR", "/home/chachi/.config/ml4w/wallpapers")

-- -----------------------------------------------------
-- Environment Variables
-- name: "Default Apps"
-- -----------------------------------------------------
env("GTK_IM_MODULE", "wayland")
env("GT_IM_MODULE", "fcitx")
env("XMODIFIERS", "@im=fcitx")
env("SDL_IM_MODULE", "fcitx")
env("GLFW_IM_MODULE", "fcitx")

-- -----------------------------------------------------
-- Environment Variables
-- name: "Nvidia"
-- -----------------------------------------------------
-- env("LIBVA_DRIVER_NAME", "nvidia")
-- env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- env("GBM_BACKEND", "nvidia-drm")
-- env("SDL_VIDEODRIVER", "wayland")
-- env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- env("__VK_LAYER_NV_optimus", "NVIDIA_only")
--
-- env("WLR_NO_HARDWARE_CURSORS", "1")
-- env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
--
-- env("MOZ_DISABLE_RDD_SANDBOX", "1")
-- env("EGL_PLATFORM", "wayland")
--
-- env("NVD_BACKEND", "direct")

-- XDG Desktop Portal
env("XDG_CURRENT_DESKTOP", "Hyprland")
env("XDG_SESSION_DESKTOP", "Hyprland")
env("XDG_SESSION_TYPE", "wayland")

-- QT
env("QT_QPA_PLATFORM", "wayland;xcb")
env("QT_QPA_PLATFORMTHEME", "qt6ct")
env("QT_QPA_PLATFORMTHEME", "qt5ct")
env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GDK
env("GDK_SCALE", "1")
-- Toolkit Backend
env("GDK_BACKEND", "wayland,x11,*")
env("CLUTTER_BACKEND", "wayland")

-- Mozilla
env("MOZ_ENABLE_WAYLAND", "1")

-- Set the cursor size for xcursor
env("XCURSOR_SIZE", "24")
env("HYPRCURSOR_SIZE", "24")

-- Ozone
-- env("OZONE_PLATFORM", "wayland")
env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- SDL version
env("SDL_VIDEODRIVER", "wayland,x11")

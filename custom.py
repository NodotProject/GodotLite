# custom.py — daccord minimal export template build flags
# Godot 4.5

# Size optimization
optimize = "size"          # -Os compiler flag (smaller binary)
lto = "full"               # Link-time optimization (slower build, smaller output)
deprecated = "no"          # Strip deprecated API wrappers

# Strip 3D engine (daccord is 2D-only)
disable_3d = "yes"

# Renderer — daccord uses GL Compatibility, not Vulkan
vulkan = "no"
use_volk = "no"

# Disable unused features
openxr = "no"              # No VR/AR support needed
minizip = "no"             # No ZIP archive support needed

# Text server — use fallback (no RTL/complex script support)
module_text_server_adv_enabled = "no"
module_text_server_fb_enabled = "yes"

# Aggressive stripping: disable all modules by default, enable only what daccord uses
modules_enabled_by_default = "no"

# Modules daccord actually needs
module_gdscript_enabled = "yes"          # Scripting language
module_text_server_fb_enabled = "yes"    # Text rendering
module_freetype_enabled = "yes"          # Font rendering
module_svg_enabled = "yes"               # SVG icon support (theme/icons/)
module_webp_enabled = "yes"              # WebP image support
module_godot_physics_2d_enabled = "yes"  # 2D physics (if used)
module_websocket_enabled = "yes"         # WebSocket gateway
module_mbedtls_enabled = "yes"           # TLS for HTTPS/WSS
module_regex_enabled = "yes"             # Regex (used in markdown parsing)

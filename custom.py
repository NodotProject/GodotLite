# custom.py — minimal export template build flags
# Godot 4.5

# Size optimization
optimize = "size"          # -Os compiler flag (smaller binary)
lto = "full"               # Link-time optimization (slower build, smaller output)
deprecated = "no"          # Strip deprecated API wrappers

# Strip gaming stuffs
disable_3d = "yes"
disable_navigation_2d="yes"
disable_navigation_3d="yes"
disable_xr="yes"

# Keep app stuff
accesskit="yes"

# Renderer — GL Compatibility, not Vulkan
vulkan = "no"
use_volk = "no"

# Disable unused features
openxr = "no"              # No VR/AR support needed
minizip = "yes"            # ZIP support (updater)

# Aggressive stripping: disable all modules by default, enable only what's needed
modules_enabled_by_default = "no"

# Enabled modules
module_gdscript_enabled = "yes"          # Scripting language
module_freetype_enabled = "yes"          # Font rendering
module_svg_enabled = "yes"               # SVG icon support (theme/icons/)
module_webp_enabled = "yes"              # WebP image support
module_websocket_enabled = "yes"         # WebSocket gateway
module_mbedtls_enabled = "yes"           # TLS for HTTPS/WSS
module_regex_enabled = "yes"             # Regex (used in markdown parsing)
module_text_server_fb_enabled = "yes"
module_ogg_enabled = "yes"              # OGG container (audio)
module_vorbis_enabled = "yes"           # OGG Vorbis audio
module_minimp3_enabled = "yes"          # MP3 audio

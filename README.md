# GodotLite

Minimal Godot 4 export templates for shipping smaller games and apps.

Official Godot export templates include every engine feature — 3D, Vulkan, XR, advanced text shaping, and dozens of modules — whether your project uses them or not. GodotLite provides pre-built export templates with all of that stripped out, resulting in significantly smaller exports.

## Usage

1. Download the export template for your platform from the [Releases](https://github.com/NodotProject/GodotLite/releases) page
2. Open your project in the Godot editor
3. Go to **Project > Export**
4. Select your export preset
5. Under **Custom Template**, set **Release** to the path of the downloaded template
6. Export your project as usual

## What's removed

Compared to official Godot export templates, GodotLite removes:

- **3D engine** — for 2D-only projects
- **Vulkan renderer** — uses GL Compatibility instead
- **XR/VR/AR support**
- **ZIP archive support**
- **Advanced text shaping** — no right-to-left or complex script support (uses the fallback text server)
- **Deprecated API wrappers**
- **All optional modules not explicitly enabled**

If your project depends on any of the above, use the official Godot export templates or build custom templates from source (see Development below).

## Development

This section is for contributors or anyone who wants to build custom templates from source.

### How it works

Godot's build system supports a `custom.py` file that overrides default build options. GodotLite ships a `custom.py` that:

1. **Disables all modules by default** (`modules_enabled_by_default = "no"`)
2. **Re-enables only the modules your project needs** (GDScript, FreeType, etc.)
3. **Strips unused engine subsystems** (3D, Vulkan, XR)
4. **Optimizes for size** (`optimize = "size"`, full LTO)

The build script clones a pinned Godot version (currently `4.5`), copies `custom.py` into the source tree, and runs `scons` to produce the templates.

### Requirements

- `git`
- `scons`
- A C/C++ toolchain for your platform (`g++`/`clang`)
- Godot build dependencies for your OS (see the [official compiling docs](https://docs.godotengine.org/en/stable/contributing/development/compiling/))

### Building

```bash
./build.sh              # all platforms
./build.sh linux        # Linux x86_64 only
./build.sh windows      # Windows x86_64 (cross-compile)
./build.sh macos        # macOS universal binary
```

Templates are output to `godot/bin/`.

### Customizing `custom.py`

The default configuration is tuned for a 2D app using the GL Compatibility renderer. Adjust it to fit your needs:

**If your project uses 3D**, change or remove:
```python
disable_3d = "yes"  # remove this line or set to "no"
```

**If your project uses Vulkan**, change:
```python
vulkan = "no"       # set to "yes"
use_volk = "no"     # set to "yes"
```

**Enable or disable modules** depending on what your project actually uses. The key pattern is:

```python
# Disable everything first
modules_enabled_by_default = "no"

# Then enable only what you need
module_gdscript_enabled = "yes"
module_freetype_enabled = "yes"
# ... add or remove modules as needed
```

Common modules you might want to enable:

| Module | What it provides |
|--------|-----------------|
| `module_gdscript_enabled` | GDScript language |
| `module_mono_enabled` | C# language support |
| `module_freetype_enabled` | Font rendering |
| `module_svg_enabled` | SVG image support |
| `module_webp_enabled` | WebP image support |
| `module_websocket_enabled` | WebSocket networking |
| `module_mbedtls_enabled` | TLS for HTTPS/WSS |
| `module_regex_enabled` | Regular expressions |
| `module_godot_physics_2d_enabled` | 2D physics |
| `module_godot_physics_3d_enabled` | 3D physics |
| `module_navigation_enabled` | Pathfinding/navigation |
| `module_multiplayer_enabled` | High-level multiplayer API |

A full list of modules is available in the `modules/` directory of the Godot source, or in the [Godot build option docs](https://docs.godotengine.org/en/stable/contributing/development/compiling/introduction_to_the_buildsystem.html).

# godotlite

Minimal Godot 4 export-template builder for daccord.

This repo pins a Godot version, clones the upstream engine source, and builds `template_release` export templates using a slimmed-down `custom.py` configuration.

## What’s removed (and why)

These templates are intentionally smaller and more focused than official Godot export templates. They’re built for daccord’s needs (2D, GL Compatibility) and leave out features that daccord doesn’t use.

Compared to a full Godot export template, this build removes:

- **3D support** (daccord is 2D-only)
- **Vulkan rendering** (targets the GL Compatibility renderer instead)
- **XR/VR/AR support**
- **Built-in ZIP archive features**
- **Advanced text support** (right-to-left and complex scripts; some languages may not render correctly)
- **Compatibility helpers for deprecated/older APIs** (older projects may need updates)
- **Most other optional engine modules** that aren’t needed for daccord

If you need any of the above, use the official Godot export templates or build your own full templates from upstream.

## Requirements

- `git`
- `scons`
- A C/C++ toolchain for your platform (`g++`/`clang`)
- Godot build dependencies for your OS (see the official compiling docs)

## Usage

Build all supported platforms (per `build.sh`):

```bash
./build.sh
```

Build a single platform:

```bash
./build.sh linux
./build.sh windows
./build.sh macos
```

Outputs land under `godot/bin/` (inside the cloned Godot source tree).

## Godot version

The pinned Godot version is in `build.sh` as `GODOT_VERSION` (currently `4.5`).

## Releases

Pushing a tag like `v1.2.3` triggers the GitHub Actions workflow that creates a GitHub Release and uploads source archives (`.zip` and `.tar.gz`).

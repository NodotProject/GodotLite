# godotlite

Minimal Godot 4 export-template builder for daccord.

This repo pins a Godot version, clones the upstream engine source, and builds `template_release` export templates using a slimmed-down `custom.py` configuration.

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

The pinned Godot version is in `build.sh` as `GODOT_VERSION` (currently `4.5.1-stable`).

## Releases

Pushing a tag like `v1.2.3` triggers the GitHub Actions workflow that creates a GitHub Release and uploads source archives (`.zip` and `.tar.gz`).


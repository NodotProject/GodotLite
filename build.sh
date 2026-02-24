#!/usr/bin/env bash
set -euo pipefail

GODOT_VERSION="4.5"
GODOT_REPO="https://github.com/godotengine/godot.git"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GODOT_DIR="$SCRIPT_DIR/godot"
BIN_DIR="$GODOT_DIR/bin"

usage() {
    echo "Usage: $0 [platform...]"
    echo ""
    echo "Builds custom minimal Godot export templates for daccord."
    echo ""
    echo "Platforms:"
    echo "  linux     Build Linux x86_64 template"
    echo "  windows   Build Windows x86_64 template (cross-compile)"
    echo "  macos     Build macOS universal template"
    echo "  all       Build all platforms (default)"
    echo ""
    echo "Examples:"
    echo "  $0              # Build all platforms"
    echo "  $0 linux        # Build Linux only"
    echo "  $0 linux windows"
    exit 1
}

check_deps() {
    local missing=()
    command -v scons >/dev/null 2>&1 || missing+=("scons")
    command -v g++ >/dev/null 2>&1 || missing+=("g++")
    command -v git >/dev/null 2>&1 || missing+=("git")

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: missing dependencies: ${missing[*]}"
        echo "See https://docs.godotengine.org/en/stable/contributing/development/compiling/"
        exit 1
    fi
}

clone_godot() {
    if [[ -d "$GODOT_DIR/.git" ]]; then
        local current_tag
        current_tag="$(git -C "$GODOT_DIR" describe --tags 2>/dev/null || true)"
        if [[ "$current_tag" == "$GODOT_VERSION" ]]; then
            echo "Godot $GODOT_VERSION source already present."
            return
        fi
        echo "Godot source exists but is $current_tag, expected $GODOT_VERSION."
        echo "Remove godot/ and re-run, or update GODOT_VERSION."
        exit 1
    fi

    echo "Cloning Godot $GODOT_VERSION..."
    git clone --depth 1 --branch "$GODOT_VERSION" "$GODOT_REPO" "$GODOT_DIR"
}

copy_build_config() {
    echo "Copying custom.py into Godot source..."
    cp "$SCRIPT_DIR/custom.py" "$GODOT_DIR/custom.py"
}

build_platform() {
    local platform="$1"
    local scons_platform arch output_name
    local -a extra_scons_args
    extra_scons_args=()

    case "$platform" in
        linux)
            scons_platform="linuxbsd"
            arch="x86_64"
            output_name="godot.linuxbsd.template_release.x86_64"
            ;;
        windows)
            scons_platform="windows"
            arch="x86_64"
            output_name="godot.windows.template_release.x86_64.exe"
            # GCC on MinGW can ICE with full LTO; disable for Windows builds.
            extra_scons_args+=("lto=none")
            ;;
        macos)
            scons_platform="macos"
            arch="universal"
            output_name="godot.macos.template_release.universal"
            ;;
        *)
            echo "Unknown platform: $platform"
            usage
            ;;
    esac

    if [[ "$platform" == "macos" ]]; then
        local arm_bin x64_bin
        arm_bin="$BIN_DIR/godot.macos.template_release.arm64"
        x64_bin="$BIN_DIR/godot.macos.template_release.x86_64"

        echo ""
        echo "=== Building $platform (arm64) ==="
        scons -C "$GODOT_DIR" platform="$scons_platform" target=template_release arch="arm64" "${extra_scons_args[@]+"${extra_scons_args[@]}"}"

        echo ""
        echo "=== Building $platform (x86_64) ==="
        scons -C "$GODOT_DIR" platform="$scons_platform" target=template_release arch="x86_64" "${extra_scons_args[@]+"${extra_scons_args[@]}"}"

        if [[ ! -f "$arm_bin" ]] || [[ ! -f "$x64_bin" ]]; then
            echo "Error: expected macOS output not found: $arm_bin or $x64_bin"
            exit 1
        fi

        echo ""
        echo "=== Creating macOS universal binary ==="
        if ! command -v lipo >/dev/null 2>&1; then
            echo "Error: lipo not found. Install Xcode command line tools."
            exit 1
        fi
        lipo -create "$arm_bin" "$x64_bin" -output "$BIN_DIR/$output_name"
    else
        echo ""
        echo "=== Building $platform ($arch) ==="
        scons -C "$GODOT_DIR" platform="$scons_platform" target=template_release arch="$arch" "${extra_scons_args[@]+"${extra_scons_args[@]}"}"
    fi

    if [[ -f "$BIN_DIR/$output_name" ]]; then
        local size
        size="$(du -h "$BIN_DIR/$output_name" | cut -f1)"
        echo "Built: $BIN_DIR/$output_name ($size)"
    else
        echo "Error: expected output not found: $BIN_DIR/$output_name"
        exit 1
    fi
}

main() {
    local platforms=()

    if [[ $# -eq 0 ]] || [[ "$1" == "all" ]]; then
        platforms=(linux windows macos)
    else
        for arg in "$@"; do
            case "$arg" in
                -h|--help) usage ;;
                *) platforms+=("$arg") ;;
            esac
        done
    fi

    echo "godot4apps — custom export template builder"
    echo "Godot version: $GODOT_VERSION"
    echo "Platforms: ${platforms[*]}"
    echo ""

    check_deps
    clone_godot
    copy_build_config

    for platform in "${platforms[@]}"; do
        build_platform "$platform"
    done

    echo ""
    echo "=== Done ==="
    echo "Templates in: $BIN_DIR/"
    ls -lh "$BIN_DIR"/*.template_release.* 2>/dev/null || true
}

main "$@"

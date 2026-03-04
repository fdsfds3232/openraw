#!/usr/bin/env bash
# OpenRaw installer — one command, installs Rust if needed
# Usage: curl -sSf https://raw.githubusercontent.com/fdsfds3232/openraw/main/install.sh | sh
#
# Environment: OPENRAW_VERSION = version tag | OPENRAW_DESKTOP=1 to also install desktop

set -euo pipefail

REPO="fdsfds3232/openraw"
CARGO_BIN="$HOME/.cargo/bin"

echo ""
echo "  OpenRaw Installer"
echo "  ================="
echo ""

ensure_rust() {
    if command -v cargo &>/dev/null; then return; fi
    echo "  Rust not found. Downloading and installing rustup..."
    echo ""
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
    if ! command -v cargo &>/dev/null; then
        echo "  Restart your terminal and run the install script again."
        exit 1
    fi
    echo "  Rust installed."
    echo ""
}

ensure_rust

VERSION_ARG=""
if [ -n "${OPENRAW_VERSION:-}" ]; then
    VERSION_ARG="--tag $OPENRAW_VERSION"
    echo "  Installing OpenRaw $OPENRAW_VERSION..."
else
    echo "  Installing OpenRaw CLI from source..."
fi
echo ""

cargo install --git "https://github.com/$REPO" openraw-cli $VERSION_ARG

SHELL_RC=""
case "${SHELL:-}" in
    */zsh) SHELL_RC="$HOME/.zshrc" ;;
    */bash) SHELL_RC="$HOME/.bashrc" ;;
    */fish) SHELL_RC="$HOME/.config/fish/config.fish" ;;
esac

if [ -n "$SHELL_RC" ] && ! grep -q ".cargo/bin" "$SHELL_RC" 2>/dev/null; then
    case "${SHELL:-}" in
        */fish)
            mkdir -p "$(dirname "$SHELL_RC")"
            echo "set -gx PATH \"$CARGO_BIN\" \$PATH" >> "$SHELL_RC"
            ;;
        *)
            echo "export PATH=\"$CARGO_BIN:\$PATH\"" >> "$SHELL_RC"
            ;;
    esac
    echo "  Added $CARGO_BIN to PATH."
fi

INSTALL_DESKTOP="${OPENRAW_DESKTOP:-}"
if [ -z "$INSTALL_DESKTOP" ] && [ -t 0 ]; then
    echo ""
    printf "  Install desktop app too? [Y/n] "
    read -r r
    case "${r:-y}" in
        [Nn]*) ;;
        *) INSTALL_DESKTOP=1 ;;
    esac
fi

if [ -n "$INSTALL_DESKTOP" ]; then
    echo ""
    echo "  Installing OpenRaw Desktop (this may take a few minutes)..."
    cargo install --git "https://github.com/$REPO" openraw-desktop $VERSION_ARG && echo "  Desktop installed." || true
fi

VER=$("$CARGO_BIN/openraw" --version 2>/dev/null || echo "installed")
echo ""
echo "  OpenRaw installed! ($VER)"
echo ""
echo "  Get started: openraw init"
echo ""

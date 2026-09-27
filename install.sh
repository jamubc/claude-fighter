#!/bin/sh
# claude-fighter installer: puts `claude-fighter` on your PATH as a symlink to the
# python renderer. Nothing is written into ~/.claude — hooks load per-session via
# `claude --settings`. Re-run after `git pull`; it's idempotent.
#
#   ./install.sh            # -> ~/.local/bin/claude-fighter
#   ./install.sh /usr/local/bin
#   ./install.sh --uninstall
set -eu
ROOT=$(cd "$(dirname "$0")" && pwd)
TARGET="$ROOT/python/claude-fighter"
BIN=${1:-"$HOME/.local/bin"}

if [ "${1:-}" = "--uninstall" ]; then
  for d in "$HOME/.local/bin" /usr/local/bin; do
    [ -L "$d/claude-fighter" ] && rm "$d/claude-fighter" && echo "removed $d/claude-fighter"
  done
  exit 0
fi

command -v python3 >/dev/null || { echo "python3 not found" >&2; exit 1; }
command -v claude  >/dev/null || echo "warning: 'claude' not on PATH; install Claude Code first" >&2
python3 -c "import json;json.load(open('$ROOT/hooks/settings.json'));json.load(open('$ROOT/sprites/sprites.json'))"

chmod +x "$TARGET"
mkdir -p "$BIN"
ln -sfn "$TARGET" "$BIN/claude-fighter"
echo "installed: $BIN/claude-fighter -> $TARGET"
case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo "note: $BIN is not on your PATH. Add to ~/.zshrc:"; echo "  export PATH=\"$BIN:\$PATH\"" ;;
esac
echo "try:  claude-fighter --demo    (q to quit)"

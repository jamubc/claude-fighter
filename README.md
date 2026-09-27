# claude-fighter

[![Python 3.8+ · stdlib only](https://img.shields.io/badge/python-3.8%2B%20%C2%B7%20stdlib%20only-3776AB?logo=python&logoColor=white)](python/claude-fighter)
[![Made for Claude Code](https://img.shields.io/badge/made%20for-Claude%20Code-D97757)](https://claude.com/claude-code)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Even when your terminal is too small to be used, claude keeps you in the loop.

A wrapper for the [Claude Code](https://claude.com/claude-code) CLI. Shrink the window and the TUI is replaced by a stage: the Claude mascot shadow-boxes numbers from its own output, punches a crate every time a tool finishes, waits when it's your move, and meditates in a forest when the turn is done. Widen the window and Claude Code is back, untouched.

![Claude shadow-boxes numbers, punches a crate until it cracks, waits for your move, then meditates in a forest under a starry sky](docs/demo.gif)

## Install

```sh
./install.sh              # symlinks ~/.local/bin/claude-fighter
```

Python 3.8+, no dependencies. macOS and Linux (uses a PTY).

## Usage

```sh
claude-fighter                    # wraps claude; make the window narrow to activate
claude-fighter --width 60         # activate below 60 columns (default 50)
claude-fighter --demo             # scripted events, no Claude; q to quit
claude-fighter --log /tmp/cf.log  # also append every hook event to a file (off by default)
claude-fighter -- <command>       # wrap something other than claude
```

## How it works

Claude Code runs inside a pseudo-terminal, so its output and your keystrokes pass straight through. State comes from [Claude Code hooks](hooks/) (`PreToolUse`, `PostToolUse`, `Notification`, `Stop`, …), which the wrapper loads for the session via `--settings`. Art lives in [`sprites/sprites.json`](sprites/); the renderer is a single stdlib Python script in [`python/`](python/).

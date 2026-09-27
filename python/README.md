# python renderer

Reference implementation of claude-fighter. Python 3 stdlib only (macOS/Linux).

```sh
./claude-fighter                 # wraps `claude`, loads ../hooks/settings.json automatically
./claude-fighter -- claude -c    # any claude args
./claude-fighter --width 70      # custom threshold (or CLAUDE_FIGHTER_WIDTH)
./claude-fighter --demo          # scripted events, no Claude; q to quit
```

It reads `../sprites/sprites.json` for art and follows `../hooks/README.md` for state, so it
must stay inside this repo layout (symlinking the script elsewhere is fine).

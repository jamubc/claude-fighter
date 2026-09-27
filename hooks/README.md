# hooks — the Claude Code side

This folder is the only thing that touches Claude Code. It has no language: it is a
Claude Code `settings.json` fragment whose every hook runs the same one-line shell command:

```sh
f="${CLAUDE_FIGHTER_STATE:-/dev/null}"; cat >> "$f"; echo >> "$f"
```

Claude Code pipes the hook event as JSON on stdin; the command appends that JSON as one line
to the file named by `CLAUDE_FIGHTER_STATE` (JSON Lines). If the variable is unset, the event is discarded, so
the hooks are harmless outside a fighter session.

## Protocol (what every renderer implements)

1. **Launch** Claude with the hooks loaded and a state file chosen:

   ```sh
   CLAUDE_FIGHTER_STATE=/tmp/cf-1234.json claude --settings /abs/path/hooks/settings.json
   ```

   A renderer (python, lua, rust, node, …) sets the env var to a fresh per-run path and adds
   the `--settings` flag when it spawns `claude`. Nothing is installed into `~/.claude`.

2. **Tail** the state file (every frame is fine). Each complete line is one hook event exactly
   as Claude Code emitted it, oldest first; a renderer keeps its read offset and handles every
   new line, so fast tools (a `Read` that finishes in 30 ms) are not missed. The fields
   renderers rely on:

   | field             | present on           | use                                  |
   |-------------------|----------------------|--------------------------------------|
   | `hook_event_name` | all                  | which state to show (table below)    |
   | `tool_name`       | Pre/PostToolUse      | label for the punch (`Bash`, `Edit`) |
   | `session_id`      | all                  | ignore / debugging                   |

   The last line may be incomplete while `cat` is mid-write; only consume lines that end in
   a newline.

3. **Map** events to fighter states:

   | `hook_event_name`  | state      | meaning                                  |
   |--------------------|------------|------------------------------------------|
   | `SessionStart`     | `idle`     | warming up on stage                      |
   | `UserPromptSubmit` | `fight`    | you gave it work — charge the CWD        |
   | `PreToolUse`       | `fight`    | wind-up; show `tool_name`                |
   | `PostToolUse`      | `fight`    | hit lands; damage the CWD                |
   | `Notification`     | `waiting`  | needs you (permission / idle prompt)     |
   | `PermissionRequest`| `waiting`  | permission dialog is up                  |
   | `SubagentStop`     | `fight`    | a subagent finished; main turn continues |
   | `Stop`             | `peace`    | turn finished — meditate in the forest   |
   | `SessionEnd`       | —          | renderer exits                           |

   Anything else (or no file yet) → `idle`.

The hook list intentionally has no `matcher` filtering and no scripts of its own. Adding a new
state means adding a row to the table above and an entry in `../sprites/sprites.json`; the
settings file should not need to change.

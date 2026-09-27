# sprites — the art, as data

`sprites.json` holds every character pose, scenery piece, text string and color the fighter
shows. It is shared by all renderers; none of them should hard-code glyphs.

- `hero.<pose>` / `scenery.<piece>`: `{ rate, color, frames }`. `frames` is a list of frames,
  each a list of equal-width rows. Renderers show `frames[(tick / rate) % len]`.
- `text`: labels, onomatopoeia for hits, and the `tiny` words per state.
- `scenery`: `crate` (one frame per damage tier), `squash`, `tree`, `tree_far`, `cloud`, `bird`.
- `colors`: SGR parameter strings (`"38;5;209"` → `\e[38;5;209m`). `pops` is a list the fight
  picks a random word colour from; `sky` is a list of 256-colour indices, top of the sky first.
  Terminals only; a GUI renderer would map the names to whatever it likes.

Poses map to the states in `../hooks/README.md`: `idle`, `tiny` (any state, tiny windows), `guard`/`shadowbox`/`jab_left`/`jab_right`/`punch` (fight),
`waiting`, `meditate` (peace). Add a pose here and a row there; renderers pick it up by name.

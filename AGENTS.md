# gamedev-tooling

<!-- >>> git-workflow (generated block; do not edit by hand) -->
## Git workflow

- `main` changes only through a PR, squash-merged.
<!-- <<< git-workflow -->

## Project state

- 2026-10-15: not launched — no release yet. Retires at the first version tag.
- 2026-10-15: the project holds no user data; an agent or skill runs inside the user's own Claude Code session and writes only to their machine and their project. Retires if it ever stores or sends data off the user's machine.

## Rules

- An agent or skill here is guidance for an agent: the goal and what to find out, never a fixed question list or a required reply shape.
- A skill preloaded by an agent is named bare (`unity-cli` from Unity's plugin, `unity-editor-ops` from this one); an unresolved name is skipped silently, so the agent body also says to load it through the Skill tool.
- Every command in `README.md` and `docs/setup.md` was run on a real machine before it was merged; a version named there is the one it ran against, with the date in the commit. `[convention]`
- Nothing here names a path, host or tool from one person's machine; a public reader must be able to follow every line.

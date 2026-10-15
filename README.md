# gamedev-agents

<p align="center"><strong>Claude Code agents and skills for game development with Unity and Blender.</strong></p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/github/license/federbenjamin/gamedev-agents" alt="License"></a>
</p>

gamedev-agents is a plugin for [Claude Code](https://code.claude.com). It adds an agent that changes and verifies a Unity project through a running editor, the operating discipline that keeps an agent-driven editor from stalling, and a skill for Blender props that import into Unity at rotation 0, scale 1. It is for anyone who builds a game with Claude Code and wants the agent to work inside the real editor, with measured results, instead of guessing from source files.

## Install

Needs [Claude Code](https://code.claude.com) with plugins, and the Unity CLI with a Unity editor for the Unity agent; [docs/setup.md](docs/setup.md) walks through the whole toolchain, Blender included. One command adds the marketplace and installs the plugin:

```
claude plugin install gamedev-agents --marketplace federbenjamin/gamedev-agents
```

## Features

- **`unity-operator` agent.** Edits scripts, scenes, prefabs and settings, recompiles, runs the test suites, and rides play mode, all through the Unity CLI against a running editor. It reports measured numbers with their source and leaves the editor as it found it.
- **`unity-editor-ops` skill.** The discipline around the Unity CLI: reaching the right editor, changing through the editor's own commands, the play-mode loop that proves frames advance before a number is trusted, tests with the result file as the truth, and the failure modes that stall an agent-driven editor.
- **`blender-to-unity-props` skill.** Models props in Blender, by script or through a Blender MCP bridge, and exports FBX files that land in Unity at rotation 0, scale 1, true size, front toward +Z, with a notes file the importing agent reads.

## Usage

Spawn the agent from a session on a Unity project whose editor is open or can be opened:

```
Agent subagent_type=gamedev-agents:unity-operator
  prompt: "Ride the Classic slide with forward input held and report peak speed,
           time to the run-out, and whether the player walks again within 3 s."
```

It answers in under 40 lines: what changed, what the editor showed, what failed, and the editor's state at hand-back. The skills load on their own when a task matches their description; `/gamedev-agents:blender-to-unity-props` runs the Blender skill by hand. Each agent's and skill's full instructions are its file under `agents/` or `skills/`.

## How it works

The agent never drives Unity through hand-edited scene files or a chat relay. It calls the `unity` command line tool, which finds the editor that has the project open and talks to the project's `com.unity.pipeline` package: about 160 commands for scenes, assets, play mode, tests, recompiles, screenshots and arbitrary C#, with JSON results, detached jobs for long work, and a wait on the frame counter that proves a play-mode run is really advancing. Blender work runs headless by default, so a modelling script re-runs after any fix; an MCP bridge is the route when the agent owns a Blender window.

## Contributing

Report a problem in [issues](https://github.com/federbenjamin/gamedev-agents/issues). PRs are welcome; see [CONTRIBUTING](https://github.com/federbenjamin/.github/blob/main/CONTRIBUTING.md) and [SECURITY](https://github.com/federbenjamin/.github/blob/main/SECURITY.md). There is no test suite: a change to an agent or skill is checked by running it against a real project and editor.

## License

MIT © Benjamin Feder

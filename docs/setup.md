# Toolchain setup

Everything the agents and skills in this plugin need on one machine, in the order to install it. Commands are for macOS; the Unity CLI prints the Windows and Linux forms in its own help. Versions named here are the ones this plugin was last run against.

## Claude Code and this plugin

```
claude plugin install gamedev-tooling --marketplace federbenjamin/gamedev-tooling
```

A plugin installed from a terminal loads in the next Claude Code session; inside an open session, `/reload-plugins` loads it now.

## Unity CLI

The command line tool that installs editors, opens projects and drives a running editor. Everything the `unity-operator` agent does goes through it.

```
curl -fsSL https://unity.com/install.sh | bash
```

Open a new shell, then check it:

```
unity --version
unity doctor
```

Sign in once with `unity auth login`; editor installs and licences need the account.

## Unity Hub and an editor

The Hub is what the editor installer and the licence client expect to find. The CLI installs both:

```
unity hub install
unity install 6000.6.4f1 --accept-eula --yes
```

Add build support for your targets with `--module`; `unity install 6000.6.4f1 --list-modules` prints the ids (for example `mac-il2cpp`). The editor lands under the Hub's install path, which `unity install-path` shows.

## The Pipeline package, per project

The editor-side half of the CLI. Add it to each project once; commit `Packages/manifest.json` so every clone and worktree exposes the command surface from its first open:

```
unity pipeline install --project-path <absolute path to the project>
unity open <absolute path to the project>
unity status --until-ready --project-path <absolute path to the project>
```

`status` reports `ready` when the editor can take commands; `unity command --project-path <path>` lists them.

## Two worktree slots, per project

An agent's branch gets its own worktree and its own editor, so the checkout you play in stays on your branch. Two slots beside the checkout keep their `Library` warm between branches; make each once, with its first import, then close the editor. The `unity-editor-ops` skill carries the take and release steps.

```
git worktree add --detach <checkout>-slot-1 main
unity open <absolute path to the slot>
unity status --until-ready --project-path <absolute path to the slot>
unity close <absolute path to the slot>
```

For `<checkout>-slot-2`, make the worktree the same way, then with slot 1's editor closed copy its `Library` across (`cp -c -R <slot-1>/Library <slot-2>/Library`, an APFS clone) before the first open, so the second slot skips the import. Free slots sit at a detached HEAD; `git worktree list` shows which are taken.

## Unity's own Claude Code plugin

Unity ships a plugin that carries the `unity-cli` skill, the reference for every command and flag, plus skills for common engine tasks. The `unity-operator` agent preloads `unity-cli` from it:

```
unity setup claude
```

Do not also run `unity skill install claude-code`; Claude Code would load the skill twice.

## Unity MCP: not needed

With the Pipeline package and the CLI in place, an agent drives the editor from the shell and gets JSON back, so no MCP server sits between them. The CLI still offers one (`unity mcp` starts a stdio server; `unity mcp configure --list` names the clients it can register) for a client that wants editor tools as tool calls. For Claude Code the manual form is:

```
claude mcp add unity -- unity mcp --project-path <absolute path to the project>
```

This plugin's agent does not use it.

## Blender

The `blender-to-unity-props` skill runs Blender headless from its script template, so a model rebuilds after any fix without a window:

```
brew install --cask blender
```

The skill calls the binary at `/Applications/Blender.app/Contents/MacOS/Blender` with `-b --factory-startup --python <script>`. Last run against Blender 5.2.2 LTS, with the import measured in Unity 6000.6.4f1.

## Blender MCP: optional

Only for a live modelling session where the agent owns the Blender window; the headless route needs none of this. The community project [mcp-for-blender](https://github.com/ahujasid/blender-mcp) needs Blender 3.0 or newer, Python 3.10 or newer, and `uv`:

```
brew install uv
uvx mcp-for-blender install-addon
claude mcp add blender uvx mcp-for-blender
```

In Blender, enable the add-on under Edit > Preferences > Add-ons ("Interface: MCP for Blender"), then in the 3D viewport's sidebar (N) open the MCP for Blender tab and start the server. A second agent loading a `.blend` into that bridge replaces the scene in the window, which is why the skill defaults to headless.

## Image tools: for concept art

The `prop-concept-art` skill draws with either tool; one is enough.

**Codex CLI**, installed and signed in per [its docs](https://developers.openai.com/codex/cli). Image generation is built in and on by default; last run against `codex-cli` 0.163.0. Check:

```
codex features list
```

`image_generation` should read `stable true`.

**Gemini CLI** with the Nano Banana extension, last run against Gemini CLI 0.65.0 and the extension 1.0.12. The `--allow-scripts` flag lets npm build the two native modules it would otherwise skip, for keychain storage and the interactive shell:

```
npm install -g --allow-scripts=@github/keytar,node-pty @google/gemini-cli
gemini extensions install https://github.com/gemini-cli-extensions/nanobanana --consent --skip-settings
gemini extensions config nanobanana
```

The last command asks for a Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey). Image models need billing on the key's project: a free-tier key returns `429 RESOURCE_EXHAUSTED`. Run `gemini` once in a terminal and pick **Use Gemini API Key**: Google sign-in for personal accounts no longer serves Gemini CLI.

## Check

A machine is ready when these print without an error:

```
claude plugin list
unity doctor
unity status --until-ready --project-path <absolute path to a project with the Pipeline package>
/Applications/Blender.app/Contents/MacOS/Blender --version
codex --version
```

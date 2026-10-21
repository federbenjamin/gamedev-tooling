---
name: prop-concept-art
argument-hint: "[asset to draw]"
description: Generate concept art for a game prop or character with an image model (Codex's built-in image generation, or Gemini CLI's Nano Banana extension), held to the project's art style, as the reference a Blender modeller builds from. Use when asked to generate, draw or iterate an image of a prop, a character or a pose for the game, or a variant of an approved image.
---

# prop-concept-art

Goal: one approved image per asset that a modeller can build from. It shows the whole object on a plain background, its silhouette and parts readable, in the project's art style. Each image is a draft until the person approves it; the approved one goes into the modeller's brief.

## Find out first

- **The project's art style.** Look in its `AGENTS.md` and rules docs for a style section: a style anchor image (an approved image every new asset is drawn to match), the prompt wording that produced it, the view, the palette, and where approved images are kept. With no style section, the first approved image becomes the anchor; record it and its prompt in the project as its style section.
- **The asset's parts.** Which parts the game moves separately (an arm that waves, blades that spin) and what size the asset must fit. An image gives shape, proportion and colour; size comes from the project (a measured rig, the park's scale), and the modeller's brief carries both.
- **Which image tool is ready.** Codex is the default; Gemini needs a paid key (below).

## Generate

Run every generation from a scratch folder outside the project, so drafts never land in the repo.

**Codex** (`codex-cli` 0.163.0, 2026-10-21): built-in image generation, on by default (`codex features list` shows `image_generation`). It counts against the person's Codex plan, about 20 to 26 thousand tokens and one to two minutes per image.

```
codex exec --skip-git-repo-check -s workspace-write "<prompt> Save it as <name>.png in the current directory, then print its absolute path." -i <anchor.png>
```

- The prompt comes before `-i`: `-i` takes several files and swallows any argument after it.
- Codex writes under its own home folder as it runs, so a sandboxed shell blocks it; run the command outside the sandbox.
- Codex keeps every original under `~/.codex/generated_images/`; the prompt's save path is the copy you work with.

**Gemini CLI with Nano Banana** (Gemini CLI 0.65.0, extension 1.0.12, 2026-10-21): `/generate`, `/edit` and `/pattern` (seamless textures). It needs a Gemini API key with billing on: a free-tier key returns `429 RESOURCE_EXHAUSTED` for the image model. Headless:

```
gemini --skip-trust --approval-mode yolo -p "Use the nanobanana generate_image tool to make one image: <prompt>"
```

Images land in `./nanobanana-output/`.

## Write the prompt

- Name the subject as a **game prop** (or game character) and the view: front three-quarter, plain white background, the whole object in frame.
- Name every part the brief needs to see, each as a separate visible piece; a part the game moves separately must read as its own shape.
- Carry the project's style words verbatim from its style section. Away from a flat low-poly style, say **3D game asset render, not a photograph**: material words such as worn leather, stitching or studio lighting pull the model toward product photography.
- Attach the style anchor with `-i` and say what to keep from it ("keeps exactly this style: the same faceted polygons, the same colours").

## Iterate

- **One change per round.** Attach the previous image with `-i` and name only the change. A variant (the same character in a new pose) attaches the base image and names the pose.
- An attached image holds its shape as well as its style, so a shape change named in the prompt can barely move. Compare the new image against the old one for each change you asked for, and say which ones did not land.
- Look at every image yourself before showing it, then show it to the person; they pick. A rejection names what is wrong; ask what they want instead before another round.

## Hand off

- The approved image's path goes into the modeller's brief (the `blender-to-unity-props` skill, or the project's modelling agent), with the parts that must be separate objects, the sizes from the project, and anything in the image the style cannot hold: a flat-colour low-poly model drops fine texture, stitching and grain.
- An approved image that becomes the style anchor, or that a committed model was built from, is kept where the project's style section says.

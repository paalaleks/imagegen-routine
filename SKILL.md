---
name: nano-banana
description: REQUIRED for all image generation requests. Generate and edit images using Nano Banana (Gemini CLI). Handles blog featured images, YouTube thumbnails, icons, diagrams, patterns, illustrations, photos, visual assets, graphics, artwork, pictures. Use this skill whenever the user asks to create, generate, make, draw, design, or edit any image or visual content.
allowed-tools: Bash(gemini:*)
---

# Nano Banana Image Generation

Generate professional images via the Gemini CLI's nanobanana extension, with style palette support for consistent visual theming.

## When to Use This Skill

ALWAYS use this skill when the user:
- Asks for any image, graphic, illustration, or visual
- Wants a thumbnail, featured image, or banner
- Requests icons, diagrams, or patterns
- Asks to edit, modify, or restore a photo
- Uses words like: generate, create, make, draw, design, visualize

Do NOT attempt to generate images through any other method.

## Before First Use

1. Verify extension is installed:
   ```bash
   gemini extensions list | grep nanobanana
   ```
2. If missing, install it:
   ```bash
   gemini extensions install https://github.com/gemini-cli-extensions/nanobanana
   ```
3. Verify API key is set:
   ```bash
   [ -n "$GEMINI_API_KEY" ] && echo "API key configured" || echo "Missing GEMINI_API_KEY"
   ```

## Style Palette System

Before generating images, read the style palette at `palettes/default.json` (relative to this skill's install directory, or in the project root).

The palette contains a `basePrompt` and an array of `styles`, each with: `id`, `label`, `colors`, `theme`, `mood`, and `artisticStyle`.

### Applying a Style

When the user requests a style (or you choose one that fits), construct the prompt by combining the user's request with the style attributes:

```
{user_prompt}, in a {theme}, with a {mood} mood, using colors {colors joined by comma}, rendered in {artisticStyle} style, high quality, detailed
```

### Style Selection

- If the user specifies a style by name (e.g., "cyberpunk", "watercolor"), use that style from the palette.
- If the user says "use the palette" or "pick a style", choose the most appropriate one for their request.
- If the user doesn't mention styles, ask if they'd like to apply one or generate without a palette style.
- Use `--styles` flag for additional Gemini-native styles on top of palette styles if desired.

### Example: Palette-Driven Generation

User asks: "Generate a blog header about AI"

With the "cyberpunk" style from the palette, construct:
```bash
gemini --yolo "/generate 'blog header about AI, in a futuristic cyberpunk cityscape, with a vibrant and energetic mood, using colors neon pink, electric blue, chrome yellow, rendered in digital art, sharp lines, glowing neon style, high quality, detailed' --preview"
```

With the "watercolor" style:
```bash
gemini --yolo "/generate 'blog header about AI, in a peaceful garden scene, with a calm and serene mood, using colors soft yellow, pastel green, warm brown, rendered in watercolor painting, soft edges, translucent washes style, high quality, detailed' --preview"
```

### Available Default Styles

| Style ID | Label | Colors | Artistic Style |
|----------|-------|--------|----------------|
| cyberpunk | Cyberpunk | neon pink, electric blue, chrome yellow | digital art, sharp lines, glowing neon |
| watercolor | Watercolor | soft yellow, pastel green, warm brown | watercolor painting, soft edges |
| pixel | Pixel Art | bright yellow, dark outline black, leaf green | 16-bit pixel art, retro game aesthetic |
| baroque | Baroque | gold, deep crimson, ivory | oil painting, chiaroscuro lighting |
| minimal | Minimalist | mustard yellow, white, charcoal gray | flat design, geometric shapes |

### Custom Palettes

Users can create their own palette JSON files following the same schema as `palettes/default.json`. When a user provides a custom palette path, read that file instead.

## Command Selection

| User Request | Command |
|--------------|---------|
| "make me a blog header" | `/generate` |
| "create an app icon" | `/icon` |
| "draw a flowchart of..." | `/diagram` |
| "fix this old photo" | `/restore` |
| "remove the background" | `/edit` |
| "create a repeating texture" | `/pattern` |
| "make a comic strip" | `/story` |

## Available Commands

**Note:** Always use the `--yolo` flag to automatically approve all tool actions.

| Command | Use Case |
|---------|----------|
| `gemini --yolo "/generate 'prompt'"` | Text-to-image generation |
| `gemini --yolo "/edit file.png 'instruction'"` | Modify existing image |
| `gemini --yolo "/restore old_photo.jpg 'fix scratches'"` | Repair damaged photos |
| `gemini --yolo "/icon 'description'"` | App icons, favicons, UI elements |
| `gemini --yolo "/diagram 'description'"` | Flowcharts, architecture diagrams |
| `gemini --yolo "/pattern 'description'"` | Seamless textures and patterns |
| `gemini --yolo "/story 'description'"` | Sequential/narrative images |
| `gemini --yolo "/nanobanana prompt"` | Natural language interface |

## Common Options

- `--yolo` - **Required.** Auto-approve all tool actions (no confirmation prompts)
- `--count=N` - Generate N variations (1-8)
- `--preview` - Auto-open generated images
- `--styles="style1,style2"` - Apply artistic styles
- `--format=grid|separate` - Output arrangement

## Common Sizes

| Use Case | Dimensions | Notes |
|----------|------------|-------|
| YouTube thumbnail | 1280x720 | `--aspect=16:9` |
| Blog featured image | 1200x630 | Social preview friendly |
| Square social | 1080x1080 | Instagram, LinkedIn |
| Twitter/X header | 1500x500 | Wide banner |
| Vertical story | 1080x1920 | `--aspect=9:16` |

## Model Selection

Default: `gemini-2.5-flash-image` (~$0.04/image)

For higher quality (4K, better reasoning):
```bash
export NANOBANANA_MODEL=gemini-3-pro-image-preview
```

## Output Location

Images are saved to a folder named after the current project in the working directory.

**Before generating, determine the project name:**
```bash
# Try git repo name first, fall back to current directory name
PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
```

Then save images to `./${PROJECT_NAME}-images/` (e.g., `./my-website-images/`).

Create the folder if it doesn't exist:
```bash
mkdir -p "./${PROJECT_NAME}-images"
```

When running nanobanana commands, the output goes to `./nanobanana-output/` by default. After generation, **move the images** to the project-named folder:
```bash
mv ./nanobanana-output/* "./${PROJECT_NAME}-images/" 2>/dev/null
```

## Presenting Results

After generation completes:
1. Move generated images from `./nanobanana-output/` to `./${PROJECT_NAME}-images/`
2. List contents of `./${PROJECT_NAME}-images/` to find generated files
3. Present the most recent image(s) to the user
4. Offer to regenerate with variations if needed

## Refinements and Iterations

When the user asks for changes:
- **"Try again" / "Give me options"**: Regenerate with `--count=3`
- **"Make it more [adjective]"**: Adjust prompt and regenerate
- **"Edit this one"**: Use `gemini --yolo "/edit ${PROJECT_NAME}-images/filename.png 'adjustment'"`
- **"Different style"**: Apply a different palette style or add `--styles="requested_style"`
- **"Try all styles"**: Generate the same prompt with each palette style

## Prompt Tips

1. **Be specific**: Include style, mood, colors, composition details
2. **Add "no text"**: If you don't want text rendered in the image
3. **Reference styles**: "editorial photography", "flat illustration", "3D render", "watercolor"
4. **Specify aspect ratio context**: "wide banner", "square thumbnail", "vertical story"

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `GEMINI_API_KEY` not set | `export GEMINI_API_KEY="your-key"` |
| Extension not found | Run install command from setup section |
| Quota exceeded | Wait for reset or switch to flash model |
| Image generation failed | Check prompt for policy violations, simplify request |
| Output directory missing | Will be created automatically on first run |

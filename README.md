# Nano Banana Image Generator

A Claude Code skill for generating and editing images using the Gemini CLI's nanobanana extension, with a **style palette system** for consistent visual theming.

Built around [cc-nano-banana](https://github.com/kkoppenhaver/cc-nano-banana).

## Features

- **Text-to-image generation** with style palette support
- **Image editing** — modify existing images with instructions
- **Photo restoration** — repair damaged or old photos
- **Icon generation** — create app icons and favicons
- **Diagram creation** — generate flowcharts and architecture diagrams
- **Pattern generation** — create seamless textures and patterns
- **Story/sequential images** — generate narrative image sequences
- **Style palette** — 5 built-in styles, or create your own

## Prerequisites

1. [Node.js](https://nodejs.org/) (v18+)
2. [Gemini API Key](https://aistudio.google.com/) from Google AI Studio

## Quick Setup

```bash
git clone <this-repo>
cd imagegen-routine
bash setup.sh
```

Or manually:

```bash
# Install Gemini CLI
npm install -g @google/gemini-cli

# Set your API key
export GEMINI_API_KEY="your-key"

# Install the nanobanana extension
gemini extensions install https://github.com/gemini-cli-extensions/nanobanana

# Install the Claude Code skill
mkdir -p ~/.claude/skills/nano-banana
cp SKILL.md ~/.claude/skills/nano-banana/
cp -r palettes ~/.claude/skills/nano-banana/
```

## Style Palette

The style palette (`palettes/default.json`) defines visual themes that get injected into image generation prompts. Each style includes colors, theme, mood, and artistic direction.

### Built-in Styles

| Style | Colors | Look |
|-------|--------|------|
| **Cyberpunk** | neon pink, electric blue, chrome yellow | Digital art with glowing neon |
| **Watercolor** | soft yellow, pastel green, warm brown | Soft watercolor painting |
| **Pixel Art** | bright yellow, black, leaf green | 16-bit retro game aesthetic |
| **Baroque** | gold, deep crimson, ivory | Oil painting with chiaroscuro |
| **Minimalist** | mustard yellow, white, charcoal gray | Flat geometric design |

### Custom Palettes

Create your own palette JSON following the same schema:

```json
{
  "name": "my-palette",
  "description": "My custom style palette",
  "basePrompt": "A tiny nano-sized banana",
  "styles": [
    {
      "id": "my-style",
      "label": "My Style",
      "colors": ["red", "blue", "green"],
      "theme": "abstract landscape",
      "mood": "dreamy",
      "artisticStyle": "impressionist painting"
    }
  ]
}
```

## Usage

Once the skill is installed, Claude Code automatically uses it for image requests:

- "Generate a cyberpunk blog header about AI"
- "Create a watercolor illustration of a sunset"
- "Make a pixel art game asset"
- "Draw a flowchart showing user auth flow"
- "Create an app icon in the baroque style"

## Output

Images are saved to a folder named after your project. The skill auto-detects the project name from the git repo or current directory name.

For example, if you're working in `my-website`, images save to `./my-website-images/`.

## Model Selection

Default: `gemini-2.5-flash-image` (~$0.04/image)

For higher quality:
```bash
export NANOBANANA_MODEL=gemini-3-pro-image-preview
```

## License

MIT

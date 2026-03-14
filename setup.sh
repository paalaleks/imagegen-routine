#!/bin/bash
set -e

echo "=== Nano Banana Image Generator Setup ==="
echo ""

# 1. Check for Node.js
if ! command -v node &> /dev/null; then
  echo "Error: Node.js is required. Install it from https://nodejs.org/"
  exit 1
fi

echo "[1/4] Installing Gemini CLI..."
npm install -g @google/gemini-cli

# 2. Check API key
echo ""
echo "[2/4] Checking API key..."
if [ -z "$GEMINI_API_KEY" ] && [ -z "$NANOBANANA_GEMINI_API_KEY" ]; then
  echo "WARNING: No API key found."
  echo "Set one of these environment variables:"
  echo "  export GEMINI_API_KEY=\"your-key-from-aistudio.google.com\""
  echo "  export NANOBANANA_GEMINI_API_KEY=\"your-key\""
  echo ""
else
  echo "API key configured."
fi

# 3. Install nanobanana extension
echo "[3/4] Installing nanobanana extension..."
gemini extensions install https://github.com/gemini-cli-extensions/nanobanana

# 4. Install Claude Code skill
echo "[4/4] Installing Claude Code skill..."
SKILL_DIR="$HOME/.claude/skills/nano-banana"
mkdir -p "$SKILL_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/"
cp -r "$SCRIPT_DIR/palettes" "$SKILL_DIR/"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Usage:"
echo "  In Claude Code, ask to generate images. Examples:"
echo "    'Generate a cyberpunk blog header about AI'"
echo "    'Create a watercolor illustration of a sunset'"
echo "    'Make a pixel art game asset'"
echo ""
echo "Images will be saved to ./nanobanana-output/ in your current directory."

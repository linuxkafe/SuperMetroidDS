#!/bin/bash
# SuperMetroidDS — Docker Build Script
# Follows the pattern from nds-the-great-escape (linuxkafe)
# Uses devkitpro/devkitarm official image

set -euo pipefail

echo "🚀 Building SuperMetroidDS (Nintendo DS Port)..."

# Ensure we're in the project root
cd "$(dirname "$0")"

# Run build in devkitARM container
# Mount current directory as /source, set working dir, run make
docker run --rm \
  -v "$(pwd):/source" \
  -w /source \
  devkitpro/devkitarm \
  bash -c "make"

echo "✅ Build complete. Output in build/"
ls -la build/*.nds build/*.elf 2>/dev/null || echo "No .nds/.elf found (check build output above)"
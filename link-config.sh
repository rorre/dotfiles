#!/bin/bash

# Symlink individual files/directories from dotfiles/.config to ~/.config
# Ensures existing ~/.config is preserved while linking individual items
# Usage: ./link-config.sh [--dry-run]

DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      echo "🔍 Dry run - No changes will be made"
      echo ""
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run]"
      exit 1
      ;;
  esac
  shift
done

CONFIG_DIR="$(dirname "$(readlink -f "$0")")/.config"
HOME_CONFIG="$HOME/.config"

for item in "$CONFIG_DIR"/*; do
  item=$(basename "$item")
  src="$CONFIG_DIR/$item"
  dst="$HOME_CONFIG/$item"
  
  if [ "$DRY_RUN" = true ]; then
    echo "ln -s '$src' '$dst'"
  else
    ln -s "$src" "$dst"
  fi
done

echo "Done!"

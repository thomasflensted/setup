#!/bin/sh
# Copies the config files in this repo to where they belong. Overwrites existing files.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)

cp "$repo/.zshrc" "$repo/.gitconfig" "$HOME/"
mkdir -p "$HOME/.claude"
cp -R "$repo/claude/." "$HOME/.claude/"

echo "Copied .zshrc, .gitconfig and Claude config. Open a new terminal to load .zshrc."

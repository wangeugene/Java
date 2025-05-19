#!/bin/bash

# Install fswatch if not already installed
# brew install fswatch

# Watch the Projects/Java/.zshrc file and automatically sync when it changes
echo "Watching ~/Projects/Java/.zshrc for changes..."
fswatch -o ~/Projects/Java/.zshrc | while read f; do
  echo "🔄 zshrc file changed, syncing..."
  cp -v ~/Projects/Java/.zshrc ~/.zshrc && echo "✅ .zshrc copied to home directory" || echo "❌ Error syncing .zshrc"
  # Note: We don't run 'source ~/.zshrc' here because this script runs in a separate shell
  echo "Run 'source ~/.zshrc' in your terminal to apply changes"
done

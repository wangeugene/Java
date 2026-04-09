#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="/Users/euwang/Projects/Java/macOS/TeslaCamViewer/TeslaCamViewer"
PROTO_DIR="$PROJECT_ROOT/ThirdParty/TeslaDashcam"
OUT_DIR="$PROJECT_ROOT/Generated/Proto"

mkdir -p "$OUT_DIR"

protoc \
  --proto_path="$PROTO_DIR" \
  --swift_out="$OUT_DIR" \
  --swift_opt=Visibility=Public \
  "$PROTO_DIR/dashcam.proto"
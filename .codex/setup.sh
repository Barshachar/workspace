#!/usr/bin/env bash
set -euo pipefail

# ---------- install Flutter -------------------------------------------------
FLUTTER_VERSION=3.22.0
if ! command -v flutter &>/dev/null; then
  curl -sL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o flutter.tar.xz
  tar xf flutter.tar.xz
  export PATH="$PWD/flutter/bin:$PATH"
  echo 'export PATH="$PWD/flutter/bin:$PATH"' >> ~/.bashrc
fi
flutter --version

# ---------- node & supabase CLI --------------------------------------------
npm install -g supabase@1.140.8

# ---------- jest for Edge-Function tests -----------------------------------
npm install -g jest

echo "✅  Setup finished"

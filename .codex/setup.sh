#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION=3.22.0   # עדכן אם רוצים גרסה אחרת

install_flutter_linux() {
  curl -sL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o flutter.tar.xz
  tar xf flutter.tar.xz
  export PATH="$PWD/flutter/bin:$PATH"
  echo 'export PATH="$PWD/flutter/bin:$PATH"' >> "${HOME}/.bashrc"
}

install_flutter_macos() {
  # אם יש Homebrew – זו הדרך הפשוטה
  if command -v brew &>/dev/null; then
    brew install --cask flutter
  else
    curl -sL \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${FLUTTER_VERSION}-stable.zip" \
      -o flutter.zip
    unzip -q flutter.zip
    export PATH="$PWD/flutter/bin:$PATH"
    echo 'export PATH="$PWD/flutter/bin:$PATH"' >> "${HOME}/.zshrc"
  fi
}

if ! command -v flutter &>/dev/null; then
  case "$(uname -s)" in
    Linux*)   install_flutter_linux ;;
    Darwin*)  install_flutter_macos ;;
    *)        echo "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
fi

flutter --version

# ---------- node & supabase CLI --------------------------------------------
npm install -g supabase@1.140.8

# ---------- jest for Edge-Function tests -----------------------------------
npm install -g jest

echo "✅  Setup finished"

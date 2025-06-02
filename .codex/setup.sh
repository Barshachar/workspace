#!/usr/bin/env bash
set -euo pipefail

################################################################################
#  ⚙️  Flutter – cross-platform install
################################################################################
FLUTTER_VERSION=3.22.0   # עדכן כאן אם תרצה גרסה אחרת

install_flutter_linux() {
  curl -sL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o flutter.tar.xz
  tar xf flutter.tar.xz
  export PATH="$PWD/flutter/bin:$PATH"
  echo 'export PATH="$PATH:'"$PWD"'/flutter/bin"' >> "${HOME}/.bashrc"
}

install_flutter_macos() {
  if command -v brew &>/dev/null; then          # Homebrew – הדרך הקלה
    brew install --cask flutter
  else                                          # ללא Brew – ZIP ידני
    curl -sL \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${FLUTTER_VERSION}-stable.zip" \
      -o flutter.zip
    unzip -q flutter.zip
    export PATH="$PWD/flutter/bin:$PATH"
    echo 'export PATH="$PATH:'"$PWD"'/flutter/bin"' >> "${HOME}/.zshrc"
  fi
}

if ! command -v flutter &>/dev/null; then
  case "$(uname -s)" in
    Linux*)  install_flutter_linux  ;;
    Darwin*) install_flutter_macos ;;
    *)       echo "❌ Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
fi

flutter --version
flutter doctor -v

################################################################################
#  🟢  Node + Supabase CLI  (ללא הצמדת גרסה כדי שלא יישבר בעתיד)
################################################################################
if ! command -v node &>/dev/null; then
  echo "👉 Installing Node via Homebrew…"
  # על Linux אפשר apt/yum לפי ההפצה
  brew install node
fi

if [[ "$(uname -s)" == "Darwin" ]] && command -v brew &>/dev/null; then
  brew install supabase/tap/supabase   # always installs latest
else
  npm install -g supabase             # ללא ‎@version
fi

################################################################################
#  🧪  Jest (Edge-Function unit tests)
################################################################################
npm install -g jest

echo "✅  Setup finished – happy coding!"

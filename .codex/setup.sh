#!/usr/bin/env bash
set -e
FLUTTER_VERSION="3.22.0"

# הורדת Flutter
curl -sSL \
  https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
  | tar -xJC /opt

# הוספה ל-PATH
echo 'export PATH=\"/opt/flutter/bin:$PATH\"' >> \"$HOME/.bashrc\"

# חימום קבצים (כל עוד יש אינטרנט)
/opt/flutter/bin/flutter --version
/opt/flutter/bin/flutter precache --web

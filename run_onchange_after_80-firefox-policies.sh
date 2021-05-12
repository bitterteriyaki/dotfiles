#!/bin/sh

# Install Firefox policies

POLICY_DIR="/usr/lib/firefox/distribution"

sudo mkdir -p "$POLICY_DIR"
sudo tee "$POLICY_DIR/policies.json" > /dev/null << 'EOF'
{
  "policies": {
    "SkipTermsOfUse": true,
    "DisableTelemetry": true,
    "DisableProfileImport": true,
    "OfferToSaveLogins": false,
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi"
      ]
    },
    "Homepage": {
      "StartPage": "previous-session"
    },
    "PictureInPicture": {
      "Enabled": false
    }
  }
}
EOF

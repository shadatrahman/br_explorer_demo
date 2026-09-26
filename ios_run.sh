#!/usr/bin/env bash
# Build, install, and launch BR Explorer on an iOS Simulator.
#
# Usage:
#   ./ios_run.sh                      # uses default device (see DEVICE below)
#   ./ios_run.sh "iPhone 16"          # pick a different simulator by name
#   ./ios_run.sh "iPhone 16" --log    # also stream the app's console log
#
set -euo pipefail

DEVICE="${1:-iPhone 17 Pro Max}"
STREAM_LOG=false
[[ "${2:-}" == "--log" ]] && STREAM_LOG=true

cd "$(dirname "$0")/iosApp"

BUNDLE_ID="com.brexplorer.app"
SCHEME="iosApp"
PROJECT="iosApp.xcodeproj"

echo "==> Looking up simulator: $DEVICE"
UDID=$(xcrun simctl list devices available -j \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)['devices']
name = '$DEVICE'
for runtime, devices in data.items():
    for d in devices:
        if d['name'] == name:
            print(d['udid'])
            sys.exit(0)
sys.exit(1)
") || { echo "Simulator '$DEVICE' not found. List available with: xcrun simctl list devices available"; exit 1; }

echo "==> Booting simulator ($UDID) if needed"
STATE=$(xcrun simctl list devices -j | python3 -c "
import json, sys
data = json.load(sys.stdin)['devices']
for runtime, devices in data.items():
    for d in devices:
        if d['udid'] == '$UDID':
            print(d['state'])
")
if [[ "$STATE" != "Booted" ]]; then
  xcrun simctl boot "$UDID"
fi
open -a Simulator --args -CurrentDeviceUDID "$UDID"

echo "==> Building ($SCHEME for $DEVICE)"
xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$UDID" \
  -skipMacroValidation build \
  | xcbeautify 2>/dev/null || \
xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
  -destination "platform=iOS Simulator,id=$UDID" \
  -skipMacroValidation build

APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -maxdepth 6 -iname "${SCHEME}.app" -path "*Debug-iphonesimulator*" -print -quit)
if [[ -z "$APP_PATH" ]]; then
  echo "Could not locate built .app in DerivedData"
  exit 1
fi

echo "==> Installing $APP_PATH"
xcrun simctl install "$UDID" "$APP_PATH"

echo "==> Terminating any running instance"
xcrun simctl terminate "$UDID" "$BUNDLE_ID" >/dev/null 2>&1 || true

echo "==> Launching $BUNDLE_ID"
xcrun simctl launch "$UDID" "$BUNDLE_ID"

if $STREAM_LOG; then
  echo "==> Streaming logs (Ctrl-C to stop)"
  xcrun simctl spawn "$UDID" log stream --level debug --predicate 'process == "iosApp"'
fi

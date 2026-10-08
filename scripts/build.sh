#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
APP="$PWD/build/Recent Screenshots.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" build/module-cache
xcrun swiftc -swift-version 5 -O -target "$(uname -m)-apple-macosx14.0" -module-cache-path "$PWD/build/module-cache" Sources/main.swift Sources/Previews.swift -o "$APP/Contents/MacOS/RecentScreenshots"
ICONSET="$PWD/build/RecentScreenshots.iconset"
mkdir -p "$ICONSET"
for size in 16 32 128 256 512; do
    sips -z "$size" "$size" assets/app-icon.png --out "$ICONSET/icon_${size}x${size}.png" >/dev/null
    double=$((size * 2))
    sips -z "$double" "$double" assets/app-icon.png --out "$ICONSET/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/RecentScreenshots.icns"
cp THIRD_PARTY_NOTICES.md "$APP/Contents/Resources/THIRD_PARTY_NOTICES.md"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>local.recent-screenshots</string>
<key>CFBundleName</key><string>Recent Screenshots</string>
<key>CFBundleExecutable</key><string>RecentScreenshots</string>
<key>CFBundleIconFile</key><string>RecentScreenshots.icns</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>0.6.0</string>
<key>CFBundleVersion</key><string>8</string>
<key>LSUIElement</key><true/>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>NSDesktopFolderUsageDescription</key><string>Show your latest saved screenshots so you can open or copy them.</string>
<key>NSDocumentsFolderUsageDescription</key><string>Read images from the screenshot folder you choose.</string>
<key>NSDownloadsFolderUsageDescription</key><string>Read images from the screenshot folder you choose.</string>
</dict></plist>
PLIST
codesign --force --sign - "$APP"
echo "$APP"

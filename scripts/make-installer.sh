#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
bash scripts/build.sh
STAGE="$(mktemp -d "$PWD/build/pkg-stage.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/root" "$STAGE/scripts"
ditto "build/Recent Screenshots.app" "$STAGE/root/Recent Screenshots.app"
cat > "$STAGE/scripts/preinstall" <<'SCRIPT'
#!/bin/bash
# Stop this app for the active console user before replacing its bundle.
# Screenshot history and preferences live outside the payload and are retained.
console_uid="$(/usr/bin/stat -f '%u' /dev/console)"
if [ "$console_uid" -ge 501 ]; then
    /usr/bin/pkill -u "$console_uid" -x RecentScreenshots || true
fi
exit 0
SCRIPT
chmod 755 "$STAGE/scripts/preinstall"
pkgbuild --analyze --root "$STAGE/root" "$STAGE/components.plist"
python3 - "$STAGE/components.plist" <<'PY'
import plistlib, sys
path = sys.argv[1]
with open(path, 'rb') as source:
    components = plistlib.load(source)
for component in components:
    # Always install in Applications, never update a discovered build copy.
    component['BundleIsRelocatable'] = False
    component['BundleHasStrictIdentifier'] = True
    component['BundleOverwriteAction'] = 'upgrade'
with open(path, 'wb') as target:
    plistlib.dump(components, target)
PY
pkgbuild --root "$STAGE/root" --component-plist "$STAGE/components.plist" \
    --scripts "$STAGE/scripts" --ownership recommended \
    --install-location /Applications --identifier local.recent-screenshots.installer \
    --version 0.6.0 "build/Recent Screenshots-0.6.0.pkg"
echo "$PWD/build/Recent Screenshots-0.6.0.pkg"

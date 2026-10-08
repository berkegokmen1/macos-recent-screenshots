#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
bash scripts/build.sh
"build/Recent Screenshots.app/Contents/MacOS/RecentScreenshots" --make-previews "$PWD/docs/images"

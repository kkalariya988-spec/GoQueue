#!/bin/bash
# Re-establish the corrected PATH (drop the MSYS2 git.exe shim that breaks
# flutter's engine/version check), relaunch the app on the phone, and
# capture a screenshot to the workspace so the salon-card layout can be verified.
set -u

# ---- 1. Rebuild PATH: drop /mingw64/bin (MSYS2 git shim), keep Git for Windows + Flutter + adb ----
export PATH=$(echo "$PATH" | tr ':' '\n' | grep -vx "/mingw64/bin" | paste -sd: -)
export PATH="/c/Program Files/Git/cmd:/c/Program Files/Git/bin:/c/flutter/bin/cache/mingit/bin:$PATH"
export PATH="$PATH:/c/Program Files/Git/cmd:/c/Users/khush/AppData/Local/Android/Sdk/platform-tools"

# ---- 2. Kill any lingering flutter run processes ----
pkill -9 -f "flutter run" 2>/dev/null || true
pkill -9 -f "update_engine_version.ps1" 2>/dev/null || true
sleep 2

# ---- 3. Make sure a device is visible ----
adb wait-for-device 2>/dev/null
sleep 2
echo "=== devices ==="
adb devices 2>&1 | tail -3

# ---- 4. Launch flutter run in the background (keep it alive) ----
nohup env PATH="$PATH" flutter run -d I2302 > /d/GoQueue/flutter_run_screen.log 2>&1 &
FLUTTER_PID=$!
echo "flutter run started (pid $FLUTTER_PID, log=/d/GoQueue/flutter_run_screen.log)"

# ---- 5. Wait up to 150s for the app to appear on the device ----
for i in $(seq 1 75); do
  if adb shell ps 2>/dev/null | grep -q "com.example.goqueue"; then
    APP_PID=$(adb shell pidof com.example.goqueue | tr -d ' ')
    echo "APP STARTED after ${i}s (pid $APP_PID)"
    break
  fi
  sleep 2
done

# ---- 6. Capture the phone screen and pull it to the workspace ----
adb shell screencap -p /sdcard/screen_$(date +%s).png 2>/dev/null
SHA=$(adb shell ls -t /sdcard/screen_*.png 2>/dev/null | head -1)
if [ -n "$SHA" ]; then
  adb pull "$SHA" "/d/GoQueue/salons_page_verify.png" 2>/dev/null && echo "=== screenshot saved: salons_page_verify.png ==="
fi

# ---- 7. Print a summary ----
echo "=== app is running (keep this shell alive to keep flutter run attached) ==="
echo "If you need a fresh build, run: flutter build apk --debug && adb install build/app/outputs/flutter-apk/app-debug.apk"

# Leave flutter run running (do not kill). The calling shell may exit, but
# we keep it attached via nohup so the app keeps running on the device.
echo "READY"

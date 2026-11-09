#!/usr/bin/env bash
# Builds the APK with the background adhan.
# Needs: Node 18+, JDK 17, Android SDK (Android Studio installs it). Put these next to this script:
#   index.html   (the fixed file)      adhan.mp3   (your adhan, 30-60 s recommended)
#   adhan_fajr.mp3 (optional, a different Fajr adhan; then set NAT_FAJR_FILE=true in index.html)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; APP="$HERE/dawa-app"
rm -rf "$APP"; mkdir -p "$APP/www" && cd "$APP"
npm init -y >/dev/null
npm i @capacitor/core @capacitor/cli @capacitor/android @capacitor/local-notifications
cp "$HERE/index.html" www/index.html
npx cap init "منصة دعوة" com.dawa.app --web-dir www
npx cap add android
RAW=android/app/src/main/res/raw; mkdir -p "$RAW"
[ -f "$HERE/adhan.mp3" ] && cp "$HERE/adhan.mp3" "$RAW/adhan.mp3" || true; [ -f "$HERE/adhan_fajr.mp3" ] && cp "$HERE/adhan_fajr.mp3" "$RAW/adhan_fajr.mp3" || true
# permissions needed for exact alarms, boot restore and notifications
M=android/app/src/main/AndroidManifest.xml
python3 - "$M" <<'PY'
import sys
p=sys.argv[1]; s=open(p,encoding='utf-8').read()
perms=['POST_NOTIFICATIONS','SCHEDULE_EXACT_ALARM','USE_EXACT_ALARM','RECEIVE_BOOT_COMPLETED','WAKE_LOCK','VIBRATE']
add=''.join(f'    <uses-permission android:name="android.permission.{x}" />\n' for x in perms if x not in s)
s=s.replace('<application',add+'    <application',1) if add else s
open(p,'w',encoding='utf-8').write(s)
PY
npx cap sync android
( cd android && ./gradlew assembleDebug )
echo; echo "APK: $APP/android/app/build/outputs/apk/debug/app-debug.apk"

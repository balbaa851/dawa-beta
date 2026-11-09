# Build the APK online (no installs)
1. Create a free GitHub account → New repository (private is fine).
2. Upload ALL files of this zip (keep the `.github` folder) **plus your `adhan.mp3`** (30–60 s) to the repo root.
   Tip: on the web uploader drag the folder contents; if `.github` is skipped, create the file
   `.github/workflows/build.yml` via "Add file → Create new file" and paste its content.
3. Open the **Actions** tab → "Build APK" → **Run workflow**. Wait ~5 minutes.
4. Open the finished run → **Artifacts → dawa-apk** → download, unzip, install `app-debug.apk`.
5. In the app: 🕌 → 🔔 on → allow notifications + alarms. Then set the app's battery to Unrestricted.

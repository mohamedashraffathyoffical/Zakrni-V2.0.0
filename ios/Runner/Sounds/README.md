# iOS Notification Sound Files

This directory should contain the following sound files for prayer notifications:

- `adhan_mecca.aiff`: Adhan sound from Mecca
- `adhan_medina.aiff`: Adhan sound from Medina
- `short_beep.aiff`: A short beep sound for minimal notifications

## Instructions

1. Place the sound files in this directory with the exact names listed above
2. Convert the sound files to AIFF format for iOS compatibility (you can use online converters or tools like ffmpeg)
3. Make sure to add these files to your Xcode project by:
   - Opening the Runner.xcworkspace in Xcode
   - Right-clicking on the Runner folder in the project navigator
   - Selecting "Add Files to 'Runner'..."
   - Selecting all the sound files and making sure "Copy items if needed" is checked
   - Click "Add"
4. Update your Info.plist to include these sounds by adding the following:

```xml
<key>UNNotificationSoundName</key>
<string>adhan_mecca.aiff</string>
```

5. Keep the file sizes reasonable (under 1MB each) to avoid performance issues

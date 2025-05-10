# Prayer Time Notification Setup

This document provides instructions for setting up and customizing the prayer time notification feature in the app.

## Features

- **Pre-Prayer Notifications**: Receive notifications 5 minutes before each prayer time
- **Customizable Sounds**: Choose from different notification sounds including Adhan from Mecca and Medina
- **Multilingual Support**: Notifications in both Arabic and English based on app language setting
- **Test Button**: Test notifications directly from the settings page
- **Daily Scheduling**: Notifications are automatically scheduled for each prayer time

## Adding Custom Notification Sounds

### Android

1. Navigate to `android/app/src/main/res/raw/`
2. Add the following sound files:
   - `adhan_mecca.mp3`: Adhan sound from Mecca
   - `adhan_medina.mp3`: Adhan sound from Medina
   - `short_beep.mp3`: A short beep sound

### iOS

1. Navigate to `ios/Runner/Sounds/`
2. Add the following sound files (in AIFF format):
   - `adhan_mecca.aiff`: Adhan sound from Mecca
   - `adhan_medina.aiff`: Adhan sound from Medina
   - `short_beep.aiff`: A short beep sound
3. Add these files to your Xcode project:
   - Open the Runner.xcworkspace in Xcode
   - Right-click on the Runner folder in the project navigator
   - Select "Add Files to 'Runner'..."
   - Select all the sound files and make sure "Copy items if needed" is checked
   - Click "Add"

## User Guide

### Enabling Notifications

1. Go to the Settings page
2. Toggle "Enable Prayer Notifications" to ON
3. Select your preferred notification sound from the dropdown menu
4. Test the notification by clicking the "Test Notification" button

### Notification Content

Notifications include:
- The name of the upcoming prayer
- A reminder message: "Prepare for prayer"
- The phrase "Prayer is the pillar of religion"

### Troubleshooting

If notifications are not working:

1. Make sure notifications are enabled in the app settings
2. Check that notifications are allowed for the app in your device settings
3. Restart the app after changing notification settings
4. Ensure your device is not in Do Not Disturb mode
5. For custom sounds, verify that the sound files are correctly placed in the appropriate directories

## Technical Notes

- Notifications are scheduled using the Flutter Local Notifications plugin
- The app handles timezone changes automatically and reschedules notifications accordingly
- Notification preferences are stored using SharedPreferences
- Notifications are scheduled to repeat daily at the same time

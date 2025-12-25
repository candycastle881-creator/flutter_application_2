## Hue Sense - Play Store Launch Checklist

This document guides you through preparing your app for Google Play Store release.

---

## PHASE 1: App Configuration (✓ Mostly Done)

### Android Configuration
- [x] Updated `AndroidManifest.xml`:
  - App label: "Hue Sense"
  - Added permissions: CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, INTERNET, ACCESS_NETWORK_STATE
  - AdMob App ID: `ca-app-pub-3940256099942544~3347511713` (test) - **Update to your production ID**

- [x] Updated `build.gradle.kts`:
  - Namespace: `com.huesense.app`
  - Application ID: `com.huesense.app` (Change if you prefer a different package name)

- [x] Updated `pubspec.yaml`:
  - App name: `hue_sense`
  - Version: `1.0.0+1`
  - Build number: `1`

### Ad Unit Configuration
- [ ] Update Ad Unit IDs in `lib/main.dart` (lines ~217 and ~321):
  - **Banner Ad Unit ID**: `ca-app-pub-6695784329123227/XXXXXXXXXX` (Get from AdMob console)
  - **Rewarded Ad Unit ID**: `ca-app-pub-6695784329123227/YYYYYYYYYY` (Get from AdMob console)
  - Currently set to use test IDs in debug mode; production IDs needed for release

- [x] AdMob Publisher ID verified: `pub-6695784329123227`
- [x] app-ads.txt hosted and ready for verification

---

## PHASE 2: App Signing & Build Preparation

### Generate Signing Key (Do this once)
```bash
# Generate a keystore file for signing releases
keytool -genkey -v -keystore ~/hue_sense_key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias hue_sense_key \
  -storepass YOUR_PASSWORD \
  -keypass YOUR_PASSWORD
```

Create `android/key.properties` with:
```properties
storeFile=/path/to/hue_sense_key.jks
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=hue_sense_key
```

### Configure Gradle for Signing
Update `android/app/build.gradle.kts` to include:
```kotlin
android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias = "hue_sense_key"
            keyPassword = System.getenv("KEY_PASSWORD")
            storeFile = file("/path/to/hue_sense_key.jks")
            storePassword = System.getenv("STORE_PASSWORD")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

---

## PHASE 3: Build Release APK/AAB

### Build App Bundle (AAB) for Play Store
```bash
cd /Users/aswinsanal/PROJECT\ SKINTONE\ COLOR\ PALETTE/flutter_application_2

# Build App Bundle
flutter build appbundle \
  --target-platform android-arm64 \
  --split-debug-info \
  --obfuscate \
  --release
```

Output will be at: `build/app/outputs/bundle/release/app-release.aab`

### Alternative: Build Release APK
```bash
flutter build apk \
  --target-platform android-arm64 \
  --obfuscate \
  --split-debug-info \
  --release
```

Output will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## PHASE 4: Play Store Listing Setup

1. **Go to Google Play Console**: https://play.google.com/console
2. **Create new app** (if not already created):
   - Language: English
   - App name: **Hue Sense**
   - Default language: English (US)

3. **Fill Store Listing**:
   - **App name**: Hue Sense
   - **Short description** (50 chars): "AI skin tone undertone detector & outfit color recommender"
   - **Full description** (4000 chars):
     ```
     Discover your skin tone undertone and unlock personalized color palettes with Hue Sense.
     
     FEATURES:
     • Scan your skin to detect undertone (Warm, Cool, or Neutral)
     • Get curated outfit color recommendations
     • See outfit suggestions with shirt, pants, and accent colors
     • Beautiful glassmorphic interface with smooth animations
     
     HOW IT WORKS:
     1. Take a selfie or upload a photo
     2. Hue Sense analyzes your skin tone undertone
     3. Receive personalized outfit color suggestions
     4. Unlock pro features to explore premium color palettes
     
     PRIVACY:
     Your photos are processed locally on your device. We don't store or share any images.
     
     MONETIZATION:
     - Free app with optional premium unlock via rewarded ads
     - Display banner ads on key screens
     ```
   - **Developer website**: `https://aswinsanal.github.io` (or your GitHub Pages URL with app-ads.txt)

4. **Graphics & Branding**:
   - [ ] App icon (512x512 PNG)
   - [ ] Feature graphic (1024x500 PNG)
   - [ ] Promo graphic (180x120 PNG)
   - [ ] Screenshots (up to 8, min 320x569):
     - Screenshot 1: Home screen with camera/gallery tiles
     - Screenshot 2: Result screen showing undertone
     - Screenshot 3: Outfit suggestions with color palettes
     - Screenshot 4: Glassmorphic UI design
   - [ ] Video promo (optional, 15-30 sec)

5. **Content Rating**:
   - Select "Medical Information" if applicable
   - Answer the content rating questionnaire
   - Get rating: Likely G or PG

6. **Privacy Policy**:
   - [ ] Create privacy policy at: `https://yourdomain.com/privacy`
   - Include:
     - No image storage or sharing
     - Ad network privacy policies (Google AdMob)
     - Permission usage explanation
     - Contact email for privacy concerns

7. **Content Rating & Age**: Target age 3+

---

## PHASE 5: Before Submission

### Testing Checklist
- [ ] App runs without crashes on Android 8.0+ devices
- [ ] Camera permission request works
- [ ] Image pick from gallery works
- [ ] Undertone detection produces results
- [ ] Ads display correctly (banner + rewarded)
- [ ] Unlock Pro feature works
- [ ] All UI renders properly
- [ ] No debug logs in console (strip with `--obfuscate`)

### Final Checks
- [ ] Version code incremented (in pubspec.yaml)
- [ ] App signed with release key
- [ ] Release APK/AAB tested on real device
- [ ] AdMob ad units are production (not test)
- [ ] app-ads.txt hosted and verified
- [ ] Developer website URL set in Play Store listing
- [ ] Privacy policy URL set

---

## PHASE 6: Submit to Play Store

1. **Sign into Play Console**
2. **Select Hue Sense app**
3. **Go to Release → Production**
4. **Upload release APK/AAB** (build/app/outputs/bundle/release/app-release.aab)
5. **Review & confirm**:
   - Check that app name, description, and graphics are correct
   - Verify content rating
   - Confirm pricing & distribution
6. **Click "Review and publish"**
7. **Google reviews** (typically 2-4 hours, sometimes longer first time)
8. **App goes live!** 🎉

---

## PHASE 7: Post-Launch

### Monitor & Optimize
- [ ] Monitor crash rates in Play Console
- [ ] Check ad performance in AdMob dashboard
- [ ] Collect user reviews and ratings
- [ ] Fix bugs quickly (hot fix updates)
- [ ] Plan v1.0.1 with improvements

### Updates
To release updates:
```bash
# Increment version in pubspec.yaml: version: 1.0.1+2
flutter build appbundle --release
# Upload new AAB to Play Console → Production
```

---

## Quick Reference: Ad Unit IDs Needed

| Type | Current Value | Status |
|------|---------------|--------|
| **Banner Ad** | `ca-app-pub-6695784329123227/XXXXXXXXXX` | ⚠️ TODO: Get from AdMob |
| **Rewarded Ad** | `ca-app-pub-6695784329123227/YYYYYYYYYY` | ⚠️ TODO: Get from AdMob |

Get these in AdMob console:
1. Go to https://admob.google.com
2. Select your app
3. Click "Ad units" on left sidebar
4. Create Banner ad unit → copy ID → update `lib/main.dart` line ~217
5. Create Rewarded ad unit → copy ID → update `lib/main.dart` line ~321

---

## Troubleshooting

**Problem**: Build fails with signing config
- Check `android/key.properties` paths are absolute and file exists
- Ensure password environment variables are set: `export KEY_PASSWORD=...`

**Problem**: Ads not showing in release build
- Verify you updated production ad unit IDs (not test IDs)
- Check AdMob app is approved and ad units are active
- Run in production (not debug) to see real ads

**Problem**: App rejected by Play Store
- Common reasons: Missing privacy policy, inappropriate permissions, broken functionality
- Check rejection email for specific issues
- Fix and resubmit

---

## Support Links
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Google AdMob Help](https://support.google.com/admob)
- [Flutter App Distribution](https://flutter.dev/deployment/android)

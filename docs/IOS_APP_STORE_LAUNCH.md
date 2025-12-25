## Hue Sense - iOS App Store Launch Guide

Preparing your app for Apple App Store release.

---

## PHASE 1: iOS Configuration

### Update Info.plist
Update `ios/Runner/Info.plist` to include:

```xml
<!-- Camera Permission -->
<key>NSCameraUsageDescription</key>
<string>Hue Sense uses your camera to analyze your skin tone and detect undertone for personalized color recommendations.</string>

<!-- Photo Library Permission -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Hue Sense needs access to your photo library to analyze skin tone from your photos.</string>

<!-- App Transport Security (allow HTTP for testing, but use HTTPS in production) -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

### Update Build Settings
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Runner" project
3. Update General settings:
   - **Bundle Identifier**: `com.huesense.app` (must match Android package for consistency)
   - **Version**: `1.0.0`
   - **Build**: `1`
   - **Minimum Deployments**: iOS 11.0+

### Update App Icons
1. Replace icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:
   - Provide icons for all required sizes (see Xcode for sizes)
   - Use 1024x1024 PNG for App Store

### Update Launch Screen
Edit `ios/Runner/Base.lproj/LaunchScreen.storyboard` to match your branding.

---

## PHASE 2: AdMob Configuration for iOS

### Add Google Mobile Ads SDK
Already configured via `pubspec.yaml: google_mobile_ads: ^5.0.0`

### Update Ad Unit IDs
Same as Android - update `lib/main.dart` lines ~217 and ~321 with production iOS ad unit IDs from AdMob console.

### Update Info.plist with AdMob App ID
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```
(Get this from AdMob Settings → App settings)

---

## PHASE 3: Build for iOS

### Generate Release Build
```bash
cd /Users/aswinsanal/PROJECT SKINTONE COLOR PALETTE/flutter_application_2

# Build release
flutter build ios --release

# Or, for distribution archive
flutter build ipa --release
```

Output: `build/ios/ipa/Runner.ipa`

### Signing & Provisioning (Xcode)
1. Open `ios/Runner.xcworkspace`
2. Select "Runner" project
3. Select "Runner" target
4. **Signing & Capabilities** tab:
   - Team: Select your Apple Developer team
   - Bundle ID: `com.huesense.app`
   - Signing Certificate: Automatic (or select manually)
   - Provisioning Profile: Automatic

---

## PHASE 4: App Store Connect Setup

1. **Go to App Store Connect**: https://appstoreconnect.apple.com
2. **Create new app**:
   - Platform: iOS
   - App Name: **Hue Sense**
   - Primary Language: English
   - Bundle ID: `com.huesense.app`
   - SKU: `huesense-v1` (unique identifier)
3. **General Information**:
   - Category: Health & Fitness (or Lifestyle)
   - Subcategory: Health & Fitness
   - Content rating: Ages 4+

---

## PHASE 5: App Store Listing

### Prepare Metadata
1. **App Preview & Screenshots**:
   - Upload up to 5 screenshots for each device type (5.5", 6.5", iPad)
   - Include text overlay showing key features
   - Recommended: 3-5 screenshots max

2. **Description** (4000 chars max):
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
   Your photos are processed locally on your device. We never store or share any images.
   ```

3. **Keywords** (100 chars total):
   `skin tone, color palette, fashion, ai, undertone`

4. **Support URL**:
   `https://aswinsanal.github.io` (or your website)

5. **Privacy Policy URL** (required):
   `https://yoursite.com/privacy`
   - Must explain:
     - Photos are not stored
     - How ads work (Google AdMob)
     - Permission usage

6. **Age Rating**:
   Answer App Store age rating questionnaire
   - Medical Info: No (unless medically certified)
   - Likely rating: 4+ or 12+

---

## PHASE 6: Submit for Review

1. **Version Information**:
   - Version Number: 1.0.0
   - Build: Select latest build from list
   - Release Notes: "Initial release of Hue Sense"

2. **Review Information**:
   - First Name & Last Name
   - Email
   - Phone number
   - Address
   - Alternate contact info
   - Demo account (if needed; not required for this app)

3. **App Review Information**:
   - App requires login: No
   - Includes ads: Yes → Select "Google Mobile Ads"
   - User-generated content: No
   - Age-restricted content: No

4. **Compliance**:
   - Export compliance: No
   - Encryption: No (or select as needed)
   - Math-based encryption: No (unless applicable)

5. **Click "Submit for Review"**

---

## PHASE 7: Post-Submission

### Review Timeline
- Apple typically reviews apps within 24-48 hours
- If issues arise, you'll receive rejection email with specific reasons
- Common rejections:
  - Privacy policy missing or incomplete
  - Ads not properly disclosed
  - Functionality broken on test device
  - Inappropriate permissions request

### If Rejected
1. Read rejection reason carefully
2. Fix the issue
3. Increment build number in Xcode
4. Submit new build

### If Approved 🎉
- App appears on App Store
- Update iOS version available to all users
- Monitor reviews and ratings
- Plan updates

---

## Keep in Sync: Android & iOS

To maintain consistency, whenever you update:
- **Version**: Update in both `pubspec.yaml` (Android) and Xcode (iOS)
- **Permissions**: Update both `AndroidManifest.xml` and `Info.plist`
- **App Icons**: Provide for both platforms
- **App Name & Description**: Keep consistent

---

## Troubleshooting

**Problem**: Build fails with provisioning profile
- Solution: Go to Xcode → Runner → Signing & Capabilities → Reset to automatic

**Problem**: Ads not showing in TestFlight
- Solution: TestFlight builds use test ad unit IDs; production ads show after App Store release

**Problem**: App rejected for privacy policy
- Solution: Create detailed privacy policy at yoursite.com/privacy with all required sections

---

## Links
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google AdMob for iOS](https://developers.google.com/admob/ios/quick-start)
- [Flutter iOS Deployment](https://flutter.dev/deployment/ios)

# Hue Sense - Ad Testing Guide

## Overview
This test build (v1.0.3+4) includes Google Mobile Ads enabled to test ad functionality before deciding on the final release version.

**Important**: This is a **TEST BUILD ONLY** and should NOT be submitted to Google Play Console's production track.

---

## Build Artifacts

| File | Size | Version | Ads Status |
|------|------|---------|-----------|
| `app-release.aab` | 45.3 MB | 1.0.3 (Build 4) | ✅ WITH ADS |
| `app-release.apk` | 50.0 MB | 1.0.3 (Build 4) | ✅ WITH ADS |

---

## Test Instructions

### 1. Install Test APK on Device

```bash
# Via USB
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Or drag to emulator
```

### 2. Test Ad Display

**Banner Ad Test**:
- ✅ Open app
- ✅ Check bottom of screen for banner ad
- ✅ Ad should load from Google test ad network
- ✅ Tap ad to verify functionality

**Rewarded Ad Test**:
- ✅ Navigate to Pro Features
- ✅ Click "Unlock Pro"
- ✅ Watch for rewarded video ad
- ✅ Reward should grant pro access after viewing ad

### 3. Functionality Test

- ✅ Camera permission working
- ✅ Photo capture working
- ✅ Undertone detection working
- ✅ Color recommendations displaying
- ✅ UI responsive and smooth (60 FPS)
- ✅ No crashes or errors

### 4. Ad Network Verification

**Expected Ad IDs (Test)**:
```
Banner: ca-app-pub-3940256099942544/6300978111
Rewarded: ca-app-pub-3940256099942544/5224354917
```

These are Google's public test ad IDs - they always show valid test ads.

---

## Version Comparison

### Production Build (v1.0.2+3)
- **File**: Build on commit `4737038`
- **Status**: Ad-free, Families policy compliant
- **Size**: 39-40 MB (smaller)
- **Ready**: For Google Play submission

### Test Build (v1.0.3+4) - This Build
- **File**: Latest commits with ads re-enabled
- **Status**: Ad-enabled for testing
- **Size**: 45-50 MB (larger with ad SDK)
- **Purpose**: Testing only, NOT for production

---

## Decision Guide

### Choose Production (v1.0.2+3) if:
- ✅ You want ad-free, family-friendly app
- ✅ You want to avoid ad policy complications
- ✅ You prioritize user experience over monetization
- ✅ Target audience is "Families" category
- **Smaller file size (39 MB)**
- **Faster approval** (~2-4 hours)

### Choose Ads (v1.0.3+4) if:
- ✅ You want in-app monetization
- ✅ Banner ads are acceptable in your market
- ✅ Rewarded ads don't impact user experience
- ✅ You're okay with longer review process
- **Higher file size (45+ MB)**
- **May take longer** for review (5-7 days)

---

## Switching Between Versions

### To Switch Back to Ad-Free (v1.0.2+3):
```bash
# Revert pubspec.yaml and main.dart
git checkout HEAD -- pubspec.yaml lib/main.dart

# Update version back to 1.0.2+3
# Rebuild

flutter pub get
flutter build appbundle --release
```

### To Keep Ads (v1.0.3+4):
```bash
# Commit changes
git add -A
git commit -m "Add Google Mobile Ads - test version"

# Update to next version if needed
# 1.0.3+4 → 1.0.4+5 for production
```

---

## Testing Checklist

- [ ] App installs successfully
- [ ] Launches without crashes
- [ ] Banner ad displays at bottom
- [ ] Banner ad is clickable
- [ ] Rewarded ad plays when unlocking pro
- [ ] Pro unlock works after ad reward
- [ ] Camera works
- [ ] Photo detection works
- [ ] UI is smooth (no lag)
- [ ] All text is readable
- [ ] No permission errors

---

## Important Notes

### Ad Policy Compliance
- ✅ Using official Google test ad IDs
- ✅ No invalid traffic
- ✅ No ad fraud
- ✅ Safe for testing

### Production Considerations
- If using ads in production, you'll need:
  - AdMob approval (usually automatic)
  - Higher Google Play review time
  - Ad policy compliance
  - Regular ad fraud monitoring

### Family App Policy
- Ad-free version is 100% families-compliant
- Ad version must use Family Safe Ad SDK
- Current setup uses standard Google Mobile Ads (not family-safe certified)

---

## Next Steps

After testing, choose one:

**Option A: Submit Ad-Free Version** (Recommended)
```bash
git checkout HEAD -- pubspec.yaml lib/main.dart
# Make sure version is 1.0.2+3
flutter build appbundle --release
# Upload build/app/outputs/bundle/release/app-release.aab to Play Console
```

**Option B: Submit Ad Version**
```bash
# Keep current changes (v1.0.3+4)
# Bump to v1.0.4+5 for production (never reuse version codes)
# Update version in pubspec.yaml
flutter build appbundle --release
# Upload and select Category: "General audience" (not Families)
```

---

## Support

If ads aren't showing:
1. Check internet connection
2. Verify test ad IDs are correct
3. Check Google Mobile Ads console
4. Verify AdMob account has test devices configured

---

**Test Build Created**: January 1, 2026
**Status**: Ready for local device testing

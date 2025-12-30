# Ad Display & Loading - Debugging Guide

## What Was Fixed

### 1. **Banner Ad Display Issues**
- **Problem**: Banner ad wasn't showing even after loading
- **Solution**: 
  - Added `_bannerAdLoaded` state flag to track when ad is actually ready
  - Banner now only renders when both `bannerAd != null` AND `_bannerAdLoaded == true`
  - Added `onAdLoaded` callback that sets `_bannerAdLoaded = true`

### 2. **Rewarded Ad Loading & Display**
- **Problem**: Rewarded ads silent failures, no feedback to user
- **Solution**:
  - Preload rewarded ad on app startup (not on-demand)
  - Implement full lifecycle tracking with error logging
  - Show SnackBar to user if ad not ready when they tap unlock
  - Re-load ad after each show/failure

### 3. **Comprehensive Ad Logging**
All ad events now log to Dart Developer console:

```
✓ Banner ad loaded
✓ Rewarded ad loaded successfully
✗ Banner ad failed: [error reason] (code: [error code])
✗ Rewarded ad failed to load: [error reason]
✗ Rewarded ad failed to show: [error reason]
Loading rewarded ad with ID: ca-app-pub-6695784329123227/1927776799 (prod)
Rewarded ad dismissed
User earned reward: [amount] [type]
```

---

## How to Check Ad Status

### View Logs in Android Studio
```bash
cd "/Users/aswinsanal/PROJECT SKINTONE COLOR PALETTE/flutter_application_2"
flutter run --release
# In terminal, search for lines starting with: ✓, ✗, or "Loading"
```

### In VS Code with Dart DevTools
```bash
flutter run --release --use-application-binary
# Open DevTools → Logging tab → search "Banner\|Rewarded"
```

### Using `flutter logs` command
```bash
# Terminal 1
flutter run --release

# Terminal 2
flutter logs | grep -E "✓|✗|Loading|reward|dismiss"
```

---

## Expected Behavior

### On App Start
```
Loading banner ad with ID: ca-app-pub-6695784329123227/8146534934 (prod)
Loading rewarded ad with ID: ca-app-pub-6695784329123227/1927776799 (prod)
✓ Banner ad loaded        [should appear within 2-5 seconds]
✓ Rewarded ad loaded successfully  [should appear within 3-10 seconds]
```

### When User Taps "Unlock"
```
unlockPro called. Rewarded ad ready: true
Showing rewarded ad...
[Ad plays on screen for 5-30 seconds]
Rewarded ad dismissed
User earned reward: 1 Reward
```

### If Ad Not Ready
```
unlockPro called. Rewarded ad ready: false
Rewarded ad not ready
[SnackBar shows: "Loading ad, please try again in a moment"]
Loading rewarded ad with ID: ca-app-pub-6695784329123227/1927776799 (prod)
[After ~5 sec]
✓ Rewarded ad loaded successfully
```

---

## Common Issues & Solutions

### Issue 1: "Banner ad failed" appears in logs

**Symptoms**: Ad doesn't show, but app runs fine

**Causes**:
- Ad unit ID is invalid or inactive in AdMob console
- Device doesn't have internet
- AdMob account not verified
- Ad unit hasn't warmed up (new units take 24+ hours)

**Fix**:
1. Go to https://admob.google.com
2. Check that ad units are **ACTIVE** (green status)
3. Verify ad unit IDs match those in `lib/main.dart` lines 17-18
4. Try using **test ad IDs** to verify setup:
   - Banner: `ca-app-pub-3940256099942544/6300978111`
   - Rewarded: `ca-app-pub-3940256099942544/5224354917`
5. Ensure device has working internet connection

### Issue 2: "Rewarded ad failed to load" appears

**Symptoms**: User sees "Loading ad..." message, but ad never loads

**Causes**:
- Same as Issue 1 (bad ID, no internet, inactive unit)
- Ad request throttled (requesting too frequently)

**Fix**:
- Verify ad unit ID and internet
- Wait 30+ seconds before tapping unlock again
- Check AdMob dashboard for quota/rate limit warnings

### Issue 3: Ad shows but user doesn't get reward

**Symptoms**: Ad plays, but "Loading ad..." shows again instead of unlocking

**Causes**:
- `onUserEarnedReward` callback not firing
- Dart state not updating properly

**Fix**:
- Check logs for: `User earned reward: [amount]`
- If missing, reward callback issue → contact Google AdMob support
- Restart app and try again

### Issue 4: Ad loads in debug but not in release

**Symptoms**: 
- `flutter run` (debug) shows ads ✓
- `flutter run --release` fails ✗

**Causes**:
- Different ad unit IDs for debug vs release
- Release build obfuscation (rare)

**Fix**:
- Debug uses **test IDs** (lines 14-15)
- Release uses **production IDs** (lines 17-18)
- This is correct behavior—production IDs don't serve in debug

---

## Ad Unit IDs - Current Setup

```dart
// TEST IDS (debug builds only)
const String _bannerAdUnitId_Test = 'ca-app-pub-3940256099942544/6300978111';
const String _rewardedAdUnitId_Test = 'ca-app-pub-3940256099942544/5224354917';

// PRODUCTION IDS (release builds only)
const String _bannerAdUnitId_Prod = 'ca-app-pub-6695784329123227/8146534934';
const String _rewardedAdUnitId_Prod = 'ca-app-pub-6695784329123227/1927776799';

// Auto-select based on build mode
final String bannerAdUnitId = kDebugMode ? _bannerAdUnitId_Test : _bannerAdUnitId_Prod;
final String rewardedAdUnitId = kDebugMode ? _rewardedAdUnitId_Test : _rewardedAdUnitId_Prod;
```

---

## Testing Flow

### Step 1: Test with Test Ad IDs (Safe)
Temporarily replace production IDs with test IDs to verify setup:

```dart
// In lib/main.dart, temporarily change:
final String bannerAdUnitId = _bannerAdUnitId_Test;  // Always use test
final String rewardedAdUnitId = _rewardedAdUnitId_Test;  // Always use test
```

Build and run:
```bash
flutter run --release
```

**Expected**: Ads should load within 5-10 seconds, SnackBar messages appear when you tap unlock.

### Step 2: Switch Back to Production
```dart
// Revert to:
final String bannerAdUnitId = kDebugMode ? _bannerAdUnitId_Test : _bannerAdUnitId_Prod;
final String rewardedAdUnitId = kDebugMode ? _rewardedAdUnitId_Test : _rewardedAdUnitId_Prod;
```

Rebuild:
```bash
flutter clean && flutter build apk --release
```

---

## Monitoring Ad Performance

### In AdMob Console (https://admob.google.com)
1. Navigate to **Reports** → **Ad Units**
2. Click each ad unit to see:
   - Impressions (how many times ad was requested)
   - Clicks (how many users interacted)
   - Revenue (earnings)
   - Errors/Warnings

### In Play Console (after launch)
1. Go to **Analytics** → **Crashes & ANRs**
2. Search for AdMob-related errors
3. **Quality** tab shows user complaints about ads

---

## Code Review Checklist

- [x] Banner ad loads on app startup
- [x] Banner ad shows in bottomNavigationBar after loading
- [x] Rewarded ad preloads on app startup
- [x] Rewarded ad shows when user taps unlock (if loaded)
- [x] SnackBar feedback if ad not ready
- [x] Ad disposal on screen close
- [x] Re-load after dismiss/failure
- [x] Comprehensive logging for debugging
- [x] Test IDs work (debug mode)
- [x] Production IDs work (release mode)

---

## Next Steps

1. **Test the app** with current production IDs:
   ```bash
   flutter run --release
   ```

2. **Check logs** for ✓ or ✗ messages:
   - If ✓: Ads are working, proceed to Play Store launch
   - If ✗: See Common Issues section above

3. **If ads still fail**:
   - Verify internet on test device
   - Check AdMob console for active status
   - Try test ad IDs temporarily
   - Allow 24+ hours for new ad units to warm up

4. **Before Play Store submission**:
   - Test rewarded ad unlock flow end-to-end
   - Verify banner ad shows in release build
   - Check AdMob logs for no errors/warnings

---

**Last Updated**: December 30, 2025  
**Status**: Ad handling improved with logging and state tracking

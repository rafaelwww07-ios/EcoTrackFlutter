# Lottie Animations

This folder should contain Lottie animation JSON files.

## Recommended Animations

For the EcoTrack app, you can add:

1. **Empty state animations**:
   - `empty_challenges.json` - For empty challenges list
   - `empty_recycling_points.json` - For empty map
   - `empty_statistics.json` - For empty statistics

2. **Success animations**:
   - `challenge_complete.json` - When challenge is completed
   - `points_earned.json` - When points are earned
   - `achievement_unlocked.json` - When achievement is unlocked

3. **Loading animations**:
   - `loading_eco.json` - General loading animation
   - `calculating.json` - For calculator loading

## Where to Get Animations

1. **LottieFiles** (Free): https://lottiefiles.com/
   - Search for: "eco", "green", "recycle", "success", "loading"
   - Download as JSON
   - Place in this folder

2. **Create Custom**: Use After Effects + Bodymovin plugin

## Usage in Code

Example:
```dart
Lottie.asset(
  'assets/animations/empty_challenges.json',
  height: 200,
  width: 200,
)
```

## File Structure

```
assets/
  animations/
    empty_challenges.json
    empty_recycling_points.json
    challenge_complete.json
    ...
```

## Note

The app will work without these animations - they're optional enhancements.
If animations are missing, the app will show default icons instead.



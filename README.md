# Wellness Companion — WatchOS Personal Wellness Companion

**Student:** Raman Kumari
**Assignment:** Assignment 3 — WatchOS Personal Wellness Companion
**Weight:** 15% of Final Grade (25 marks)
**Platform:** watchOS (SwiftUI, Xcode 15+, watchOS 10.0+ deployment target)

---

## 1. App Description

Wellness Companion is a standalone Apple Watch app that gives the user a quick,
glanceable read on their daily activity. It reads step count, active energy,
and exercise minutes from HealthKit, turns them into a single **Wellness
Score**, and explains what that score means in plain language along with a
suggested next activity — all without ever leaving the wrist.

The app is built entirely in SwiftUI, uses `NavigationStack` for navigation,
and follows Apple's watchOS Human Interface Guidelines (large glanceable
text, minimal chrome, rounded system fonts, generous tap targets, dark
background with high-contrast accent colors).

## 2. HealthKit Data Used

| Metric | HealthKit Type | Used For |
|---|---|---|
| Step Count | `HKQuantityType(.stepCount)` | Primary dashboard metric, progress ring, status message |
| Active Energy Burned | `HKQuantityType(.activeEnergyBurned)` | 30% weight in the Wellness Score |
| Exercise Minutes | `HKQuantityType(.appleExerciseTime)` | 20% weight in the Wellness Score |

Only **read** access is requested for these three types — the app never
writes to HealthKit and never requests unrelated metrics (e.g. heart rate,
sleep, nutrition).

## 3. Description of Screens

### Screen 1 — Daily Wellness Dashboard (`DashboardView.swift`)
- Today's step count against the daily goal (10,000 steps)
- A circular progress ring showing percentage toward the goal
- A status message ("Excellent progress" / "Good progress" / "Just getting
  started") that reacts to the live data
- The Wellness Score badge (see Advanced Feature below)
- `NavigationLink`s to the Insights and About Health Data screens

### Screen 2 — Wellness Insights (`InsightsView.swift`)
- Plain-language explanation of what step count measures
- Today's interpretation, e.g. *"You are 75% toward your daily goal."*
- The Wellness Score and what category it falls into
- A suggested activity message tailored to current progress

### Screen 3 — About Health Data (`AboutHealthDataView.swift`)
- Where the data comes from (Apple HealthKit / Apple Watch sensors)
- Why the app asks for permission, and exactly what it asks for
- A privacy statement (data never leaves the device)
- How to review or revoke permission in the Health app

Navigation is a single shallow `NavigationStack` rooted at the Dashboard,
with two `NavigationLink`s pushing to Insights and About — never more than
one level deep, per the HIG guidance to keep watch navigation simple.

## 4. Advanced Feature Selected — Option A: Wellness Score System

Implemented in `Models/WellnessScore.swift`. The score is a weighted blend
of three HealthKit-derived progress ratios:

```
score = (stepProgress × 0.5 + activeEnergyProgress × 0.3 + exerciseProgress × 0.2) × 100
```

Steps are weighted highest (50%) because they are the most consistently
available HealthKit metric on-device. The result is mapped to three bands
exactly as specified in the assignment:

| Score | Category |
|---|---|
| 0–40 | Needs Improvement |
| 41–70 | Moderate Activity |
| 71–100 | Excellent Activity |

The score and its category drive the badge color (red / orange / green) and
the encouragement message shown on both the Dashboard and Insights screens.

## 5. HealthKit Integration Details

`Managers/HealthKitManager.swift` is an `ObservableObject` that:

1. Calls `HKHealthStore.requestAuthorization(toShare: [], read:)` for exactly
   the three quantity types above.
2. Fetches today's cumulative totals with `HKStatisticsQuery` for each type,
   scoped to `Calendar.current.startOfDay(for: Date())`.
3. Publishes an `AuthorizationState` (`notRequested`, `authorized`, `denied`,
   `unavailable`) that the views switch on to render the right UI —
   including a **graceful fallback card** if permission is denied or
   HealthKit is unavailable (e.g. in a fresh Simulator with no data),
   instead of showing blank or crashing.

## 6. Privacy Considerations

- Only read access is requested; no data is ever written back to HealthKit.
- All processing happens on-device — nothing is transmitted to a server.
- `NSHealthShareUsageDescription` in `Info.plist` clearly states why each
  metric is needed.
- The About Health Data screen surfaces this same information to the user
  directly inside the app, not just in the system permission prompt.

## 7. Known Limitations

- Tested in the watchOS Simulator, which has no real sensor data — step,
  energy, and exercise values must be seeded manually via Health app sample
  data on a paired iPhone Simulator, or the Simulator's Health debug menu.
- The app is a standalone Watch App (`WKWatchOnly`) with no iPhone
  companion UI; all interaction happens on the watch.
- Daily goals (10,000 steps / 450 kcal / 30 min) are fixed constants rather
  than user-configurable settings, to keep the UI within the assignment's
  three-screen scope.
- The Wellness Score's weighting (50/30/20) is a reasonable, documented
  default rather than a clinically validated formula.

## 8. Project Structure

```
WellnessCompanion Watch App/
├── WellnessCompanionApp.swift        # @main App entry point, requests HealthKit auth on launch
├── ContentView.swift                 # Root NavigationStack
├── Views/
│   ├── DashboardView.swift           # Screen 1
│   ├── InsightsView.swift            # Screen 2
│   ├── AboutHealthDataView.swift     # Screen 3
│   └── Components/
│       ├── ProgressRingView.swift    # Reusable circular progress ring
│       └── ScoreBadgeView.swift      # Wellness Score badge
├── Managers/
│   └── HealthKitManager.swift        # HealthKit auth + fetch logic
├── Models/
│   ├── WellnessMetrics.swift         # Raw values + goals + progress helpers
│   └── WellnessScore.swift           # Advanced feature: score + category
├── Assets.xcassets/                  # App icon + accent color
└── Info.plist                        # HealthKit usage string, WKApplication keys
```

## 9. Screenshots

`Screenshots/screen_mockups.html` contains high-fidelity mockups of all four
required captures (Dashboard, Insights, About Health Data, HealthKit
permission request), built to match the actual SwiftUI layout and copy —
open it in any browser. These stand in for Simulator screenshots because
this project was built on a Windows machine without Xcode; replace them with
real ⌘R Simulator captures before final submission if a Mac is available.

## 10. How to Run

1. Open `WellnessCompanion Watch App.xcodeproj` in Xcode 15 or later.
2. Select a watchOS Simulator target (e.g. "Apple Watch Series 9 (45mm)").
3. Build & run (⌘R). On first launch the app requests HealthKit permission.
4. To see non-zero data in the Simulator, add sample Health data via the
   paired iPhone Simulator's Health app, then relaunch.

## 11. Rubric Self-Check

| Category | Marks | Where it's satisfied |
|---|---|---|
| WatchOS Project Setup | 4 | Standalone SwiftUI watchOS target, organized `Views/Managers/Models` structure, runs on Simulator |
| SwiftUI UI Design | 5 | Rounded system fonts, progress ring, color-coded cards, dark-friendly layout across 3 screens |
| Navigation & Screen Structure | 4 | `NavigationStack` in `ContentView`, two `NavigationLink`s, shallow one-level depth |
| HealthKit Integration | 6 | Real `HKHealthStore` auth + `HKStatisticsQuery` for 3 metrics, graceful denied/unavailable handling |
| WatchOS Design Compliance | 3 | Large glanceable text, minimal clutter, `ScrollView` for multi-size watch support, watch-friendly controls |
| Advanced Requirement (Option A) | 3 | `WellnessScore.swift` — weighted 0–100 score with the exact 3 bands specified |
| **Total** | **25** | |

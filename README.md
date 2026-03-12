# ArvyaX – Immersive Ambience & Reflection App

A calm, minimal, and premium Flutter mini-app designed for guided ambient sessions and post-session journaling.

## How to Run the Project

1. **Prerequisites**: Ensure you have Flutter SDK installed (tested on \`Flutter 3.41.4\`).
2. **Clone/Unzip**: Open the project folder in your terminal.
3. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```
   *(To run on an Android emulator or physical device, ensure it is connected and recognized by `flutter devices`)*

## Architecture Explanation

This project follows a **Feature-Driven Architecture** separated into logical layers (Data, Core, Features, Shared). State management is handled entirely by **Riverpod**, and local persistence by **Hive**.

### Folder Structure
```text
lib/
├── core/             # App-wide configurations
│   ├── router/       # GoRouter setup (including ShellRoute for the mini-player)
│   └── theme/        # AppTheme (Light & Dark mode color tokens, typography)
├── data/             # Models and Repositories
│   ├── models/       # Data classes (Ambience, JournalEntry, SessionStateModel)
│   └── repositories/ # Data sources (JSON loader, Hive CRUD for journal/session)
├── features/         # Feature modules
│   ├── ambience/     # Home screen, details, search & filtering logic
│   ├── journal/      # Reflection prompt, saving entries, history list
│   └── player/       # Full-screen session player, audio logic, timer, mini-player
├── shared/           # Reusable UI components
│   └── widgets/      # AmbienceCard, TagChip, EmptyState
├── app.dart          # MaterialApp configuration
└── main.dart         # Entry point, Hive initialization, ProviderScope
```

### State Management Approach
We use **Riverpod**. Each feature has a single dedicated `Provider` or `StateNotifier`:
- `AmbienceProvider`: Fetches the JSON data. Contains `StateProviders` for search queries and tag selection. Combines them into a filtered reactive list.
- `PlayerNotifier`: Manages a complex `PlayerState` entirely reacting to user actions. It controls the `just_audio` player, runs the active session timer, and calculates progress.
- `JournalNotifier`: Handles saving reflections and fetching history from the Hive repository aggressively updating state.

### How Data Flows (from Repository → Controller → UI)
1. **Repository layer**: `AmbienceRepository` loads list from JSON. `JournalRepository` reads/writes to Hive.
2. **Controller/Notifier layer**: e.g., `PlayerNotifier` starts a session, ticks a timer, and updates `PlayerState`. It simultaneously triggers `SessionRepository` to save state.
3. **UI layer**: Screens are `ConsumerWidget`s. `SessionPlayerScreen` runs `ref.watch(playerProvider)`. Whenever the elapsed time ticks or play/pause is toggled, only the necessary UI widgets rebuild.

## Packages Used

| Package | Reason for Choice |
|---------|-------------------|
| **flutter_riverpod** | Predictable, compile-safe, testable state management. Ideal for complex reactive flows (like search + filter filtering). |
| **just_audio** | Reliable cross-platform audio playback. Chosen for its seamless `LoopMode.one` which is critical for smooth ambient loops. |
| **audio_session** | Manages OS-level audio focus (pausing other media, respecting system volumes). |
| **hive_flutter** | Extremely fast and lightweight NoSQL key-value store for local persistence. Ideal for simple schemas like journal entries and single-object session state storage. |
| **go_router** | Declarative navigation system. Crucial for implementing the `ShellRoute`, which allows the mini-player to persist across Home and Detail screens while sharing the same navigation stack. |
| **google_fonts** | Premium typography (Inter) without managing local font asset files in early development stages. |

## Bonus Features Implemented
* **Dark mode support**: Full dynamic theming using `ColorScheme.fromSeed` to swap seamlessly between bespoke Light and Dark theme tokens.
* **Complex UI Animation**: Implemented a mathematically driven, dependency-free "breathing gradient" on the player screen to simulate calm inhales and exhales using `TweenAnimationBuilder`.

## Tradeoffs & Future Improvements

If I had two more days, I would improve:
1. **Audio Transitions**: Implement smooth crossfades (fade-in on play, fade-out on pause/end) using `just_audio` volume tweens instead of abrupt stops.
2. **App Lifecycle Handling**: Implement `WidgetsBindingObserver` to pause the session timer perfectly and relinquish hardware audio decode resources if the user backgrounds the app for extended periods. (Currently, the state persists locally but background timing requires a foreground service on Android).
3. **Unit & Widget Tests**: Add comprehensive test coverage using `riverpod_test` to mock repositories and verify the exact timing/state emissions of `PlayerNotifier`.
4. **Custom Code Generation**: Hand-wrote Hive TypeAdapters to skip `build_runner` for speed; in production, I would use code generation (`freezed` and `hive_generator`) to avoid tedious boilerplate.

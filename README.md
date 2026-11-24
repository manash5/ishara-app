# Ishara

**Learn Nepali Sign Language (NSL) in short, game-like lessons.**

Ishara ("इशारा", *gesture* or *sign*) is an Android app built with Flutter. It works like Duolingo but teaches
sign language. You watch short sign videos and answer recognition exercises. Then you sign into the front camera,
and the app checks your handshape and movement on your phone.

The app is made first for **Deaf and hard-of-hearing learners**, and it never uses sound. All feedback is visual,
with optional haptics.

> **Status:** in active development. The app runs against a built-in mock API. The real backend
> (the sister repo `ishara-systems`) is still being built. Sign descriptions are
> placeholders until they are checked against the NDFN NSL dictionary.

---

## What you can do in the app

| | |
| --- | --- |
| **Learn path** | A roadmap of units and lessons with Danu the Danphe (Himalayan monal), Ishara's mascot. |
| **Lessons** | Six exercise types: *watch*, *recognise* (video → meaning), *pick the sign* (meaning → video), *match pairs*, *sign it* (camera) and *fingerspell* (camera). |
| **On-device sign checking** | The front camera finds your hand with MediaPipe. Signs are compared with reference recordings using dynamic time warping, and fingerspelled letters are classified on the phone. |
| **Practice** | Free camera practice, including fingerspelling offline. |
| **Dictionary** | Browse the signs you've learned, with slow-motion and mirrored video. |
| **Game layer** | XP, daily streak, daily goal, hearts (5; a camera mistake never costs one), and a weekly leaderboard. |
| **Offline-friendly** | Progress is cached and queued, and syncs when you're back online. |

Scope of the first version: the fingerspelling alphabet and 10–15 greeting and etiquette signs.

## Privacy

Camera frames and hand landmarks **never leave the phone's memory**. They are never saved, uploaded or logged.
All sign recognition happens on the device.

---

## Tech stack

- **Flutter** (Material 3), Android, minSdk 24
- **Riverpod 3** with code generation · **go_router** (typed routes, `StatefulShellRoute`)
- **dio** for the REST API (`/api/v1`, including auth) · tokens in **flutter_secure_storage**
- **hive_ce** for the cache and the offline sync queue · **connectivity_plus**
- **freezed** / **json_serializable** for models
- **camera** + **hand_landmarker** (MediaPipe) + **tflite_flutter** for recognition
- **mocktail** and Flutter's test tools for tests

## Project structure

The code uses feature-first clean architecture:

```
lib/
  core/                 config, error (Result<T>), theme, router, services (api, connectivity, storage), shared widgets
  features/<feature>/
    domain/             entities, repository interfaces, use cases (pure Dart, no Flutter or plugins)
    data/               DTOs, remote / local data sources, repository implementations
    presentation/       screens, widgets, Riverpod providers
assets/
  mock_api/             JSON fixtures served by the mock API
  mascot/, icons/, ...  artwork exported from Figma
docs/api-contract.md    REST contract the backend implements
test/                   mirrors lib/
```

Features: `auth`, `onboarding`, `learn`, `lesson`, `practice`, `recognition`, `dictionary`, `gamification`,
`ranks`, `profile`, `settings`.

Layer rules:
- Dependencies go `presentation → domain ← data`.
- Widgets only talk to Riverpod providers, never to dio, Hive or plugins directly.
- Repositories return a sealed `Result<T>`, so users never see raw error text.
- Plugins (camera, hand landmarker, TFLite) sit behind interfaces, so tests use fakes.

---

## Getting started

### Requirements

- Flutter (stable channel, Dart SDK ^3.14)
- An Android device or emulator (API 24+). Camera exercises need a real device with a front camera.

### Setup

```bash
git clone https://github.com/manash5/ishara-app.git
cd ishara-app
flutter pub get

# Create your local config (env/*.json is git-ignored)
cp env/example.json env/dev.json

flutter run --dart-define-from-file=env/dev.json
```

### Configuration

All config is passed with `--dart-define` and read only in `lib/core/config/`. The app never contains secrets.

| Key | Default | Meaning |
| --- | --- | --- |
| `USE_MOCK_API` | `true` | Serve `assets/mock_api/` fixtures instead of calling a server |
| `API_BASE_URL` | `http://10.0.2.2:8088/api/v1` | Backend URL (`10.0.2.2` is the host machine from the Android emulator) |
| `GOOGLE_WEB_CLIENT_ID` | empty | OAuth web client ID for Google sign-in |

With the mock API, any email and password log in. The test cases are listed in
[`docs/api-contract.md`](docs/api-contract.md); for example, `wrong@ishara.test` returns a 401.

### Useful commands

```bash
dart run build_runner build --delete-conflicting-outputs   # after changing providers or models
flutter analyze                                            # must report 0 issues
dart format .
flutter test                                               # add --coverage for a report
```

In debug builds, `/gallery` opens a gallery of every shared widget in light and dark themes.

---

## Design

The Figma file is the source of truth for every screen and component. In code, colours, spacing, text styles and
motion come from theme tokens in `lib/core/theme/`, and shared widgets live in `lib/core/widgets/`. There are no
hard-coded colours or sizes. Every screen supports dark mode, 1.3× text scale, screen readers and reduced motion.

## Contributing

- **Branches:** `main` ← `Development` ← `feature/<area>-<description>` or `fix/<...>`
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/), e.g. `feat(lesson): add match pairs`
- Generated `*.g.dart` and `*.freezed.dart` files are committed.
- Every change ships with tests. `flutter analyze` and `flutter test` must pass.
- If you change an API fixture's shape, update [`docs/api-contract.md`](docs/api-contract.md) as well.
- Use "Deaf" or "hard of hearing", never "deaf and mute". Never invent NSL sign descriptions; they must come from a
  verified source.

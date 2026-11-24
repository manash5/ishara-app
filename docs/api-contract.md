# Ishara REST API contract (`/api/v1`)

This is the spec `ishara-systems` implements. The app runs against it today through `MockApiAdapter`
(`USE_MOCK_API=true`, the default), which serves the fixtures in [`assets/mock_api/`](../assets/mock_api/). The
fixtures and this document change together: never change a fixture's shape without updating this file.

**Contents:** [Conventions](#conventions) · [Errors](#errors) · [Shared shapes](#shared-shapes) ·
[Auth](#auth) · [Profile](#profile) · [Learn path](#learn-path) · [Lessons](#lessons) · [Progress](#progress) ·
[Signs](#signs) · [Leaderboard](#leaderboard) · [Health](#health) · [Mock behaviour](#mock-behaviour)

## Conventions

- **Base URL:** `API_BASE_URL` (e.g. `https://api.ishara.app/api/v1`). JSON in and out, `Content-Type: application/json`.
- **Naming:** keys are camelCase. Ids are UUIDs. Times are ISO-8601 UTC (`2026-11-22T09:00:00.000Z`); calendar dates are
  `YYYY-MM-DD` in the learner's timezone.
- **Envelope:** every response, success or error, is wrapped:

  ```json
  { "status": 200, "success": true, "message": "OK", "data": { }, "meta": { } }
  ```

  - `status` repeats the HTTP status. `success` is `status < 400`.
  - `message` is short and human-readable. On 400 and 422 the app shows it to the user, so write it for learners.
  - `data` is absent on errors and `null` on bodiless successes.
  - `meta` appears only on paginated lists: `{ "page": 1, "limit": 8, "total": 12, "totalPages": 2 }`. `page` is
    1-based, and `totalPages = ceil(total / limit)` (at least 1).
- **Auth:** protected endpoints need `Authorization: Bearer <accessToken>`. **Public** endpoints are
  `GET /health` and every `/auth/*` endpoint except `POST /auth/logout`.
- **Game rules:** the server is authoritative for XP, streak, hearts and leagues
  (`ishara-systems/docs/game-rules.md`; the app mirrors them in `lib/core/config/game_rules.dart`).
- **Videos:** `videoUrl` is a short-lived signed URL. Clients never cache it.

## Errors

| Status | When | App exception → failure | App behaviour |
|---|---|---|---|
| — (timeout / no connection) | network | `NetworkException` → `NetworkFailure` | retried 3× (1 s, 2 s, 3 s), then offline / error state |
| 400 | malformed or invalid input | `ValidationException(message)` → `ValidationFailure` | shows `message` |
| 401 | missing / expired / invalid token, or bad credentials | `UnauthorizedException` → `UnauthorizedFailure` | protected call: refresh once and retry; refresh fails → signed out. Auth call: shows the error |
| 404 | no such resource | `NotFoundException` → `NotFoundFailure` | "not found" state |
| 409 | conflicts with existing state | `ConflictException` → `ConflictFailure` | |
| 422 | well-formed but rejected (e.g. expired code) | `ValidationException(message)` → `ValidationFailure` | shows `message` |
| 5xx | server fault | `ServerException` → `ServerFailure` | error state; never retried |

Generic error fixtures: [`error_401.json`](../assets/mock_api/error_401.json),
[`error_404.json`](../assets/mock_api/error_404.json), [`error_500.json`](../assets/mock_api/error_500.json).

```json
{ "status": 404, "success": false, "message": "Not found." }
```

## Shared shapes

### Profile

The signed-in learner, as returned by `GET /me` and inside a session (`user`).

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `email` | string | |
| `displayName` | string | |
| `avatarUrl` | string \| null | |
| `joinedAt` | datetime | |
| `onboardingDone` | bool | false → the app runs onboarding (06–09) |
| `dailyGoalMinutes` | int | 5 / 10 / 15 / 20 (onboarding 06) |
| `dominantHand` | `"left"` \| `"right"` | |
| `timezone` | IANA string | e.g. `Asia/Kathmandu`; streak days and the league week use it |
| `stats` | [Stats](#stats) | |

### Stats

| Field | Type | Notes |
|---|---|---|
| `totalXp` | int | all-time XP (Learn StatsBar, Profile) |
| `weeklyXp` | int | XP this league week (Monday 00:00 Asia/Kathmandu) |
| `streakDays` | int | current streak |
| `longestStreakDays` | int | |
| `streakFreezes` | int | ready to use |
| `hearts` | int | 0…`maxHearts` |
| `maxHearts` | int | 5 |
| `heartsRefillAt` | datetime \| null | next +1 heart (every 4 h); null when full |
| `signsLearned` | int | |
| `cameraAccuracy` | number | 0–1 share of camera exercises signed correctly |
| `weekStart` | date | Monday of the current week |
| `weekXp` | int[7] | XP per day, Monday first; a day with XP > 0 counts as practised |
| `todayIndex` | int | 0 = Monday |

### Session

Returned by register, login, Google, refresh and reset-password.

| Field | Type | Notes |
|---|---|---|
| `accessToken` | string | send as `Bearer` |
| `refreshToken` | string | for `POST /auth/refresh`; rotated on every refresh |
| `expiresAt` | datetime | access-token expiry |
| `user` | [Profile](#profile) | |

### LessonSummary

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `unitId` | uuid | |
| `title` | string | |
| `kind` | `"lesson"` \| `"review"` | |
| `state` | `"locked"` \| `"available"` \| `"current"` \| `"completed"` | |
| `signCount` | int | |
| `minutes` | int | estimated length |

### Sign

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `name` | string | English gloss |
| `category` | `"greetings"` \| `"alphabet"` \| `"numbers"` \| `"etiquette"` \| `"questions"` | |
| `status` | `"learned"` \| `"practising"` \| `"new"` | the learner's progress |
| `videoUrl` | string \| null | signed, short-lived |
| `meaning` | string \| null | null until verified against the NDFN NSL dictionary |
| `steps` | string[] | how to form it; empty until verified |
| `etiquetteTip` | string \| null | about Deaf culture, not sign formation |

### Exercise

Discriminated by `type`. `signId` is the sign taught or tested. Text marked `verified: false` is an unverified
placeholder, and the app labels it as such.

| `type` | Fields |
|---|---|
| `watch` | `title`, `description`, `tip`, `verified` |
| `recognise` | `options` string[4], `answerIndex` (video → meaning) |
| `pickSign` | `meaning`, `answerIndex`, `optionCount` (meaning → video) |
| `matchPairs` | `words` string[], `videoOrder` int[] (`videoOrder[row]` = index into `words`) |
| `signIt` | `title`, `almostChip`, `almostHint`, `verified`, `fallback` (a `recognise` exercise) |
| `fingerspell` | `letters` string[], `meaning`, `fallback` (a `recognise` exercise) |

`fallback` replaces a camera exercise when the learner picks "Can't use the camera now".

### LessonResult

| Field | Type | Notes |
|---|---|---|
| `lessonId` | uuid | |
| `clientEventId` | uuid | echoed from the request |
| `xpEarned` | int | lesson reward (10) + 5 if no mistakes |
| `accuracy` | number | 0–1 share right first time |
| `durationSeconds` | int | |
| `newSignCount` | int | |
| `signs` | [Sign](#sign)[] | signs learned in this lesson |
| `streakExtended` | bool | true → the app shows Streak (27) |
| `streakDays` | int | streak after this lesson |
| `hearts` | int | hearts after this lesson |
| `completedAt` | datetime | |

## Auth

The API owns auth. Tokens live in the Android Keystore (`flutter_secure_storage`), never in Hive, prefs or logs.

1. `POST /auth/register`, `/auth/login` or `/auth/google` returns a [Session](#session).
2. Protected calls send the access token.
3. On a 401 the app calls `POST /auth/refresh` **once**; concurrent 401s share that call. It then saves the new
   tokens and retries each request once. A failed refresh clears the tokens and signs the learner out.

### `POST /auth/register` · public

Body: `{ email: string, password: string (min 8), displayName: string }`

| Status | `data` / message | Fixture |
|---|---|---|
| 201 | Session (`user.onboardingDone: false`) · "Account created" | [`auth/register_201`](../assets/mock_api/auth/register_201.json) |
| 409 | "An account with this email already exists." | [`auth/register_409`](../assets/mock_api/auth/register_409.json) |
| 400 | "Use at least 8 characters for your password." | [`auth/register_400`](../assets/mock_api/auth/register_400.json) |

### `POST /auth/login` · public

Body: `{ email: string, password: string }`

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | Session · "Signed in" | [`auth/login_200`](../assets/mock_api/auth/login_200.json) |
| 401 | "Wrong email or password." (never says which) | [`auth/login_401`](../assets/mock_api/auth/login_401.json) |

### `POST /auth/google` · public

Body: `{ idToken: string }`. This is a Google ID token requested with the Web client ID (`GOOGLE_WEB_CLIENT_ID`) as
`serverClientId`. The server verifies it, then creates or links the account.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | Session · "Signed in" | [`auth/google_200`](../assets/mock_api/auth/google_200.json) |
| 401 | "We couldn’t sign you in with Google. Try again." | [`auth/google_401`](../assets/mock_api/auth/google_401.json) |

### `POST /auth/refresh` · public

Body: `{ refreshToken: string }`. The refresh token rotates, so the old one stops working.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | Session · "Session refreshed" | [`auth/refresh_200`](../assets/mock_api/auth/refresh_200.json) |
| 401 | "Your session has ended. Please log in again." | [`auth/refresh_401`](../assets/mock_api/auth/refresh_401.json) |

### `POST /auth/logout` · auth

Body: `{ refreshToken: string }`. Revokes the refresh token.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | `null` · "Signed out" | [`auth/logout_200`](../assets/mock_api/auth/logout_200.json) |
| 401 | generic | [`error_401`](../assets/mock_api/error_401.json) |

### `POST /auth/forgot-password` · public

Body: `{ email: string }`. Emails a 6-digit reset code. It **always returns 200**, so it never reveals whether an
account exists.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | `null` · "If that email has an account, we’ve sent a reset code." | [`auth/forgot_password_200`](../assets/mock_api/auth/forgot_password_200.json) |

### `POST /auth/reset-password` · public

Body: `{ email: string, code: string (6 digits), newPassword: string (min 8) }`

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | Session · "Password updated" | [`auth/reset_password_200`](../assets/mock_api/auth/reset_password_200.json) |
| 422 | "That code is invalid or has expired." | [`auth/reset_password_422`](../assets/mock_api/auth/reset_password_422.json) |
| 400 | weak password (same message as register) | — |

## Profile

### `GET /me` · auth

| Status | `data` | Fixture |
|---|---|---|
| 200 | [Profile](#profile) | [`me/get_200`](../assets/mock_api/me/get_200.json) |
| 401 | generic | [`error_401`](../assets/mock_api/error_401.json) |

### `PUT /me` · auth

Body: any of `{ displayName: string, dailyGoalMinutes: int, dominantHand: "left"|"right", timezone: string }`.
Fields that are left out don't change.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | updated [Profile](#profile) · "Profile updated" | [`me/put_200`](../assets/mock_api/me/put_200.json) |
| 400 | invalid field, with a message | — |

### `DELETE /me` · auth

Deletes the account and all its data, and revokes every session.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | `null` · "Account deleted" | [`me/delete_200`](../assets/mock_api/me/delete_200.json) |

### `POST /me/onboarding` · auth

Body: `{ dailyGoalMinutes: int, dominantHand: "left"|"right", timezone: string }`. Sets `onboardingDone: true`.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | [Profile](#profile) · "Onboarding saved" | [`me/onboarding_200`](../assets/mock_api/me/onboarding_200.json) |
| 400 | invalid field, with a message | — |

## Learn path

### `GET /path` · auth

The roadmap, first unit first, with each stop's state for this learner.

`data`: `{ units: Unit[] }`.
- **Unit:** `{ id: uuid, number: int, title, color: "teal"|"mint"|"lavender"|"lime", learnedCount, totalCount,
  stops: Stop[] }`.
- **Stop:** `{ id: uuid, type: "lesson"|"review"|"chest"|"checkpoint", state: LessonSummary.state, title, lesson:
  LessonSummary | null }`. `lesson` is null for chests and checkpoints.

| Status | Fixture |
|---|---|
| 200 | [`path/get_200`](../assets/mock_api/path/get_200.json) |

## Lessons

### `GET /lessons/:id` · auth

`data`: `{ lesson: LessonSummary, exercises: Exercise[] }`. A locked lesson returns 404.

| Status | Fixture |
|---|---|
| 200 | [`lessons/get_200`](../assets/mock_api/lessons/get_200.json) |
| 404 | [`error_404`](../assets/mock_api/error_404.json) |

### `POST /lessons/:id/complete` · auth · idempotent

Body: `{ clientEventId: uuid, mistakes: int, durationSeconds: int, completedAt: datetime }`.

The app generates `clientEventId` once per attempt. A repeat with the same `clientEventId` **returns the same
result** with message "Already recorded", and awards nothing twice. Camera mistakes never count as `mistakes`.

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | [LessonResult](#lessonresult) · "Lesson completed" | [`lessons/complete_200`](../assets/mock_api/lessons/complete_200.json) |
| 200 | same LessonResult · "Already recorded" (replay) | [`lessons/complete_replay_200`](../assets/mock_api/lessons/complete_replay_200.json) |
| 404 | unknown lesson | [`error_404`](../assets/mock_api/error_404.json) |

## Progress

### `POST /progress/sync` · auth

The offline queue flush.

**Body:** `{ events: [{ clientEventId: uuid, type: "lessonComplete", lessonId: uuid, mistakes: int,
durationSeconds: int, completedAt: datetime }] }`. Events are sent oldest first.

**Response** `data`: `{ results: [{ clientEventId, status: "applied"|"duplicate"|"rejected", message: string|null,
result: LessonResult|null }] }`. There is one result per event, in the same order.
- `duplicate`: the event was already recorded, so it's safe to drop.
- `rejected`: the event can't be applied (`message` says why). It isn't retried.

| Status | Fixture |
|---|---|
| 200 | [`progress/sync_200`](../assets/mock_api/progress/sync_200.json) |

## Signs

### `GET /signs` · auth

**Query:** `page` (int, default 1), `limit` (int, default 20, max 100), `category` (Sign.category, optional),
`search` (string, optional; case-insensitive match on `name`).

**Response:** `data` is Sign[] in curated order, with pagination `meta`. The app fetches every page and searches and
filters locally.

| Case | Fixture |
|---|---|
| page 1 | [`signs/list_page1`](../assets/mock_api/signs/list_page1.json) |
| page 2 (last) | [`signs/list_page2`](../assets/mock_api/signs/list_page2.json) |
| `category=greetings` | [`signs/list_category`](../assets/mock_api/signs/list_category.json) |
| `search=thank` | [`signs/list_search`](../assets/mock_api/signs/list_search.json) |

### `GET /signs/:id` · auth

| Status | `data` / message | Fixture |
|---|---|---|
| 200 | [Sign](#sign) | [`signs/get_200`](../assets/mock_api/signs/get_200.json) |
| 404 | "Sign not found." | [`signs/get_404`](../assets/mock_api/signs/get_404.json) |

## Leaderboard

### `GET /leaderboard/weekly` · auth

The learner's league this week. It resets Monday 00:00 Asia/Kathmandu, and the app caches it for offline use.

**Response** `data`: `{ leagueName, nextLeagueName, weekNumber: int, learnerCount: int, endsAt: datetime,
promotionCount: int, xpToPromotion: int, entries: Entry[] }`.
- `entries` are sorted by `xp` descending. The top `promotionCount` move up a league.
- **Entry:** `{ rank: int, userId: uuid, displayName, avatarUrl: string|null, xp: int, isMe: bool }`. The app labels
  the `isMe` row "You".

| Status | Fixture |
|---|---|
| 200 | [`leaderboard/weekly_200`](../assets/mock_api/leaderboard/weekly_200.json) |

## Health

### `GET /health` · public

Used for the reachability check (a network link alone doesn't count as online). There is no retry.

| Status | `data` | Fixture |
|---|---|---|
| 200 | `{ status: "ok" }` | [`health/get_200`](../assets/mock_api/health/get_200.json) |

## Mock behaviour

`MockApiAdapter` (`lib/core/services/api/mock_api_adapter.dart`) maps method + path to the fixtures above, with
about 300 ms latency. Every fixture is served by a route, and `test/core/services/api/mock_api_fixtures_test.dart`
checks this and that each fixture is a valid envelope.

**Reserved values** (so error states can be tried):

| Endpoint | Value | Result |
|---|---|---|
| `POST /auth/login` | email `wrong@ishara.test` | 401 (any other email + password logs in) |
| `POST /auth/register` | email `taken@ishara.test` | 409 |
| `POST /auth/register` | password shorter than 8 characters | 400 |
| `POST /auth/google` | idToken `invalid` | 401 |
| `POST /auth/refresh` | refreshToken `expired` | 401 |
| `POST /auth/reset-password` | code `000000` | 422 |

**Behaviour the mock adds to the fixtures:**
- Sessions get fresh tokens (`mock-access-<n>`), valid for 1 h.
- `GET /lessons/:id` echoes the id.
- `/complete` and `/progress/sync` remember each `clientEventId` (replay → duplicate).
- `/signs/:id` serves the full Namaste fixture. Other known ids are built from their list entry, and unknown ids get
  `get_404`.
- The leaderboard's `endsAt` is set to now + 3 d 14 h.
- `PUT /me` echoes the changed fields.

**Simulations** (debug `/gallery` → Mock API):

| Simulation | Effect |
|---|---|
| Normal | fixtures as above |
| Offline | every request fails with a connection error |
| 401 once | tokens issued so far are rejected; the refresh succeeds and the call is retried |
| Session expired | protected calls and the refresh return 401, so the learner is signed out |
| 404 / 500 | every non-auth call returns `error_404` / `error_500` |

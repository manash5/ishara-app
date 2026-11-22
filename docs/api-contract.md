# Ishara REST API contract (`/api/v1`)

The app's view of the API that `ishara-systems` implements. While `USE_MOCK_API=true` (the default) the app serves
these shapes from `assets/mock_api/` via `MockApiAdapter`. Change a fixture's shape only together with this doc.

Each feature adds its own section and fixtures when its data layer is built; only the core endpoints are listed so far.

## Conventions

- JSON is camelCase, ids are UUIDs, times are ISO-8601 UTC (`2026-11-22T09:00:00.000Z`).
- Every response is an envelope:

  ```json
  { "status": 200, "success": true, "message": "OK", "data": { }, "meta": { } }
  ```

  `meta` appears on paginated lists only: `{ "page": 1, "limit": 20, "total": 57, "totalPages": 3 }`.
  Errors: `{ "status": 422, "success": false, "message": "Pick a daily goal" }`. `message` on 400/422 is shown to
  users, so it must be written for them.
- Protected endpoints need `Authorization: Bearer <accessToken>`. Public: `GET /health` and `/auth/*` except
  `POST /auth/logout`.

### Status → app error

| Status | `AppException` | `Failure` | App behaviour |
|---|---|---|---|
| timeout / no connection | `NetworkException` | `NetworkFailure` | retried 3× (1 s, 2 s, 3 s), then offline state |
| 400, 422 | `ValidationException(message)` | `ValidationFailure` | show `message` |
| 401 | `UnauthorizedException` | `UnauthorizedFailure` | refresh once and retry; if refresh fails → signed out |
| 404 | `NotFoundException` | `NotFoundFailure` | |
| 409 | `ConflictException` | `ConflictFailure` | |
| 5xx | `ServerException` | `ServerFailure` | not retried |

## Auth

The API owns auth. Tokens live in `flutter_secure_storage` (`accessToken`, `refreshToken`, `expiresAt`).

1. `POST /auth/register`, `/auth/login` or `/auth/google` → session (tokens + user).
2. Every protected call sends the access token.
3. On a 401 the app calls `POST /auth/refresh` once (concurrent 401s share it), saves the new tokens and retries the
   request once. A failed refresh clears the tokens and signs the user out.

| Method | Path | Body | `data` | Fixture |
|---|---|---|---|---|
| POST | `/auth/register` | `{ email, password, displayName }` | session | `auth/session.json` |
| POST | `/auth/login` | `{ email, password }` | session | `auth/session.json` |
| POST | `/auth/google` | `{ idToken }` (Google ID token; Web client ID as `serverClientId`) | session | `auth/session.json` |
| POST | `/auth/refresh` | `{ refreshToken }` | tokens | `auth/refresh.json` |
| POST | `/auth/logout` | `{ refreshToken }` | `null` | `auth/ok.json` |
| POST | `/auth/forgot-password` | `{ email }` | `null` (always 200, never reveals whether the email exists) | `auth/ok.json` |
| POST | `/auth/reset-password` | `{ token, password }` | `null` | `auth/ok.json` |

Tokens: `{ accessToken, refreshToken, expiresAt }`. Session: tokens plus
`user: { id, email, displayName, onboardingDone }`. The mock issues `mock-access-<n>` tokens that live one hour.

## Core

| Method | Path | Body | `data` | Fixture |
|---|---|---|---|---|
| GET | `/health` | — | `{ status: "ok" }` | `health.json` |
| GET | `/me` | — | profile | `me/get.json` |
| POST | `/me/onboarding` | `{ dailyGoalXp, dominantHand }` | `{ onboardingDone, dailyGoalXp, dominantHand }` | `me/onboarding.json` |

Profile: `{ id, email, displayName, avatarUrl, onboardingDone, dailyGoalXp, dominantHand ("left" | "right"),
timezone, xp, streakDays, longestStreakDays, hearts, heartsRefillAt, createdAt }`.

## Still to document (with their feature's data layer)

`PUT/DELETE /me`, `GET /path`, `GET /lessons/:id`, `POST /lessons/:id/complete` (idempotent on `clientEventId`),
`POST /progress/sync`, `GET /signs`, `GET /signs/:id`, `GET /leaderboard/weekly`.

## Mock simulations (debug `/gallery` → Mock API)

| Simulation | Effect |
|---|---|
| Normal | fixtures as above |
| Offline | every request fails with a connection error |
| 401 once | tokens issued so far are rejected; the refresh succeeds and the call is retried |
| Session expired | protected calls and the refresh return 401, so the user is signed out |
| 404 / 500 | every non-auth call fails with that status |

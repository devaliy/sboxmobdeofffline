# Chronicles Revolution — Mobile/Desktop API Reference

This documents the API built in this repo against **Section 4 (Data Contracts)** and **Section 13 (Required API Endpoints)** of `MOBILE_APP_BUILD_PROMPT.md`. Every endpoint below is implemented, migrated, routed, and covered by a passing feature test (`tests/Feature/Api/V1/MobileApiTest.php`, 13 tests / 58 assertions) — this isn't a spec to build against, it's a description of what's actually running.

Base URL: `{APP_URL}/api/v1` (e.g. `https://successbox.ng/api/v1` in production). All requests and responses are JSON except pack downloads, which are binary zip files served via redirect.

---

## 1. Authentication

Token-based via Laravel Sanctum. Register or log in to get a bearer token, then send it on every protected request:

```
Authorization: Bearer {token}
```

Public endpoints (no token required): `register`, `login`, `password/forgot`, `password/reset`, `content/manifest`, `content/{domain}/{scopeId}/pack`.

Everything else requires the header above. A missing/invalid token returns `401 Unauthorized`. An expired-but-structurally-valid token is treated the same as missing — there is no separate "refresh" flow; the client should route back to Login when it sees a 401 on a protected call, without disrupting any offline content browsing already in progress (per the build spec's Section 8 non-blocking-401 rule — that behavior lives entirely on the client, the server just returns a normal 401).

### Error shape

Validation errors (`422`):
```json
{
  "message": "The current class id field is required.",
  "errors": {
    "current_class_id": ["The current class id field is required."]
  }
}
```

Auth/authorization failures:
```json
{ "message": "The provided credentials are incorrect." }   // 401
{ "message": "Only parent/guardian accounts can link students." }   // 403
```

---

## 2. Auth endpoints

### `POST /auth/register`
Public. Rate-limited to 10 requests/minute per IP.

Request:
```json
{
  "firstname": "Ada",
  "lastname": "Lovelace",
  "email": "ada@example.com",
  "phone_number": "08010000000",
  "password": "password123",
  "user_type": "student",
  "current_class_id": 4
}
```
- `phone_number` is optional.
- `user_type` is optional and defaults to `"student"`. The only other accepted value is `"parent"`.
- `current_class_id` is **required unless `user_type` is `"parent"`** — must be a valid `classes.id`.

Response `201`:
```json
{
  "user": {
    "id": 501,
    "firstname": "Ada",
    "lastname": "Lovelace",
    "full_name": "Ada Lovelace",
    "email": "ada@example.com",
    "phone_number": "08010000000",
    "user_type": "student",
    "current_class_id": 4,
    "student_link_code": "ADL-4821",
    "points_balance": 0,
    "created_at": "2026-07-30T18:00:00+00:00"
  },
  "token": "1|abcdef1234567890..."
}
```
`student_link_code` is only ever set for `student` accounts — it's the code a parent enters in `POST /parent/link-student` (Section 6). It's generated automatically at registration; nothing further to do client-side except display it in Settings.

### `POST /auth/login`
Public. Rate-limited to 10/minute.

```json
{ "identifier": "ada@example.com", "password": "password123", "device_name": "Ada's Pixel 8" }
```
`identifier` accepts **either** an email or a phone number — the server checks both columns. `device_name` is optional (used only to label the token; defaults to `"mobile-app"`), useful if you want per-device sign-out later.

Response `200`: same shape as register (`user` + `token`). Wrong credentials → `401`.

### `POST /auth/logout` — requires auth
No body. Revokes only the token used on this request (other devices/sessions stay logged in). `200 { "message": "Logged out." }`.

### `GET /auth/me` — requires auth
Returns `{ "user": {...} }` in the same shape as register/login. Use this on app resume to confirm the cached token is still valid and refresh the cached profile.

### `POST /auth/password/forgot`
Public. Rate-limited to 5/minute.
```json
{ "email": "ada@example.com" }
```
Always responds `200 { "message": "If an account exists for that email, a reset code has been sent." }` — whether or not the email exists, to avoid leaking registered addresses. If it does exist, a 6-digit OTP is emailed and expires in **15 minutes**.

### `POST /auth/password/reset`
Public. Rate-limited to 5/minute.
```json
{ "email": "ada@example.com", "otp": "483920", "password": "newpassword123" }
```
On success (`200`), the password is changed and **every existing token for that account is revoked** — the app should treat this like a forced logout and send the user back to Login. Invalid/expired OTP → `422 { "message": "That code is invalid or has expired." }`.

---

## 3. Profile

### `PATCH /profile` — requires auth
Send only the fields you want to change:
```json
{ "current_class_id": 5, "phone_number": "08029999999" }
```
Response `200`: `{ "user": {...} }` (updated). Also accepts `firstname`, `lastname`, `email` (must remain unique).

---

## 4. Content manifest & pack downloads

These are **public** — no token needed. Content isn't account-specific, and gating downloads behind auth would just add friction to Setup for no security benefit.

### `GET /content/manifest`
```json
{
  "generated_at": "2026-07-30T18:58:19+00:00",
  "packs": [
    {
      "domain": "study",
      "scope_type": "book",
      "scope_id": 12,
      "parent_scope_id": 3,
      "title": "JSS2 — Mathematics",
      "version": "20260730185819",
      "checksum": "sha256:9f8c1a...",
      "size_bytes": 18234112,
      "item_count": 42,
      "download_url": "https://successbox.ng/api/v1/content/study/12/pack"
    },
    {
      "domain": "assessment",
      "scope_type": "subject",
      "scope_id": 1,
      "parent_scope_id": null,
      "title": "Mathematics",
      "version": "20260730185819",
      "checksum": "sha256:1a2b3c...",
      "size_bytes": 3175,
      "item_count": 50,
      "download_url": "https://successbox.ng/api/v1/content/assessment/1/pack"
    }
  ]
}
```
Poll this on app start when online (and from the "Manage downloaded content" screen) — compare each pack's `version`/`checksum` against what's already installed locally to decide what's new or changed.

### `GET /content/study/{scopeId}/pack` and `GET /content/assessment/{scopeId}/pack`
`scopeId` is `library_book_id` for study, `subject_id` for assessment (matches `scope_id` in the manifest). Returns a **302 redirect** to the actual zip file on public storage — the server never proxies the file through PHP, so the redirected URL supports HTTP `Range` requests natively for resumable downloads. Follow the redirect and download from there; don't hardcode the redirected URL since it changes every time the pack is rebuilt (it's versioned by filename).

`404` if that scope has never been built (i.e. isn't in the manifest yet).

**Zip contents**, exactly as specified in the build prompt's Section 4.5:
```
pack.json
images/
  books/{filename}       -- study only
  subjects/{filename}     -- study only
  questions/{filename}    -- both domains
```
`pack.json`'s `image`/`cover_image` fields are paths relative to `images/` inside the zip (e.g. `"questions/9001.jpg"`) — rewrite them to your local storage layout at import time.

**Client-side checklist per pack:**
1. Download to a temp location (support resume via `Range` if the download drops).
2. Verify the downloaded file's SHA-256 matches the manifest's `checksum` (format: `sha256:<hex>`) before touching the local DB.
3. Unzip, batch-insert `pack.json` into your local content DB, copy `images/*` into your app's local storage — all inside one transaction per pack.
4. Only after that transaction commits, delete the temp zip and record the pack as installed.

One real detail worth knowing: **flagged questions are already excluded server-side.** The pack builder drops any assessment question with `is_flagged = true` before it ever reaches `pack.json` — the client schema doesn't need an `is_flagged` field at all, and never will see one.

---

## 5. Sync — requires auth

Upload-only in this version: the client is the source of truth for its own activity; the server stores a copy for parent-facing analytics. Every sync call is **idempotent** — safe to retry the exact same payload after a dropped connection.

### `POST /sync/practice-attempts`
```json
{
  "attempts": [
    {
      "id": "c3f1e2a0-6b1d-4e3a-9c2f-1a2b3c4d5e6f",
      "source_type": "assessment",
      "subject_id": 1,
      "library_subject_id": null,
      "test_type_id": 3,
      "score": 32,
      "total_questions": 40,
      "time_spent_seconds": 2280,
      "started_at": "2026-07-29T08:00:00Z",
      "completed_at": "2026-07-29T08:38:00Z",
      "answers": [
        {
          "id": "a1b2c3d4-1111-2222-3333-444455556666",
          "question_id": 30021,
          "question_source": "assessment",
          "selected_option": "B",
          "is_correct": true,
          "time_spent_seconds": 34
        }
      ]
    }
  ]
}
```
- `id` on each attempt/answer must be a **client-generated UUID v4**. Reusing the same `id` on retry updates the same row rather than duplicating it.
- `source_type: "assessment"` → set `subject_id`, leave `library_subject_id` null. `source_type: "library"` → the reverse.
- `answers` can be an empty array if you don't need per-question detail synced (only the attempt-level score matters for the parent analytics view either way).

Response `200`:
```json
{ "results": [ { "id": "c3f1e2a0-6b1d-4e3a-9c2f-1a2b3c4d5e6f", "status": "synced" } ] }
```
Each item in `attempts` gets its own entry in `results`, so a partial failure in a batch doesn't lose the rest — check each `status` (`"synced"` or `"error"`) and only clear the corresponding row from your local outbox on `"synced"`.

### `POST /sync/reading-progress`
```json
{
  "progress": [
    { "library_subject_id": 101, "percent_complete": 80, "last_position": "section-3", "last_opened_at": "2026-07-29T09:10:00Z" }
  ]
}
```
Upserted per `(account, library_subject_id)` — the latest call always wins, there's no history kept. Response: `{ "results": [ { "id": 101, "status": "synced" } ] }` (keyed by `library_subject_id`, not a UUID, since there's nothing to deduplicate by ID here).

### `GET /sync/status`
```json
{
  "practice_attempts": { "count": 14, "last_received_at": "2026-07-30T09:12:00+00:00" },
  "reading_progress": { "count": 6, "last_received_at": "2026-07-29T21:03:00+00:00" }
}
```
Useful for a "last synced" indicator that survives a reinstall (Settings can call this once after login instead of trusting purely local state).

---

## 6. Parent/guardian — requires auth, parent accounts only

Every endpoint in this section `403`s for a non-parent account (`{ "message": "Only parent/guardian accounts can link students." }` or similar).

### `POST /parent/link-student`
```json
{ "student_link_code": "ADL-4821" }
```
The code comes from the student's own Settings screen (returned as `student_link_code` on their user object — see Section 2). Linking is idempotent — linking the same student twice doesn't create a duplicate. Response `201 { "student": {...} }`.

### `GET /parent/children`
```json
{ "children": [ { "id": 501, "firstname": "Ada", ... } ] }
```

### `GET /parent/children/{childId}/analytics`
`404`s if that student isn't linked to the calling parent (deliberately — this also prevents one parent probing another's children by guessing IDs).
```json
{
  "student": { "id": 501, "firstname": "Ada", "... ": "..." },
  "total_attempts": 14,
  "average_score_percent": 78.5,
  "current_streak_days": 3,
  "longest_streak_days": 9,
  "last_active_at": "2026-07-30T19:00:00+00:00",
  "accuracy_by_subject": [
    { "subject_id": 1, "attempts": 6, "accuracy_percent": 82.0 }
  ],
  "accuracy_by_library_subject": [
    { "library_subject_id": 101, "attempts": 3, "accuracy_percent": 66.7 }
  ],
  "recent_attempts": [
    { "id": "c3f1e2a0-...", "source_type": "assessment", "subject_id": 1, "library_subject_id": null, "score": 32, "total_questions": 40, "completed_at": "2026-07-29T08:38:00+00:00" }
  ]
}
```
`current_streak_days`/`longest_streak_days` are computed **server-side from synced attempt dates** — this is intentionally separate from whatever streak the student's own device shows locally (that one factors in reading activity too and is computed offline); they'll usually agree but aren't guaranteed to be pixel-identical, and that's fine — this endpoint's number is what the parent sees, and it's honest about only reflecting what's actually been synced.

---

## 7. What the backend team still owns (not covered by "make the endpoints work")

- **Content publishing → pack rebuild.** Right now, packs are built on demand by running `php artisan content:build-pack {study|assessment} {scopeId|all}` from the CLI. Wiring this to fire automatically when ContentAdmin publishes/edits content (a queued job on save, or a scheduled `content:build-pack study all` / `content:build-pack assessment all` in `routes/console.php`) is the one piece of "Section 12 pipeline" that's still a manual step today, by design — automating it safely depends on decisions about ContentAdmin's save flow that weren't part of this task.
- **Mail delivery for OTPs.** `forgotPassword` sends via `Mail::raw()` with a plain-text message using whatever `MAIL_MAILER` is configured — functionally complete, but no branded email template. Swap in a proper Mailable when there's a design for it.
- **Parent registration surface.** `POST /auth/register` with `user_type: "parent"` works today, but nothing in the existing web app exposes a parent-facing sign-up flow yet — that's a product surface, not an API gap.

## 8. Verifying it yourself

```
php artisan test tests/Feature/Api/V1/MobileApiTest.php
```
13 tests, 58 assertions, covering: registration (student + parent, including the class-required validation), login by email and by phone, token invalidation on logout, the full forgot/reset-password OTP flow, manifest + pack download for both domains (including confirming flagged questions are excluded), idempotent sync retries for both practice-attempts and reading-progress, and the full parent-link → children → analytics flow including the 403 a student gets if they try to hit parent-only routes.

To generate a real pack against your local data and eyeball the output:
```
php artisan content:build-pack study all
php artisan content:build-pack assessment all
```
This requires `php artisan storage:link` to have been run once (so `content-packs/...` is web-servable) — already the case in this environment, worth confirming on any new one.

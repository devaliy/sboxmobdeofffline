# Chronicles Revolution — Offline Study & CBT App

## Full Build Specification & Operating Brief for Claude Code

Paste this entire document as your opening prompt to Claude Code in a **new, empty project directory**. It is written to be self-contained: it explains the mission, the philosophy, the exact data model, the tech stack, and a phase-by-phase task list with acceptance criteria. Work through the phases in order. Do not skip ahead. After each phase, run `flutter analyze` and relevant tests, fix all errors, and report what was built before moving on.

---

## 0. Mission

Build **one Flutter application** — small to install from the Play Store/App Store/Windows/macOS, containing **no question or content data at all in the binary** — that a Nigerian secondary-school / JAMB-WAEC-NECO candidate installs, registers/logs into (against the existing Chronicles Revolution backend — "this exact version"), and then uses a one-time **Setup screen** to download exactly the content they need: **Study Center content and Assessment content are two independent, separately downloadable content packs**, chosen and sized by the student, not bundled by the developer.

Once content is downloaded, the app behaves exactly like the original offline-first design: browsing, reading, and taking practice tests never touch the network again. The only network-dependent moments are: **registration/login**, the **content pack download(s)** in Setup, and **background activity sync** afterward — all three are deliberate, expected exceptions to "offline"; everything else is not.

### Why this replaces the build-time-preload approach
The original plan baked the entire question bank + all images into the Flutter app bundle at build time. That doesn't scale: Play Store base-APK limits, a large install for students who only need one class/subject, and every content update requiring a full app re-release. Downloading scoped, versioned packs after login solves all three, and costs almost nothing extra in UX since login already requires connectivity.

### Explicit non-goals (do not build these)
- No admin dashboard, CMS, or content-editing UI of any kind — content is authored/published on the existing web backend (ContentAdmin), never edited from this app.
- No payments, no referrals, no chat/messaging, no multi-school/state tenancy UI.
- No offline account creation, and no offline *first* content download — both require connectivity by definition. Everything after that must work offline.
- Do not build the backend API itself as part of this app's codebase — the backend team owns and ships the API in Section 13 separately. Build the Flutter app against that documented contract, using a local mock/stub server during development if the real API isn't live yet.

---

## 1. Design Philosophy

1. **Nothing is preloaded; everything the student chooses becomes permanently offline.** The app ships empty. Setup is a first-class, well-designed screen — not an apologetic loading bar — because for many students it's the first real impression of the app.
2. **Study and Assessment are peers, not a bundle.** A student cramming for JAMB next week shouldn't be forced to download the entire Study Center library, and a junior-secondary student building foundational knowledge shouldn't be forced to download past-question banks for exams they're not sitting yet. Every download decision is scoped and explicit.
3. **Built for the device the student actually owns.** Assume a budget Android phone (2–3GB RAM, mid-tier or slow storage) on a metered mobile-data connection for the download itself: resumable downloads, a visible size estimate before committing, and a Wi-Fi-only default.
4. **Once downloaded, it behaves as if it were always there.** No "checking connection" flicker, no degraded offline mode — content screens read local SQLite exclusively and don't know or care whether the device is online.
5. **Exam mode feels like an exam.** The CBT/practice-test screen is calm, focused, and free of navigation chrome: a timer, a question, options, a question-palette drawer, and nothing else. No sync or connectivity indicators visible during an active test.
6. **Sync is felt, not seen.** A small, calm status line ("Synced just now" / "3 results waiting to sync") belongs on Home/Settings. It never interrupts, never blocks navigation, and failure to sync is silent-retry, not an error dialog.
7. **Motivation lives outside the test, not inside it.** Points, streaks, and progress bars belong on Home and Progress — never inside an active exam session.
8. **One design system, two densities.** Mobile uses bottom navigation and single-column layouts; desktop/tablet reuses the same widgets in a two-pane layout above a width breakpoint. Branch by `LayoutBuilder`/breakpoint, not by platform check.
9. **Respect the content's origin.** Study content (`library_contents`) is CKEditor-authored HTML — render it faithfully rather than stripping to plain text.

---

## 2. Source Data Model (what gets packaged for download)

The source of truth is the existing Laravel/MySQL app (ContentAdmin). The backend team builds the pack-export pipeline (Section 13) against these tables — the Flutter app never talks to MySQL directly, only to the pack-download API.

### Assessment domain (practice tests / past questions)
```
subjects        (id, name, ...)
categories      (id, cat_name)
years           (id, subject_id, yearname)              -- exam year, e.g. "2019"
test_types      (id, test_type_name, duration, num_of_questions, subject_id, assoc_cat_id, class_id)
passages        (id, title, year_id, test_id, passage)  -- comprehension passages shared by multiple questions
questions       (id, subject_id, category_id, year_id, passage_id, test_type_id,
                 questionText, image, optionA, optionB, optionC, optionD, optionE,
                 correct_option, explanation)
```
Server-side question images live under `questions/images/` (confirmed in the current codebase: `QuestionController` stores uploads via `->store('questions/images', 'public')`).

### Study Center domain (structured reading + weekly self-tests)
```
classes           (id, name, code, order, category: primary|juniorsecondary|seniorsecondary|higherinstitution)
terms             (id, name, start_date, end_date)
library_books     (id, class_id, name, image, color)
library_subjects  (id, library_book_id, term_id, title, description, cover_image, author, week,
                   num_of_test_questions, published)
library_contents  (id, library_subject_id, content)      -- HTML body, one or more per subject/week
library_questions (id, library_subject_id, question_text, image, option_a..e, correct_option, explanation)
```
Server-side study images live under **three separate folders**, all distinct from the assessment folder above: `library/books/` (book cover art), `library/subjects/` (subject/week cover images), `library/questions/` (images embedded in library quiz questions). Confirmed in `LibraryBookController`/`LibrarySubjectController`.

**This folder separation is intentional and carries all the way through to the device — see Section 4.**

### Account domain (relevant subset — via API only, never read directly)
```
users  (id, firstname, lastname, email, phone_number, password, current_class_id,
        user_type: student|teacher|school_owner, state_id, local_government_id, school_id, ...)
```
There is currently **no parent/guardian entity or student↔parent linkage** in the schema — a backend gap, itemized in Section 13, not something to invent client-side.

---

## 3. On-Device Storage Architecture

This is the part that changes most from a preload model, and it needs to correctly handle a scenario the old design didn't: **a single physical device may be used, over time, by more than one student account** (a shared family phone, a sibling borrowing the device, a school computer lab machine). Content is not personal — a JSS2 Mathematics pack is identical for every student in JSS2. Progress *is* personal, and mixing or leaking one student's scores into another's view would be a real trust failure for a product whose whole pitch to parents is "see your child's activity." The storage design below draws that line deliberately.

### 3.1 Content storage — device-scoped, shared across whichever accounts use this device

Two **independent** local databases, matching the two independently-downloadable domains:

- **`study_content.sqlite`** — `classes`, `terms`, `library_books`, `library_subjects`, `library_contents`, `library_questions` (renamed `snake_case`), plus an `installed_study_packs` table (`scope_type: class|book`, `scope_id`, `version`, `checksum`, `size_bytes`, `installed_at`) recording exactly what's been downloaded so far.
- **`assessment_content.sqlite`** — `subjects`, `categories`, `years`, `test_types`, `passages`, `questions`, plus an `installed_assessment_packs` table (`scope_type: subject`, `scope_id`, `version`, `checksum`, `size_bytes`, `installed_at`).

Both are **additive and incremental**: downloading a new class's Study pack or a new subject's Assessment pack inserts rows into the existing file, it doesn't replace it. Both persist across login/logout — if a second student on the same device needs a pack the first student already downloaded, it's already there, no re-download.

Images mirror the server's folder separation exactly, kept as physically separate directory trees so an entire domain can be freed without touching the other:
```
<app documents dir>/
  content/
    study/
      images/
        books/          -- from server library/books
        subjects/        -- from server library/subjects (cover images)
        questions/        -- from server library/questions
    assessment/
      images/
        questions/        -- from server questions/images
```
`library_books.image`, `library_subjects.cover_image`, `library_questions.image`, and `questions.image` are rewritten at import time from server paths to these local relative paths.

### 3.2 Progress storage — one database per logged-in account, never shared

- **`users/{user_id}/progress.sqlite`** — a physically separate file per account (not a shared file with a `user_id` filter column). This is the safer default for a parent-visible analytics product: it makes cross-account leakage structurally impossible rather than dependent on every query remembering a `WHERE user_id = ?` clause, and it makes "does this device have this student's history" a trivial file-existence check.
- Tables: `practice_attempts`, `practice_answers`, `reading_progress`, `local_stats`, `sync_outbox` — exact column-level schema in **Section 4.3**.
- **Secure session storage** (`flutter_secure_storage`, not SQLite): the current bearer token and the active `user_id`, which is what selects which `progress.sqlite` file to open.

### 3.3 Account switching behavior on a shared device
- **Login**: look for `users/{user_id}/progress.sqlite`. If it exists (this student has used this device before), open it as-is — their history is intact, nothing re-downloads. If not, create it fresh.
- **Logout**: attempt a final sync flush if online. If items remain unsynced (because offline), do **not** delete or block — leave the file exactly as is, keyed to that `user_id`, and surface a clear one-line warning ("You have unsynced results — they'll upload next time you're online and signed in"). Content databases (`study_content.sqlite`, `assessment_content.sqlite`) are never touched by logout.
- **Switching to a different account on the same device**: same as login above — each account's progress is fully isolated, content stays shared.

---

## 4. Data Contracts — Exact Local Schemas & API Payload Shapes

This section is the binding contract between the backend and the app. The backend must produce exactly these payload shapes; the app must store exactly these local schemas. Nothing in Sections 6–11 should be read as overriding this section — if a screen spec seems to imply a different field, this section wins and the screen spec is wrong.

**Ground rule:** content tables keep the **server's integer IDs as their local primary keys** (not client UUIDs) — content is server-authoritative and read-only on device, so reusing server IDs means a `question_id` or `library_subject_id` referenced later in a sync payload (Section 4.6) is unambiguous and never needs translation. Only the new, device-invented **progress** rows (Section 4.3) use client-generated UUIDs, because those are the rows a retryable sync needs to upsert idempotently.

### 4.1 `study_content.sqlite`

```
classes (
  id                 INTEGER PRIMARY KEY,   -- server classes.id, unchanged
  name               TEXT NOT NULL,
  code               TEXT NULL,
  sort_order         INTEGER NOT NULL,      -- server `order`
  category           TEXT NOT NULL          -- 'primary' | 'juniorsecondary' | 'seniorsecondary' | 'higherinstitution'
)

terms (
  id                 INTEGER PRIMARY KEY,   -- server terms.id
  name               TEXT NOT NULL,
  start_date         TEXT NOT NULL,         -- ISO 8601 date
  end_date           TEXT NOT NULL
)

library_books (
  id                 INTEGER PRIMARY KEY,   -- server library_books.id
  class_id           INTEGER NOT NULL REFERENCES classes(id),
  name               TEXT NOT NULL,
  image_path         TEXT NULL,             -- rewritten to content/study/images/books/{filename}
  color              TEXT NOT NULL
)

library_subjects (
  id                     INTEGER PRIMARY KEY,   -- server library_subjects.id
  library_book_id        INTEGER NOT NULL REFERENCES library_books(id),
  term_id                INTEGER NOT NULL REFERENCES terms(id),
  title                  TEXT NOT NULL,
  description            TEXT NULL,
  cover_image_path       TEXT NULL,             -- rewritten to content/study/images/subjects/{filename}
  author                 TEXT NOT NULL,
  week                   INTEGER NOT NULL,
  num_of_test_questions  INTEGER NOT NULL
)
-- note: server's `content_status`/`published` flags are not shipped — the pack export only ever
-- includes published, ready content, so the client schema doesn't need to represent draft states.

library_contents (
  id                 INTEGER PRIMARY KEY,   -- server library_contents.id
  library_subject_id INTEGER NOT NULL REFERENCES library_subjects(id),
  content_html       TEXT NOT NULL           -- server `content`, raw CKEditor HTML, unmodified
)

library_questions (
  id                 INTEGER PRIMARY KEY,   -- server library_questions.id
  library_subject_id INTEGER NOT NULL REFERENCES library_subjects(id),
  question_text      TEXT NOT NULL,
  image_path         TEXT NULL,             -- rewritten to content/study/images/questions/{filename}
  option_a           TEXT NOT NULL,
  option_b           TEXT NOT NULL,
  option_c           TEXT NOT NULL,
  option_d           TEXT NOT NULL,
  option_e           TEXT NULL,
  correct_option     TEXT NOT NULL,
  explanation        TEXT NULL
)

installed_study_packs (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,   -- local-only, not from server
  scope_type         TEXT NOT NULL,          -- 'class' | 'book'
  scope_id           INTEGER NOT NULL,       -- class_id or library_book_id, per scope_type
  version            TEXT NOT NULL,          -- from manifest, opaque string (hash or timestamp)
  checksum           TEXT NOT NULL,
  size_bytes         INTEGER NOT NULL,
  installed_at       TEXT NOT NULL
)
```

### 4.2 `assessment_content.sqlite`

```
subjects (
  id                 INTEGER PRIMARY KEY,   -- server subjects.id
  name               TEXT NOT NULL
)

categories (
  id                 INTEGER PRIMARY KEY,   -- server categories.id
  cat_name           TEXT NOT NULL
)

years (
  id                 INTEGER PRIMARY KEY,   -- server years.id
  subject_id         INTEGER NOT NULL REFERENCES subjects(id),
  year_name          TEXT NOT NULL          -- server `yearname`
)

test_types (
  id                 INTEGER PRIMARY KEY,   -- server test_types.id
  test_type_name     TEXT NOT NULL,
  duration_minutes   INTEGER NOT NULL,      -- server `duration`
  num_of_questions   INTEGER NOT NULL,
  subject_id         INTEGER NULL REFERENCES subjects(id),
  assoc_category_id  INTEGER NULL REFERENCES categories(id)
  -- server's class_id/admin_id/passcode are not shipped — irrelevant to an offline solo practice session
)

passages (
  id                 INTEGER PRIMARY KEY,   -- server passages.id
  title              TEXT NULL,
  year_id            INTEGER NULL,
  passage_text       TEXT NOT NULL          -- server `passage`
)

questions (
  id                 INTEGER PRIMARY KEY,   -- server questions.id
  subject_id         INTEGER NOT NULL REFERENCES subjects(id),
  category_id        INTEGER NOT NULL REFERENCES categories(id),
  year_id            INTEGER NOT NULL REFERENCES years(id),
  passage_id         INTEGER NULL REFERENCES passages(id),
  test_type_id       INTEGER NULL REFERENCES test_types(id),
  question_text      TEXT NOT NULL,         -- server `questionText`
  image_path         TEXT NULL,             -- rewritten to content/assessment/images/questions/{filename}
  option_a           TEXT NOT NULL,         -- server `optionA`
  option_b           TEXT NOT NULL,
  option_c           TEXT NOT NULL,
  option_d           TEXT NOT NULL,
  option_e           TEXT NULL,
  correct_option     TEXT NOT NULL,
  explanation        TEXT NULL
)
-- note: server's `is_flagged`/`flag_comment` are moderation fields — the pack export excludes any
-- question with is_flagged = true entirely, so the client schema has no flag column at all.

installed_assessment_packs (
  id                 INTEGER PRIMARY KEY AUTOINCREMENT,   -- local-only
  scope_type         TEXT NOT NULL,          -- 'subject' (only granularity for this domain, see 4.4)
  scope_id           INTEGER NOT NULL,       -- subject_id
  version            TEXT NOT NULL,
  checksum           TEXT NOT NULL,
  size_bytes         INTEGER NOT NULL,
  installed_at       TEXT NOT NULL
)
```

### 4.3 `progress.sqlite` (one file per account, per Section 3.2)

```
practice_attempts (
  id                   TEXT PRIMARY KEY,     -- client-generated UUID
  source_type          TEXT NOT NULL,        -- 'assessment' | 'library'
  subject_id           INTEGER NULL,         -- set when source_type = 'assessment'
  library_subject_id   INTEGER NULL,         -- set when source_type = 'library'
  test_type_id         INTEGER NULL,
  score                INTEGER NOT NULL,
  total_questions      INTEGER NOT NULL,
  time_spent_seconds   INTEGER NOT NULL,
  started_at           TEXT NOT NULL,
  completed_at         TEXT NOT NULL,
  synced_at            TEXT NULL
)

practice_answers (
  id                   TEXT PRIMARY KEY,     -- client-generated UUID
  attempt_id           TEXT NOT NULL REFERENCES practice_attempts(id),
  question_id          INTEGER NOT NULL,     -- references questions.id or library_questions.id, per question_source
  question_source      TEXT NOT NULL,        -- 'assessment' | 'library'
  selected_option      TEXT NULL,
  is_correct           INTEGER NOT NULL,     -- 0/1
  time_spent_seconds   INTEGER NOT NULL
)

reading_progress (
  id                   TEXT PRIMARY KEY,     -- client-generated UUID
  library_subject_id   INTEGER NOT NULL,
  last_position        TEXT NULL,
  percent_complete     INTEGER NOT NULL,
  last_opened_at       TEXT NOT NULL,
  synced_at            TEXT NULL
)

local_stats (
  id                   INTEGER PRIMARY KEY CHECK (id = 1),  -- single-row table
  total_points         INTEGER NOT NULL DEFAULT 0,
  current_streak_days  INTEGER NOT NULL DEFAULT 0,
  longest_streak_days  INTEGER NOT NULL DEFAULT 0,
  last_active_date     TEXT NULL
)

sync_outbox (
  id                   TEXT PRIMARY KEY,     -- client-generated UUID
  entity_type          TEXT NOT NULL,        -- 'practice_attempt' | 'reading_progress'
  entity_id            TEXT NOT NULL,        -- FK into the relevant table above, by its own id
  payload_json         TEXT NOT NULL,        -- pre-serialized, see 4.6 — built once at enqueue time
  created_at           TEXT NOT NULL,
  attempt_count        INTEGER NOT NULL DEFAULT 0,
  last_attempted_at    TEXT NULL,
  status               TEXT NOT NULL DEFAULT 'pending'  -- 'pending' | 'synced' | 'failed'
)
```

### 4.4 Pack manifest — `GET /content/manifest`

```json
{
  "generated_at": "2026-07-29T10:00:00Z",
  "packs": [
    {
      "domain": "study",
      "scope_type": "book",
      "scope_id": 12,
      "parent_scope_id": 3,
      "title": "JSS2 Mathematics",
      "version": "20260720-1000",
      "checksum": "sha256:9f8c...",
      "size_bytes": 18234112,
      "item_count": 42,
      "download_url": "/api/v1/content/study/12/pack"
    },
    {
      "domain": "assessment",
      "scope_type": "subject",
      "scope_id": 7,
      "parent_scope_id": null,
      "title": "Physics",
      "version": "20260718-0930",
      "checksum": "sha256:1a2b...",
      "size_bytes": 42011904,
      "item_count": 1560,
      "download_url": "/api/v1/content/assessment/7/pack"
    }
  ]
}
```
Study packs are scoped per **book** (`parent_scope_id` = the book's `class_id`, used only to group books under a class heading in Setup's UI — it is not a separately downloadable scope). Assessment packs are scoped per **subject**. `item_count` is questions for assessment, and (subjects + contents + questions) for study — used purely for the human-readable size estimate in Setup, not for validation.

### 4.5 Pack download payload (inside the downloaded zip)

**Format decision: JSON, not a server-built SQLite file.** JSON is trivial to produce from Eloquent models server-side and trivial to batch-insert client-side via `drift`, and it avoids ever having to keep a server-side SQLite writer's schema in lockstep with the client's `drift` schema. Every pack zip has this shape:
```
pack.json
images/
  books/{filename}        -- study packs only
  subjects/{filename}      -- study packs only
  questions/{filename}     -- both domains
```

Study pack (`pack.json`, one `library_book` per zip, fully self-contained):
```json
{
  "domain": "study",
  "scope_type": "book",
  "scope_id": 12,
  "version": "20260720-1000",
  "class": { "id": 3, "name": "JSS2", "code": "JSS2", "sort_order": 2, "category": "juniorsecondary" },
  "book": { "id": 12, "class_id": 3, "name": "Mathematics", "image": "books/12.jpg", "color": "#3b82f6" },
  "terms": [ { "id": 1, "name": "First Term", "start_date": "2026-09-01", "end_date": "2026-12-10" } ],
  "subjects": [
    {
      "id": 101, "library_book_id": 12, "term_id": 1, "title": "Week 1: Algebra Basics",
      "description": "Introduction to algebraic expressions", "cover_image": "subjects/101.jpg",
      "author": "Chronicles Revolution", "week": 1, "num_of_test_questions": 10,
      "contents": [ { "id": 501, "content": "<p>...</p>" } ],
      "questions": [
        { "id": 9001, "question_text": "...", "image": "questions/9001.jpg",
          "option_a": "...", "option_b": "...", "option_c": "...", "option_d": "...", "option_e": null,
          "correct_option": "A", "explanation": "..." }
      ]
    }
  ]
}
```

Assessment pack (`pack.json`, one `subject` per zip, fully self-contained including every lookup its questions need):
```json
{
  "domain": "assessment",
  "scope_type": "subject",
  "scope_id": 7,
  "version": "20260718-0930",
  "subject": { "id": 7, "name": "Physics" },
  "categories": [ { "id": 2, "cat_name": "Objective" } ],
  "years": [ { "id": 55, "subject_id": 7, "year_name": "2019" } ],
  "test_types": [ { "id": 3, "test_type_name": "JAMB Practice", "duration_minutes": 40, "num_of_questions": 40, "subject_id": 7, "assoc_category_id": 2 } ],
  "passages": [ { "id": 12, "title": "Comprehension A", "year_id": 55, "passage_text": "..." } ],
  "questions": [
    { "id": 30021, "subject_id": 7, "category_id": 2, "year_id": 55, "passage_id": null, "test_type_id": 3,
      "question_text": "...", "image": "questions/30021.jpg",
      "option_a": "...", "option_b": "...", "option_c": "...", "option_d": "...", "option_e": null,
      "correct_option": "B", "explanation": "..." }
  ]
}
```
`image`/`cover_image` fields are paths **relative to the zip's `images/` folder**; the importer rewrites them to absolute on-device paths per Section 3.1 at import time and stores the rewritten value in `image_path`/`cover_image_path`.

### 4.6 Sync payload shapes

`POST /sync/practice-attempts` — request:
```json
{
  "attempts": [
    {
      "id": "c3f1e2a0-...",
      "source_type": "assessment",
      "subject_id": 7,
      "library_subject_id": null,
      "test_type_id": 3,
      "score": 32,
      "total_questions": 40,
      "time_spent_seconds": 2280,
      "started_at": "2026-07-29T08:00:00Z",
      "completed_at": "2026-07-29T08:38:00Z",
      "answers": [
        { "id": "a1b2...", "question_id": 30021, "question_source": "assessment",
          "selected_option": "B", "is_correct": true, "time_spent_seconds": 34 }
      ]
    }
  ]
}
```
Response — per-item ack so the client can mark individual outbox rows without treating the whole batch as one unit:
```json
{ "results": [ { "id": "c3f1e2a0-...", "status": "synced" } ] }
```

`POST /sync/reading-progress` — request:
```json
{
  "progress": [
    { "library_subject_id": 101, "percent_complete": 80, "last_position": "section-3",
      "last_opened_at": "2026-07-29T09:10:00Z" }
  ]
}
```
Response: same `{ "results": [...] }` ack shape, keyed by `library_subject_id` instead of a UUID since `reading_progress` is naturally upserted per subject rather than appended per event.

### 4.7 How the app treats this data (import/merge/removal rules)

- **Import is one transaction per pack.** All rows in `pack.json` plus the `installed_*_packs` bookkeeping row commit together, or none of it does. A crash or interruption mid-import leaves the previous state untouched and the already-downloaded zip on disk for a clean retry — never a half-populated table.
- **Shared lookup rows use upsert-by-id, not insert-or-fail.** `categories`, `terms`, `classes`, and any `years`/`test_types` that could plausibly reappear across two different subject packs are inserted with "insert or replace by primary key" semantics, because the same category/term row will legitimately show up in multiple packs and must not conflict on a second import.
- **Every pack is self-contained.** A study pack carries its own `class`/`terms` rows even though those are shared lookups (see above) precisely so a single book can be downloaded and imported with zero dependency on any other pack having been downloaded first. Same for an assessment pack carrying its own `categories`/`years`/`test_types`/`passages`.
- **Removing a pack** (Settings → Manage downloaded content) deletes only rows uniquely owned by that scope — for a study book: its `library_subjects`/`library_contents`/`library_questions` and the `library_books` row itself, plus `content/study/images/{books,subjects,questions}` files those rows referenced, plus its `installed_study_packs` row. Shared lookup rows (`classes`, `terms`) are **not** deleted, since another still-installed pack may reference them. Same logic for assessment packs and `categories`/`years`/`test_types`/`passages`.
- **Content tables are never written to by anything except the pack importer.** All other app code (Study Center, Practice/CBT) only reads from `study_content.sqlite`/`assessment_content.sqlite`. All writes from student activity go to `progress.sqlite` exclusively.

---

## 5. Tech Stack

| Concern | Choice | Why |
|---|---|---|
| Framework | **Flutter (stable channel)**, targeting Android, iOS, Windows, macOS from one codebase | single codebase, mature offline story |
| Language | Dart, null-safe | — |
| Local DBs | **drift** (`drift`, `drift_flutter`, `sqlite3_flutter_libs`), three logical databases per Section 3 | typed queries, migrations, reactive streams |
| State management | **Riverpod** (`flutter_riverpod`) | testable, no BuildContext ceremony for data access |
| Routing | **go_router** | typed routes; handles the auth-gated redirect *and* the "no content installed yet → Setup" redirect |
| HTTP client | **dio** | interceptors for auth headers, retry/timeout, and **range-request resumable downloads** for content packs |
| Auth token storage | **flutter_secure_storage** | Keychain/Keystore-backed |
| Connectivity detection | **connectivity_plus** | drives sync-outbox flushing and gates Setup's download button |
| Background sync | **workmanager** (Android) / resume + connectivity-change triggers elsewhere | reliable "sync on resume and on connectivity regained" beats a fragile background-task promise |
| Pack download/unzip | `dio` (resumable, range-header downloads) + `archive` (zip extraction) | packs are pre-built static zip files server-side (Section 13), so downloads are cacheable/CDN-friendly and trivially resumable |
| HTML rendering (Study Center content) | **flutter_html** | renders CKEditor output without a WebView |
| Math/formula rendering (only if content export shows LaTeX/MathML) | `flutter_math_fork` | skip entirely if not needed |
| Fonts/typography | `google_fonts`, bundled not fetched | must not require network for core UI |
| Charts (Progress tab) | `fl_chart` | streaks/score-over-time visuals |
| Local settings (non-sensitive) | `shared_preferences` | theme mode, font-size preference, Wi-Fi-only download toggle |
| Icons | `lucide_icons` or Material Symbols (pick one, stay consistent) | — |
| Testing | `flutter_test`, `drift`'s in-memory test DB, `dio`'s mock adapter | — |

No package beyond auth/dio/connectivity/workmanager/pack-download should ever make a network call.

---

## 6. Information Architecture

```
Splash → Auth gate:
  ├─ Not logged in → Login / Register — requires connectivity
  └─ Logged in (cached session, correct per-user progress.sqlite opened)
       └─ Content gate:
            ├─ No packs installed yet → Setup (mandatory first pass)
            └─ At least one pack installed → straight into the app, fully offline from here

Bottom nav (mobile) / left rail (desktop ≥900px width):
  ├─ Home            — greeting, streak, "continue where you left off", quick-start practice, sync status
  ├─ Study Center     — (only shows content the student has downloaded) Book → Subject(week) → Reader → quiz
  ├─ Practice/CBT     — (only shows content the student has downloaded) Subject → Test type/year → exam → results
  ├─ Progress         — score history, streaks, points, per-subject accuracy breakdown
  └─ Settings         — account, "Manage downloaded content" (re-open Setup), theme, font size, sync status
```

Study Center and Practice/CBT each have an empty state ("You haven't downloaded any [Study/Assessment] content yet — tap to add some") if the student skipped one domain in Setup, linking straight back into the relevant part of Setup/"Manage downloaded content."

---

## 7. Screen-by-Screen UX Spec

**Splash** — checks for a cached valid session, routes to Login or the content gate.

**Login / Register** — as before: email/phone + password (register also collects firstname/lastname/class/level); clear inline messaging when offline that sign-in/sign-up needs connectivity. Success stores the token + `user_id`, opens/creates that account's `progress.sqlite`.

**Setup (new, central to this redesign)**
- Framed as "Get your content" — this is not a settings screen, it's an onboarding centerpiece.
- Two independent panels/tabs: **Study Center** and **Assessment**.
  - Study panel: pick class (defaults to the class chosen at registration), see the list of `library_books` for that class with per-book size estimates, multi-select which to download (or "download all for my class").
  - Assessment panel: pick subject(s) — multi-select, each with a size estimate — optionally scoped further by exam/test type if that meaningfully changes size.
- Before any download starts: total size shown, Wi-Fi-only toggle (default **on**, with a clear "switch to allow mobile data" affordance), and a warning if the estimated size is large on a metered connection.
- During download: per-pack progress bars, pausable/resumable (a dropped connection resumes from where it left off via HTTP range requests, not from zero), retry-on-failure automatic with backoff, and a clear failure state with a manual retry button if it keeps failing.
- A student can complete Setup having downloaded only one domain (e.g., Assessment only) and skip the other — it's not all-or-nothing. Skipping is a real, supported path, not an edge case.
- Completing Setup with at least one pack installed unlocks Home. Setup remains reachable later from Settings → "Manage downloaded content" to add more classes/subjects or free storage by removing a pack (deletes its rows + its image folder subset, updates `installed_*_packs`).

**Home** — greeting + streak, "Continue studying" card, "Quick practice" card, subject shortcuts (only for downloaded content), ambient sync-status line.

**Study Center** — Book grid → Subject(week) list (grouped by term, progress bar per row) → Reader (`flutter_html`, font-size control) → "Test yourself" quiz → results/review. Writes `reading_progress` + enqueues sync. Identical to the original spec, just scoped to whatever's actually installed.

**Practice/CBT** — Subject/test-type setup → timed exam session (single question per screen, flag-for-review, question-palette drawer, countdown timer, no other chrome, no sync indicator) → results/review with per-question `explanation`. Writes `practice_attempts`/`practice_answers` + enqueues sync. Identical to the original spec, scoped to installed content.

**Progress** — streak calendar, points/attempts totals, score-over-time chart, per-subject accuracy. Reads the current account's `progress.sqlite` directly — never waits on the server.

**Settings** — Account (profile, logout with the unsynced-data warning from Section 3.3), **Manage downloaded content** (reopens Setup in management mode — add/remove packs per domain, shows storage used per domain separately since they're physically separate folders), theme, font size, Wi-Fi-only download preference, Data/version info per installed pack, Sync (last successful sync time, pending count, manual "Sync now").

---

## 8. Authentication & Sync Architecture

**Auth**
- Token-based (Laravel Sanctum), `Authorization: Bearer <token>` via a `dio` interceptor.
- On 401 from any sync/content call, don't force the student out — mark the session as needing re-login, keep offline features fully available, surface the prompt only in Settings or on a manual action. Studying and practicing are never interrupted by an expired token.
- No password or token is ever written to any `.sqlite` file or `shared_preferences` — only `flutter_secure_storage`.

**Content pack download**
- Packs are pre-built static files server-side (Section 13) — the client's job is purely download + verify + import, no client-side aggregation logic.
- Use HTTP range requests for resumability; verify the manifest's checksum after download before importing; import failures (corrupt zip, checksum mismatch) trigger a clean re-download, never a partial/corrupt local state.
- Importing a pack is a single local transaction per pack (insert rows + copy images + write the `installed_*_packs` row) so a crash mid-import can't leave the local DB half-populated — retry the whole pack import from the already-downloaded zip.

**Sync (device → server, one-directional for this version)**
- Every completed `practice_attempts` row and meaningfully-changed `reading_progress` row is written locally first, then enqueued in `sync_outbox` (inside the current account's `progress.sqlite`).
- A sync worker (app resume, connectivity regained, periodic on Android via `workmanager`) batches pending outbox rows and POSTs them to Section 13's sync endpoints.
- On success: mark `synced`, stamp `synced_at`. On failure: increment `attempt_count`, retry with backoff — never block the UI, never lose the local copy.
- Upload-only for this version: the server isn't yet a source of truth the app reads back from.

---

## 9. Visual Design System

- **Type scale**: `google_fonts`, bundled, one UI family (e.g. Inter), optionally a second serif/humanist family for long-form Study Center reading if it measurably helps.
- **Color**: single `ColorScheme.fromSeed`, light/dark, Material 3 throughout. Near-monochrome in exam mode; accent color reserved for Study Center/Progress/Home/**Setup** (Setup should feel encouraging, not clinical — it's the first real interaction with the product).
- **Spacing/radius**: one 4/8pt spacing scale, one corner-radius scale, as constants — no ad hoc magic numbers.
- **Motion**: default Material transitions only; download progress bars are the one place continuous animation is expected and useful.
- **Dark mode**: full parity everywhere, including Setup and auth screens.
- **Accessibility**: minimum touch target 44x44, respect system text-scale in addition to the in-app font-size setting, sufficient contrast in both themes.

---

## 10. Architecture / Folder Structure

```
lib/
  app.dart
  main.dart
  core/
    theme/
    router/                   -- go_router: auth guard + content-installed guard
    network/
      api_client.dart         -- dio instance, auth interceptor, base URL config
      endpoints.dart          -- typed wrappers for every Section 13 endpoint
    db/
      study_content_db.dart       -- drift: study domain + installed_study_packs
      assessment_content_db.dart  -- drift: assessment domain + installed_assessment_packs
      progress_db.dart            -- drift: opened per-account, path selected by active user_id
      db_paths.dart                -- resolves the Section 3 directory layout
    downloads/
      pack_downloader.dart    -- resumable download, checksum verify, unzip, transaction-safe import
    sync/
      sync_worker.dart        -- outbox flush logic, connectivity/resume triggers
  features/
    auth/
    setup/
      data/                   -- manifest fetch, pack download orchestration
      presentation/           -- Study/Assessment panels, progress UI, manage-content mode
    home/
    study_center/
    practice/
    progress/
    settings/
  shared/
    widgets/
```
No `assets/content/` directory at all in this version — the app ships with zero bundled question/study data. `assets/fonts/` remains for the bundled type family.

State: one Riverpod `Notifier`/`AsyncNotifier` per feature for anything stateful (auth session, active-account progress DB handle, pack download progress, exam session, sync status); `FutureProvider`/`StreamProvider` wrapping drift queries for read paths.

---

## 11. Build Phases (execute in order)

**Phase 0 — Confirm inputs before writing any app code**
Pack granularity and payload format are already fixed by Section 4 (study = per-book, assessment = per-subject, JSON payload) — don't re-litigate them. The one open input to confirm with the user/backend team is whether to build against a local mock pack-server first (recommended default: yes, build the mock from Section 4's exact schemas so Phases 1–9 are never blocked on the real backend).

**Phase 1 — Project scaffold**
`flutter create` targeting android, ios, windows, macos. Add all Section 5 packages. Set up `core/theme`, `core/router` (auth guard + content-installed guard), placeholder screens for every Section 6 destination including Setup.
*Done when:* app runs on one desktop + one mobile target, routes logged-out → Login, logged-in-no-content → Setup, logged-in-with-content (mocked) → Home. `flutter analyze` clean.

**Phase 2 — Auth**
Login/Register against the Section 13 contract (real or mocked), secure token storage, per-account `progress.sqlite` creation/reopening (Section 3.3), the 401-handling behavior, logout's unsynced-data warning.
*Done when:* two different mock accounts can log in on the same simulator/device and each sees only their own (initially empty) progress; force-quitting in airplane mode and reopening still lands correctly past the auth gate.

**Phase 3 — Setup / content download**
Build `study_content_db.dart`/`assessment_content_db.dart` schemas empty, the manifest fetch, the two-panel Setup UI with size estimates, Wi-Fi-only gating, resumable range-request downloads, checksum verification, transactional pack import (data + scoped images into the Section 3.1 folder layout), and the `installed_*_packs` bookkeeping.
*Done when:* against the mock pack server, a student can download one Study book and one Assessment subject independently, see accurate progress/resume behavior when connectivity is interrupted mid-download, and see both reflected correctly in "Manage downloaded content."

**Phase 4 — Study Center**
Full Book → Subject → Reader flow reading only from installed packs, `flutter_html` rendering with font-size control and dark-mode-aware styling, end-of-subject quiz, `reading_progress` writes + outbox enqueue, correct empty state if no Study pack installed.
*Done when:* fully offline (airplane mode) after Phase 3's download, a student can browse, read, and quiz.

**Phase 5 — Practice/CBT engine**
Setup → timed exam session → results/review, passage-linked questions, flagging, question-palette drawer, auto-submit on timeout, outbox enqueue, correct empty state if no Assessment pack installed.
*Done when:* a full timed exam runs start-to-finish in airplane mode with correct scoring and a working review screen.

**Phase 6 — Sync worker**
Outbox flush against Section 13's sync endpoints, connectivity/resume/`workmanager` triggers, retry/backoff, Settings sync status/"sync now" UI.
*Done when:* completing a test offline, then reconnecting, flips pending items to synced with no user action, verified against the mock server's received payloads — and confirm switching to a second account on the same device does not touch the first account's outbox.

**Phase 7 — Home, Progress, Settings polish**
Streaks/points into `local_stats`, Home cards, Progress charts, full Settings including per-domain storage display and pack removal (delete rows + delete that domain's image subfolder + update `installed_*_packs`).
*Done when:* removing an installed Study book frees the corresponding disk space and the app correctly reflects it's gone (without affecting Assessment content or the other account's progress).

**Phase 8 — Performance, accessibility, desktop adaptation**
Verify large lists are windowed/paginated, profile on a low-spec device including the download/import path (large zip extraction shouldn't freeze the UI — run off the main isolate), verify dark mode/contrast/touch targets everywhere including Setup and auth, verify the desktop breakpoint layout, keyboard navigation in the exam session, remove debug-only screens.
*Done when:* importing a large pack doesn't jank the UI, scrolling a large question list stays smooth, no analyzer warnings, Windows build is comfortably usable with mouse+keyboard.

**Phase 9 — Release packaging**
Android signed release bundle (should now be genuinely small, since content isn't bundled — verify this). iOS signed build (needs a Mac + Apple developer account — flag if unavailable). Windows installer. macOS signed/notarized build if available.
*Done when:* each platform has an installable artifact, confirmed pointed at the real backend base URL, not the mock.

---

## 12. Content Pack Backend Pipeline (what the backend team builds to make Section 13's download endpoints work)

This replaces the old "build-time export script." It's ongoing backend infrastructure, not a one-off:

1. On content publish/update in ContentAdmin (or, until that's fully wired, a manual Artisan command), regenerate the **affected pack only** — e.g. publishing a new week's content for one `library_subject` regenerates that book's Study pack, not the entire catalog.
2. Each pack is a **pre-built static zip** (not assembled per-request) containing `pack.json` in the exact shape defined in Section 4.5, plus only the images that pack's rows reference, placed in the Section 3.1 folder shape (`study/images/books|subjects|questions/` or `assessment/images/questions/`) so the client's importer can copy them straight across without renaming logic.
3. Static zips are stored on public disk/S3/CDN so HTTP range requests (resumable downloads) work automatically — this is a hosting/infra requirement, not just an API contract detail.
4. The manifest endpoint (Section 13) is generated from these pack records — version = a hash or timestamp bumped every time step 1 regenerates that pack, so the client can tell "this book changed since I downloaded it" without comparing content.

---

## 13. Required API Endpoints (backend team to build — itemized contract for this app)

Versioned under a stable prefix (e.g. `/api/v1/...`), JSON in/out except pack downloads (binary zip). Except registration/login/manifest/pack-download, all require `Authorization: Bearer <token>` (Sanctum). All sync-upload endpoints are **idempotent by client-supplied UUID**.

### Auth
| Method & Path | Purpose | Notes |
|---|---|---|
| `POST /auth/register` | Create account | firstname, lastname, email, phone_number, password, current_class_id → user + bearer token |
| `POST /auth/login` | Authenticate | email/phone + password → user + bearer token |
| `POST /auth/logout` | Revoke current token | — |
| `POST /auth/password/forgot` | Trigger reset (reuse existing `password_otps`) | — |
| `POST /auth/password/reset` | Complete reset | — |
| `GET /auth/me` | Fetch current profile | refresh cached profile, confirm token still valid |

### Profile
| Method & Path | Purpose | Notes |
|---|---|---|
| `PATCH /profile` | Update editable fields (current_class_id, phone_number, etc.) | e.g. changing class in Settings while online |

### Content manifest & packs (new — this is the core of the redesign)
| Method & Path | Purpose | Notes |
|---|---|---|
| `GET /content/manifest` | List every available pack | Response shape is fixed by **Section 4.4** — implement exactly that, it drives the entire Setup screen |
| `GET /content/study/{scope_id}/pack` | Download one Study pack (`scope_id` = `library_book_id`) | Zip contents fixed by **Section 4.5**; must support HTTP `Range` requests for resumability |
| `GET /content/assessment/{scope_id}/pack` | Download one Assessment pack (`scope_id` = `subject_id`) | Zip contents fixed by **Section 4.5**; same range-request requirement |

### Sync (device → server, upload-only for this version)
| Method & Path | Purpose | Notes |
|---|---|---|
| `POST /sync/practice-attempts` | Bulk-upload completed attempts + per-question answers (both `source_type: assessment` and `library`) | Request/response shape fixed by **Section 4.6** — idempotent upsert by client UUID |
| `POST /sync/reading-progress` | Bulk-upload `reading_progress` changes | Request/response shape fixed by **Section 4.6** — idempotent upsert by `library_subject_id` |
| `GET /sync/status` | Optional: server's last-received timestamp/ack per entity type | Nice-to-have, not a Phase 6 blocker |

### Parent/guardian analytics (new backend capability — flagged, not blocking the mobile app phases)
| Method & Path | Purpose | Notes |
|---|---|---|
| `POST /parent/link-student` | Link a parent/guardian account to a student (invite code or email/phone lookup) | Requires a new parent↔student relationship table and a `parent` value on `users.user_type` |
| `GET /parent/children` | List linked students for the logged-in parent | — |
| `GET /parent/children/{id}/analytics` | Aggregate: attempts over time, average score, per-subject accuracy, streak, last-active — built from the rows the sync endpoints above populate | The actual "analytics for the parent" deliverable; this app's job is only to keep that data flowing, not to render this view |

**Flag to the backend team explicitly:** the content-manifest/pack pipeline (Section 12) and the parent-linkage schema are both net-new infrastructure, not wiring exercises — scope real time for both, separately from the more mechanical sync-upload endpoints.

---

## 14. Working Agreement for Claude Code

- Work phase by phase. After each phase, summarize what was built, run `flutter analyze` (and `flutter test` once tests exist), and stop for review before starting the next phase unless explicitly told to continue autonomously.
- If a live API isn't available yet, build against a local mock server that matches Sections 3–4 and 13 exactly, including serving fake-but-structurally-correct zip packs so the download/import/resume path in Phase 3 gets genuinely exercised, not stubbed out. The app isn't "done" until verified against the real backend.
- Treat the account-isolation behavior in Section 3.3 as a correctness requirement, not a nice-to-have — write an explicit test/manual-QA step for "two accounts, one device, no data crosses over" before Phase 6 is considered done.
- Section 4's schemas and payload shapes are binding, not illustrative — implement them field-for-field rather than approximating. Any time something *else* in this spec is ambiguous or has a real tradeoff (e.g. whether background sync/download-resume on iOS is worth the added complexity), stop and ask rather than guessing.
- Network permission stays scoped to exactly what auth, Setup, and sync need. The app should be fully usable — content, practice, progress, everything except signing in and the initial pack download — with networking disabled entirely.

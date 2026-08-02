# SuccessAI — Build Prompt Addendum for the Flutter App

Paste this into the same Claude Code session (or a fresh one with `MOBILE_APP_BUILD_PROMPT.md` also loaded) that's building the Chronicles Revolution mobile/desktop app. This describes one additional feature — SuccessAI, an AI study-assistant chat — on top of that spec. It assumes the architecture already defined there: Flutter + Riverpod + go_router + drift, per-account `progress.sqlite`, `dio` for networking, the auth flow from Section 8.

---

## 0. About the env keys — read this before anything else

**No API key goes in the Flutter app. Not the OpenRouter key, not any key.** This isn't a placeholder omission — it's the entire point of how this feature is architected, and it's a hard security requirement, not a style preference.

SuccessAI is powered by OpenRouter (an LLM router), and that integration already exists server-side in this repo (`app/Services/MixtralService.php`) — it's what the existing web app's chat feature uses. The secret credentials for it (`OPENROUTER_KEY`, `OPENROUTER_MODEL`, `OPENROUTER_MODEL_PAID`) live **only** in the Laravel backend's `.env` file, are never returned by any API response, and must never be copied into the Flutter project, a `.env` file bundled into the app, a build-time `--dart-define`, or anywhere else that ships inside the installed app binary. A key embedded in a distributed mobile app is not a secret — APKs and IPAs are trivially decompiled, and anyone who extracts it can run up the account's usage bill or get it rate-limited/banned for abuse, breaking the feature for every real user.

The Flutter app needs **zero new environment configuration** for this feature. It reuses the exact same API base URL and bearer token already set up for every other endpoint (auth, sync, content packs) in the main build prompt's `core/network/api_client.dart`. If you find yourself about to add an OpenRouter/AI-related key to the Flutter project at any point, stop — that's a sign something's been misunderstood about this design, not a missing step to complete.

---

## 1. What SuccessAI is, and where it fits

SuccessAI is a conversational AI academic assistant — a student types a question, gets a reply, can continue the thread. It's already live on the web platform (`/successai`); this is the same feature, same backend, same persona ("You are SuccessAI, a helpful and friendly academic assistant for Nigerian secondary school students"), exposed through a new token-authenticated JSON API for this app.

**This is a fourth deliberate exception to "offline"**, alongside registration, Setup's content downloads, and background sync (see the main build prompt's Section 0/1). An LLM call cannot happen without a network round-trip — there is no offline mode for this feature, and the UI should say so plainly rather than showing a generic error when there's no connection.

Where it belongs in the app: a new bottom-nav/rail destination (or a prominent entry point from Home — your call on placement, but it should be easy to find, not buried in Settings) alongside Study Center, Practice/CBT, and Progress.

---

## 2. The API (already built, tested, and live — build against this exactly)

Full reference: `API_DOCUMENTATION.md` Section 7 in this repo. Summary:

| Endpoint | Purpose |
|---|---|
| `POST {baseUrl}/ai/chat` | Send a message. Omit `conversation_id` to start a new thread, include it to continue one. Response contains **both** the saved user message and the AI's reply — one call, no polling. |
| `GET {baseUrl}/ai/conversations` | List the account's AI conversations, newest-active first, each with a `last_message` preview. |
| `GET {baseUrl}/ai/conversations/{id}/messages` | Paginated (oldest-first) message history for one conversation. |

All three require the same bearer token as every other authenticated call. `POST /ai/chat` is rate-limited server-side (20/minute) — don't build a client-side retry loop that could exceed that; surface the failure and let the student try again.

**Error handling that matters for UX, not just correctness:**
- `503` → SuccessAI is unavailable server-side right now (misconfigured or intentionally disabled). Show "SuccessAI is unavailable right now" — this is not the student's fault and not a connectivity problem, don't tell them to check their internet.
- `502` → the request reached the server but the upstream AI call failed. **The student's message was still saved** even though the reply failed — if you offer a retry, send it with the same `conversation_id` you already have, not as a brand-new conversation, or the question will appear duplicated in the thread.
- No connectivity at all → this is a normal Dio connection error like any other online-only call in this app (see the main build prompt's auth/sync sections for how those are already handled) — show the same "you're offline" treatment as elsewhere in the app for consistency, not a SuccessAI-specific error screen.

---

## 3. Local caching (read-only, for offline viewing of past chats)

Conversations and messages live server-side — they are **not** part of the downloadable content packs (Section 3 of the main build prompt) and are not something Setup ever fetches in bulk. But it's reasonable and expected for a student to want to re-read a past AI conversation while offline (e.g., reviewing an explanation on the bus home). Handle this with a small **read-through cache**, not a sync mechanism:

- Add two tables to the current account's `progress.sqlite` (per-account, same reasoning as the rest of that file — one student's AI chat history should never be visible to a different student who later logs into the same shared device):
  ```
  ai_conversations_cache (id, title, updated_at, last_message, cached_at)
  ai_messages_cache      (id, conversation_id, content, is_ai, sender, created_at, cached_at)
  ```
- Every time `GET /ai/conversations` or `GET /ai/conversations/{id}/messages` succeeds online, upsert the results into these tables (insert-or-replace by `id`).
- When offline, the conversation list and message history screens fall back to reading from these cache tables instead of erroring — clearly indicate it's a cached/offline view (e.g. a small "offline — showing saved messages" banner) since new messages obviously can't be fetched or sent.
- Sending a new message (`POST /ai/chat`) always requires connectivity — there's no local queue/outbox for this one, unlike practice attempts. An AI reply can't be produced offline and queued for later; don't build a sync-outbox pattern here, it doesn't apply.

---

## 4. Screens

**Conversation list** (entry point) — list from `GET /ai/conversations` (or the cache when offline), each row showing title + `last_message` preview + relative time. A prominent "New chat" action that goes straight to an empty chat screen (no conversation id yet — the first message sent creates one).

**Chat screen** — standard chat UI: message bubbles distinguished by `is_ai` (align/style AI replies distinctly from the student's own messages, and label the AI sender "SuccessAI" per the `sender` field), a text input, a loading/typing indicator while waiting for the `POST /ai/chat` response to return (it's a blocking call — a few seconds is normal, make that feel intentional rather than stuck). Opening an existing conversation loads its history via `GET /ai/conversations/{id}/messages` (paginate/load-more on scroll-up for long threads).

**Empty/offline states** — a friendly empty state for "no conversations yet" (distinct from "offline, nothing cached" and from the 503 "unavailable" case) — these are three different situations and deserve three different messages, not one generic placeholder.

---

## 5. Folder structure

Consistent with the main build prompt's `features/` layout:
```
lib/features/ai_chat/
  data/          -- API calls (send, list conversations, list messages), cache read/write
  domain/        -- Conversation/Message models
  presentation/  -- conversation list screen, chat screen, message bubble widget
```
State: a Riverpod `AsyncNotifier` per open conversation for the message list + send-in-progress state; a `FutureProvider`/`StreamProvider` for the conversation list, reading network-or-cache depending on connectivity (reuse the same `connectivity_plus` check already wired up for sync in the main spec).

---

## 6. Definition of done

- A student can start a new SuccessAI conversation, send a message, and see a reply, entirely through the endpoints above — no client-side AI/HTTP calls to any AI provider directly.
- Reopening a past conversation shows its full history.
- Turning off the network: past conversations are still viewable (from cache); starting a new chat or sending a new message shows a clear "needs internet" state, not a crash or a stuck spinner.
- Searching the Flutter project for any of `OPENROUTER`, `openrouter.ai`, or an OpenRouter/OpenAI/Anthropic-style API key pattern returns nothing. If it returns something, that's a bug in the implementation, not an integration detail to leave in.

## Remote Backup + Outbox Sync (Team Handoff)

### 1) Big picture

The app currently has **two backup strategies**:

- **Full backup task**: copies all local tables to remote (manual trigger).
- **Outbox incremental sync**: records row-level changes (insert/update/delete) and replays them to remote.

This gives you:
- a **heavy full snapshot** option when needed,
- and a **lighter ongoing sync** path for normal app traffic.

---

## 2) Celery (quick intro for Flask beginners)

**Celery** is a background job runner.

Instead of making a user wait on a long DB job in a Flask request, we:
1. enqueue a task (`.delay(...)`)
2. worker executes it in background
3. Flask can poll task status/result via task id.

In your codebase, Celery is used for:
- remote DB connection test
- full backup
- enqueueing outbox events
- draining outbox events to remote

---

## 3) Purpose of the Outbox

The **OutboxEvents** table is a local queue of “what changed”:

- table changed (`table_name`)
- operation (`event_type`: insert/update/delete)
- primary key (`pk_json`)
- row payload (`payload_json`) for upserts
- processing lifecycle (`status`, `attempt_count`, errors, timestamps)

Why this exists:
- remote can be updated incrementally (not always full-table truncate/copy)
- retries are possible if remote is down
- you get visibility/debug trail of sync operations

---

## 4) Implementation steps (what was done)

- Added an outbox model/table to store change events.
- Added helper functions to serialize rows and pick version timestamps.
- Added `enqueue_task` Celery task to write events into outbox.
- Wired department feature routes to enqueue events for create/update/delete and member assignment updates.
- Added `drain_outbox` Celery task to process pending events and apply remote upsert/delete.
- Added remote connection test and DB compare endpoints for diagnostics.
- Kept full backup task (`remote_db_backup`) as manual fallback.

---

## 5) Files and functions involved

### `app/models.py`
- **`OutboxEvents`** (`outbox_events` table)
  - Stores queued sync events and processing state.
  - Key fields: `status`, `table_name`, `event_type`, `pk_json`, `payload_json`, `attempt_count`, `last_error`, `outbox_desc`.

### `app/background_tasks/enque_event_task.py`
- **`_pick_version_ts(row_obj)`**
  - Picks best timestamp field (`updated_on`, `edited_on`, `created_at`, etc.)
- **`_serialize_row(model_obj)`**
  - Serializes SQLAlchemy model row into dict for payload.
- **`enqueue_outbox_event(...)`**
  - Creates `OutboxEvents` row and adds to session.
- **`enqueue_task(...)`** (`@shared_task`)
  - Celery task wrapper that calls `enqueue_outbox_event` and commits.

### `app/background_tasks/outbox_queue.py`
- **`drain_outbox(batch_size=200, max_attempts=10, reclaim_after_minutes=2)`** (`@shared_task`)
  - Claims pending/stale-processing outbox events.
  - Reflects remote schema.
  - Applies:
    - upsert for insert/update (`ON DUPLICATE KEY UPDATE`)
    - delete for delete events (with child-first recursive delete logic)
  - Marks event `done`, `pending` (retry), or `failed`.
- Helper internals:
  - `_filter_payload_for_table(...)` (drops non-existent columns)
  - `_resolve_remote_table(...)`
  - `_apply_upsert(...)`
  - `_apply_delete(...)` + recursive FK-safe delete helper

### `app/background_tasks/backup_db_task.py`
- **`remote_db_backup(self)`** (`@shared_task(bind=True)`)
  - Full local→remote copy:
    - reflects local metadata
    - truncates remote table
    - inserts all local rows
  - Reports progress via `self.update_state(...)`
  - Manual trigger path.

### `app/background_tasks/remote_db_connection_task.py`
- **`test_remote_db_connection()`**
  - Verifies remote DB connectivity (`SELECT 1` style).

### `app/background_tasks/modules/compare_local_x_remote.py`
- **`compare_DB()`**
  - Checks local/remote connection.
  - Compares table presence and timing metrics.
  - Used by UI endpoint for diagnostics.

### `app/features/department/routes.py`
- Department routes now enqueue outbox events via:
  - **`enqueue_task.delay(...)`**
- Mapped operations:
  - department insert/update/delete
  - members update when assigned/unassigned from department

### `app/test/test_database.py`
- Testing endpoints for:
  - remote connection task
  - full backup trigger
  - outbox drain trigger
  - task polling (`/getres/<task_id>`)
  - DB diff endpoint (`/db-diff`)

---

## 6) Current flow summary

### A) Full backup flow (manual)
1. User triggers `/trigger_backup`
2. `backup_db_task.remote_db_backup.delay()`
3. Worker truncates + copies all tables local→remote
4. Result shown in test UI

### B) Outbox incremental flow
1. Route changes local data (e.g., department/user assignment)
2. Route calls `enqueue_task.delay(...)` with event payload
3. `enqueue_task` writes row into `outbox_events`
4. `drain_outbox.delay()` processes queued events
5. Remote receives upsert/delete; outbox statuses updated

---

## 7) Important operational notes for your team

- **Outbox is for incremental sync**, full backup is periodic/manual fallback.
- If remote schema drifts, outbox apply may fail until schema is aligned.
- Retry behavior is built into outbox draining (`attempt_count`, `failed`).
- Use DB diff + connection checks to diagnose issues before big sync runs.
- Keep an eye on outbox statuses (`pending`, `processing`, `failed`) for health.

---

## 8) Recommended “how to explain this to newcomers”

Use this sentence:

> “We save app changes locally first, record each change in an outbox queue, and a background worker replays those changes to the backup database. Full backup still exists for whole-database refresh.”

---

If you want, I can also provide a **one-page runbook** next (commands to start Flask/Celery/Redis, health checks, and common failure recovery steps) in the same PDF-ready format.
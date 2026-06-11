## One-page Runbook: Remote Backup + Outbox Sync (Ashgard To‑Do)

### Purpose
This app has **two ways** to keep the **remote MySQL backup DB** updated:

- **Full backup**: copies *all* local tables to remote (manual “snapshot”).
- **Outbox sync**: records row-level changes locally and **replays them** to remote (incremental “near real-time”).

Use **outbox sync** for day-to-day updates; use **full backup** as a recovery tool or periodic sanity refresh.

---

## Architecture (mental model)
- **Flask app**: handles user requests, writes to **Local DB**.
- **Outbox table** (`outbox_events`): local queue of changes to replicate.
- **Celery worker**: background runner that executes tasks.
- **Redis**: message broker/result backend for Celery.

---

## Quick start (dev)
### 1) Ensure Redis is running
```bash
redis-server
```

### 2) Start Celery worker (background tasks)
```bash
celery -A celery_worker worker --loglevel=info
```

### 3) Start Flask app
```bash
flask run
```

---

## Where to look in code (key files)
- **Outbox model**
  - `app/models.py` → `class OutboxEvents`
- **Enqueue outbox event task**
  - `app/background_tasks/enque_event_task.py` → `enqueue_task()`, `enqueue_outbox_event()`
- **Drain outbox to remote**
  - `app/background_tasks/outbox_queue.py` → `drain_outbox()`
- **Full backup (truncate + copy all tables)**
  - `app/background_tasks/backup_db_task.py` → `remote_db_backup()`
- **Remote DB connection test**
  - `app/background_tasks/remote_db_connection_task.py`
- **DB diff (local vs remote)**
  - `app/background_tasks/modules/compare_local_x_remote.py` → `compare_DB()`
- **Test routes / UI triggers**
  - `app/test/test_database.py` and `app/test/templates/test_page.html`

---

## Normal operations
### Incremental sync (recommended)
1. App writes local data (ex: Department changes).
2. App calls `enqueue_task.delay(...)` to record an outbox event.
3. Run `drain_outbox.delay()` to apply pending events to remote.

What success looks like:
- `outbox_events.status` moves from `pending → processing → done`
- Remote DB rows update without truncating entire tables.

### Full backup (manual)
- Trigger `remote_db_backup.delay()` when you need a complete remote refresh.

What success looks like:
- Task reports progress per table and finishes with success + table stats.

---

## Health checks (what to run/test)
### A) Can we reach remote DB?
- Use the app’s “Test Remote DB” action (or run the task directly).
- Expected result: `success=True`.

### B) Is schema aligned?
- Use `/db-diff` UI/endpoint.
- Watch:
  - **Local only tables**: missing on remote
  - **Remote only tables**: legacy/manual tables
  - **Column drift**: mismatched columns/types

### C) Is outbox draining?
- Check `outbox_events` rows:
  - Lots of `pending` means drain isn’t running or failing.
  - `failed` means a persistent apply error (schema mismatch, FK constraint, bad PK, etc.).

---

## Common failure modes + fixes
### 1) Outbox rows not being created
Symptoms:
- Celery task runs, but `outbox_events` stays empty.

Causes / fixes:
- Ensure `enqueue_task` **forwards args** and does `db.session.commit()` in task.
- Verify Celery worker logs show commits and no rollbacks.

### 2) Drain fails: “Remote table not found”
Symptoms:
- Outbox events move to `failed` with “Remote table not found”.

Fix:
- Remote schema not updated. Apply the needed schema changes on remote, rerun drain.

### 3) Drain fails on delete (foreign key errors)
Symptoms:
- Deletes fail due to FK constraints.

Fix:
- Current drain code deletes **children first**, then parent. If a table has unexpected FK relationships, update delete ordering/logic or ensure FKs match between DBs.

### 4) Migration error (MySQL 1553 cannot drop index needed for FK)
Symptoms:
- `Cannot drop index 'fk_notif_recipient': needed in a foreign key constraint`

Fix:
- Edit the migration to **not drop FK-backed indexes** (or drop FK constraint first). If migration is unrelated, remove the index drop operation.

---

## Operational guidance (recommended defaults)
- Run **Celery worker continuously** in any environment that needs syncing.
- Prefer **incremental outbox sync** for normal updates.
- Run **full backup**:
  - after major schema changes
  - after long downtime
  - as a periodic “reset remote to truth” job (in off-hours)

---

## Escalation checklist (when something looks wrong)
- Confirm `REMOTE_DB_URL` and local DB URL in config.
- Check `/db-diff` output: missing tables / column drift.
- Inspect `outbox_events.failed` rows: look at `last_error`.
- If remote is badly out of sync, run **full backup** once, then return to outbox draining.

---

If you want, tell me where your team will run this (local dev only vs. server) and I’ll tailor this runbook into **Dev vs. Staging vs. Prod** sections (including recommended worker concurrency and scheduling strategy).
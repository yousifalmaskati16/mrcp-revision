# MRCP Revision System

Standalone spaced-repetition study system for the MRCP exam on **23 Sep 2026**.

- **App (use on your phone):** https://claude.ai/code/artifact/03bf4701-547a-4c23-99dd-f2479e281b80
- **Push topic (ntfy):** `mrcp-yousif-6d88bd23`

## How it works
```
inbox/      <- drop your 16 PDFs here
content/    <- one JSON per PDF (flashcards + topics + summary)
app/        <- template.html (the app source)
dist/       <- built index.html (published as the artifact)
scripts/    <- build.py, notify.sh, install-reminders.sh
launchd/    <- macOS reminder schedules
```

## Adding / updating PDFs
1. Drop PDF(s) into `inbox/`.
2. Ask Claude to process them → creates `content/<name>.json`.
3. `python3 scripts/build.py` rebuilds `dist/index.html`.
4. Claude republishes the same artifact URL → your phone's app updates.

## Phone setup (one time)
**App:** open the artifact URL in Safari → Share → *Add to Home Screen*. Progress is saved on the phone.

**Push notifications:**
1. Install the free **ntfy** app (App Store).
2. Add subscription → topic `mrcp-yousif-6d88bd23` (server ntfy.sh).
3. Reminders now arrive on your phone.

## Reminders (macOS launchd)
```
bash scripts/install-reminders.sh     # daily 7pm + weekly Sun 10am
bash scripts/notify.sh daily          # send a test push now
```
Requires this Mac to be awake at fire time. Notifications auto-intensify (high priority) inside the final 3 weeks.

## Progress
- [x] 00 example (demo — delete when real PDFs land)
- [ ] 14 remaining PDFs (2 completed by you, drop them first)

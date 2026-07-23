# MRCP Revision System

Standalone spaced-repetition study PWA for the MRCP exam on **23 Sep 2026**.
Runs entirely on GitHub — independent of any Mac.

- **App (install on your phone):** https://yousifalmaskati16.github.io/mrcp-revision/
- **Repo:** https://github.com/yousifalmaskati16/mrcp-revision
- **Push topic (ntfy):** `mrcp-yousif-6d88bd23`

## Layout
```
inbox/      <- drop your 16 PDFs here (raw notes; bold = weak spot)
content/    <- one JSON per PDF (flashcards + topics + summary + flags)
app/        <- template.html, manifest, sw.js, icons (app source)
dist/       <- built PWA (generated; deployed by GitHub Actions)
scripts/    <- build.py, notify.sh
.github/    <- deploy.yml (build+Pages) · remind.yml (phone reminders)
```

## Fidelity rules (baked into how content is generated)
1. Cards/notes reproduce your PDF **verbatim** — never reworded, never "corrected".
2. **Bold** in your notes → `"weak": true` (its own red deck, repeats until mastered, leads each day).
3. Anything that looks dated/wrong goes in a per-module `flags[]` list shown separately — the card itself is untouched.

## Adding / updating notes
1. Drop PDF(s) into `inbox/` (via github.com, desktop, or `git`).
2. The daily auto-scan agent (or ask Claude) turns each into `content/<name>.json` and opens a **Pull Request**.
3. Review + merge the PR → GitHub Actions rebuilds and redeploys → your phone's app updates.

Manual build: `python3 scripts/build.py`

## Phone setup (one time)
**App:** open the Pages URL in Safari → Share → *Add to Home Screen*. Works offline; progress saved on the phone.

**Push notifications:**
1. Install the free **ntfy** app (App Store).
2. Add subscription → topic `mrcp-yousif-6d88bd23`, server `ntfy.sh`.

## Reminders (GitHub Actions — fire even with the Mac off)
- Daily **19:00 Bahrain** study nudge (auto high-priority inside 3 weeks)
- **Sunday 10:00 Bahrain** weekly progress check
- Milestone pings at **30 / 14 / 7 / 3 / 1** days to go
- Test now: Actions tab → *Phone reminders* → Run workflow, or `gh workflow run remind.yml -f mode=daily`

## Progress
- [x] 00 example (demo — delete when real PDFs land)
- [ ] 2 completed PDFs (drop first) + 14 remaining

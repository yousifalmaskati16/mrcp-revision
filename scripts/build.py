#!/usr/bin/env python3
"""Assemble the deployable PWA in dist/ from app/ + content/*.json.
Outputs: dist/index.html, dist/sw.js (versioned), dist/manifest.webmanifest, dist/icon-*.png"""
import json, pathlib, shutil, hashlib, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
APP, CONTENT, DIST = ROOT/"app", ROOT/"content", ROOT/"dist"
DIST.mkdir(exist_ok=True)

# 1. gather modules
mods = []
for f in sorted(CONTENT.glob("*.json")):
    try:
        mods.append(json.loads(f.read_text()))
    except Exception as e:
        print(f"!! skipping {f.name}: {e}", file=sys.stderr)
mods.sort(key=lambda m: m.get("order", 999))

# 2. index.html
html = (APP/"template.html").read_text().replace(
    "/*__CONTENT__*/[]", json.dumps(mods, ensure_ascii=False))
(DIST/"index.html").write_text(html)

# 3. service worker with a content-based version (forces update on change)
ver = hashlib.sha1((html + (APP/"sw.js").read_text()).encode()).hexdigest()[:8]
(DIST/"sw.js").write_text((APP/"sw.js").read_text().replace("__SWVER__", ver))

# 4. static assets
for name in ("manifest.webmanifest", "icon-192.png", "icon-512.png"):
    src = APP/name
    if src.exists():
        shutil.copy2(src, DIST/name)

# 5. .nojekyll so GitHub Pages serves files verbatim
(DIST/".nojekyll").write_text("")

cards = sum(len(m.get("cards", [])) for m in mods)
weak = sum(1 for m in mods for c in m.get("cards", []) if c.get("weak"))
topics = sum(len(m.get("topics", [])) for m in mods)
done = sum(1 for m in mods if m.get("status") == "done")
print(f"Built dist/ · {len(mods)} modules ({done} done) · {cards} cards ({weak} weak) · {topics} topics · sw {ver}")

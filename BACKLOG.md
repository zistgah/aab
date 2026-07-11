# AAB — Backlog (scrum / agile)

Small increments. Sprint 0 ships a working browser studio; everything else is an issue.
Do **not** attempt to complete all of this at once.

## ✅ Sprint 0 (v0.1) — executable stage diagram, intent ledger, lenses, tiers, prompts.

## ✅ Sprint 1a (v0.2 — this release) — the paint studio
- SVG paint canvas: 6 brushes (actor/component/store/gate/interface/environment) + move/wire/erase.
- Grounded gamification: sketch → named (+10 XP) → verified glow only with a recorded oracle (+25);
  wires +3; XP levels Doodler → Grand Architect; quest badges.
- Quests = the 8 VGC stages; completion requires typed evidence (no evidence, no ✓).
- Painted-system manifest serialized into every generated prompt.
- Export/import painting as JSON carrying the original intent (audit trail).
- Publishing & patent trail wired into Quest 7 (misty-doi/publish_paper.sh + patent_track.sh;
  filing stays human + counsel). References section for the whole toolchain.

## Sprint 1b — candidate issues (file with `gh issue create`)
- [ ] **aab#1 notebooks tier** — generate a Colab notebook from the active stage + domain; "Open in Colab".
- [ ] **aab#2 local-linux tier** — emit a safe-by-default local runner (Ubuntu first); document setup.
- [ ] **aab#3 wsl tier** — WSL common-environment bootstrap notes + script.
- [ ] **aab#5 gap-analysis view** — surface intent-vs-deliverable gaps across sessions as a short report.
- [ ] **aab#6 oracle library** — starter oracles per domain lens (test suite, second-impl parity, measurement, review).
- [ ] **aab#7 deep-link a stage** — URL params to open the studio at a given stage/domain (shareable).

## Sprint 2+ — larger, deferred
- [ ] **aab#8 fiza integration** — link the environment-domain instance (fiza) as a worked example.
- [ ] **aab#9 misty-doi versioning** — misty-doi does not chain true Zenodo versions; add
      `misty publish --new-version-of <concept_id>` calling `actions/newversion`. (Upstream: project-ilm/misty-doi.)
- [ ] **aab#10 zistgah home** — new ecosystem home page (habitat concept; Mangal Kamna + OASIS);
      move current root to a named page. (Repo: zistgah/zistgah.github.io.)

## Definition of done (per increment)
Verify by execution · honest figures · in-folder only (no /tmp) · gated irreversible steps ·
maintains CONTRACT + CONTEXT · one short, reviewable change.

<!-- contract: https://zistgah.org/aab/CONTRACT.md -->
# CONTRACT — what AAB is and how to handle it

_Read this first. Any AI session or contributor **maintains contract and context**: this file
and [`CONTEXT.md`](CONTEXT.md) are the source of truth. Do not re-derive fixed decisions._

## 1. What AAB is
**AAB** (آب, "water"; backronym *Ascension for All and Beyond*) is a **paint program for
systems**: a browser-first, gamified studio where a human paints a system — actors,
components, data stores, gates/oracles, interfaces, environments, and the flows between
them — and the AI plus the Verification-Gated (VGC) process **implement what was painted**.
Gamification is **grounded**: painted elements are sketches until named, and glow "verified"
only when the human records which oracle passed (the studio records oracles; it does not run
them). VGC stages are quests whose completion requires typed evidence. The painting
serializes into every AI prompt as a manifest; the user's **original intent** is preserved
verbatim (continuity / audit / gap analysis); domains span the areas described by
ISIC/ISCO/ISCED (the *domains*, never the standards). Quest 7 connects the painting to the
real publishing & IP machinery: misty-doi / publish_paper.sh (DOI + OpenTimestamps) and
patent_track.sh (OTS disclosure as priority-date evidence; **filing stays human + counsel**).
Part of the Zistgah ecosystem. For systems, not just software.

## 2. Handling rules (non-negotiable)
- **Author & affiliation.** Abhishek Choudhary is the sole author; affiliation is **AyeAI
  only**. Sole authorship — name no co-author/collaborator/contributor unless the author does.
- **Copyright & licences.** `Copyright © 1993–2026 Abhishek Choudhary. All rights reserved`,
  except per category: written content `CC-BY-SA-4.0`; software `GPL-3.0-or-later`; metadata
  `CC0-1.0`; novel/patentable methods proprietary (patents reserved; consulting via AyeAI).
- **No fabrication.** No invented DOIs, dates, citations, ORCIDs, numbers, or standard codes.
  Use the *domains* ISIC/ISCO/ISCED describe, not the copyrighted standard text.
- **Verify by execution.** Validate HTML/JSON/scripts before shipping; honest figures.
- **Filesystem.** Stay inside the run folder; create subfolders only; **never navigate
  outside it and never use `/tmp`**. Logs to `~/work/logs/`.
- **No irreversible step** (DOI mint, push, force-push, delete, issue-create) without a typed
  confirmation. `ZENODO_TOKEN`/ORCID from the environment only.
- **Canonical home is fixed:** repo `zistgah/aab`, site `https://zistgah.org/aab/`.
- **Incremental.** Deliver short, scrum-sized increments; open issues rather than completing
  everything at once. See `BACKLOG.md`.

## 3. Provenance
- Canonical record: `10.5281/zenodo.21312745` (pending first mint via `zistgah_seed_aab.sh`).
- Parent method (VGC): **10.5281/zenodo.21264248**.
- DOI via Misty DOI (`misty.json` → Zenodo); OpenTimestamps `.ots` under `provenance/`.
  NOTE: misty-doi does **not** yet chain true Zenodo versions (see BACKLOG). `isVersionOf` in
  metadata is a pointer only.

---
_Reconstruct faithfully. Critique with evidence, not tone. Systems, not just software._

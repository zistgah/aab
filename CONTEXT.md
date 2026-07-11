<!-- context: https://zistgah.org/aab/CONTEXT.md -->
# CONTEXT — cold-start map for AAB

_A fresh AI session or contributor rebuilds full working context from this file plus the
sources it points to. **Maintain contract and context.** © 1993–2026 Abhishek Choudhary.
All rights reserved. · AyeAI._

## Mission (one line)
A paint program for systems: the human paints; the AI and the verification-gated process
implement — from stated intent to a citable, timestamped record — with gamification that
never outruns grounding (no oracle, no glow).

## Rebuild context from three sources, in order
1. **[`CONTRACT.md`](CONTRACT.md)** — what AAB is and how to handle it. Read first.
2. **The studio** — [`index.html`](index.html) (also https://zistgah.org/aab/) — the
   executable diagram, intent ledger, domain lenses, tiers, prompt generator.
3. **The parent method (VGC)** — https://doi.org/10.5281/zenodo.21264248 — the gate, the
   parity oracle, and the primitives operationalised here.

## Invariants (never violate)
- The **canvas is the interface**: brushes paint actors/components/stores/gates/interfaces/
  environments; wires paint flows; the painting is the manifest handed to the AI.
- **Grounded gamification**: sketch → named (+XP) → verified only with a recorded oracle;
  quests (VGC stages) complete only with typed evidence. XP never substitutes for the gate.
- Acceptance belongs to an **oracle**, never the human or the AI. No oracle → Honest Deferral.
- **Intent is preserved** verbatim (original intent → current deliverable → gap) for audit.
- Domains are the **areas** ISIC/ISCO/ISCED describe — never reproduce the standard codes.
- Tier ladder: browser (live) → notebooks → local Linux (Ubuntu first) → WSL.
- Systems, not just software. AyeAI only; sole authorship; per-category licences; no
  fabrication; stay in the run folder (no `/tmp`). (See CONTRACT.md.)

## File map
| Path | Role |
|---|---|
| `index.html` | the executable co-development studio (Pages landing) |
| `CONTRACT.md` | what it is + non-negotiable handling rules |
| `CONTEXT.md` | this cold-start map |
| `BACKLOG.md` | the scrum/agile backlog (issues, sprint-sized) |
| `misty.json` | DOI deposit metadata |
| `CITATION.cff` | machine-readable citation |
| `LICENSES.md` | per-category licences |
| `provenance/*.ots` | OpenTimestamps proof(s) |
| `zistgah_seed_aab.sh` | one-shot: validate → dry-run → (gated) push / mint / OTS / issues |

## Working rules
Safe-by-default script; no irreversible step without a typed confirmation; tokens/ORCID from
the environment only; logs to `~/work/logs/`; canonical home `zistgah/aab` (fixed);
`--push` carries `provenance/*.ots`; deliver in short increments and file issues.

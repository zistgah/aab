#!/usr/bin/env bash
###############################################################################
#  zistgah_seed_aab.sh — seed AAB to zistgah/aab, mint a citable DOI + OTS,
#  and (optionally) open the Sprint-1 backlog as GitHub issues.
#
#  PHILOSOPHY (standing engineering rules):
#    * SAFE BY DEFAULT. No flags -> validate + offline DOI dry-run. Zero side effects.
#    * Every irreversible step opt-in AND confirmed:
#        --push      create/push zistgah/aab + enable Pages   (gh; typed PUSH)
#        --publish   mint Zenodo DOI, inject it, OTS-stamp     (ZENODO_TOKEN; typed MINT)
#        --issues    open Sprint-1 backlog items as issues     (gh; typed YES)
#        --all       push + publish (still prompts per step)
#    * IN-FOLDER ONLY. All work stays under this script's directory; clone into
#      ./.seedwork (a subfolder), never /tmp, never navigate outside the run folder.
#    * Tokens/ORCID from ENV only. Logs to ~/work/logs/.
#
#  © 1993-2026 Abhishek Choudhary. All rights reserved. Code: GPL-3.0-or-later.
###############################################################################
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

PAGE="index.html"
MJ="misty.json"; CFF="CITATION.cff"; CONTRACT="CONTRACT.md"; README="README.md"
PROV="provenance"; BACKLOG="BACKLOG.md"
PLACEHOLDER="__AAB_DOI__"
GH_REPO="zistgah/aab"
SITE="https://zistgah.org/aab/"
WORK="$SCRIPT_DIR/.seedwork"          # in-folder scratch (never /tmp)

LOGDIR="${HOME}/work/logs"; mkdir -p "$LOGDIR"
STAMP="$(date +%Y%m%d-%H%M%S)"; LOG="$LOGDIR/zistgah_seed_aab-$STAMP.log"

DO_PUSH=0; DO_PUBLISH=0; DO_ISSUES=0
for a in "$@"; do case "$a" in
  --push) DO_PUSH=1;; --publish) DO_PUBLISH=1;; --issues) DO_ISSUES=1;;
  --all) DO_PUSH=1; DO_PUBLISH=1;;
  -h|--help) sed -n '2,20p' "$0"; exit 0;;
  *) echo "unknown flag: $a"; exit 2;; esac; done

st(){ echo "  $*" | tee -a "$LOG"; }
hd(){ echo "" | tee -a "$LOG"; echo "=== $* ===" | tee -a "$LOG"; }
die(){ echo "FATAL: $*" | tee -a "$LOG" >&2; exit 1; }
cleanup(){ rm -rf "$WORK" 2>/dev/null || true; }
trap cleanup EXIT

hd "AAB seed — $STAMP   (push=$DO_PUSH publish=$DO_PUBLISH issues=$DO_ISSUES)"
st "dir : $SCRIPT_DIR"; st "log : $LOG"

# 1. validate
hd "1. VALIDATE INPUTS"
for f in "$PAGE" "$MJ" "$CFF" "$CONTRACT"; do [ -f "$f" ] || die "missing: $f"; done
mkdir -p "$PROV"
python3 - "$PAGE" <<'PY' 2>>"$LOG" || die "HTML parse failed"
import sys, html.parser
class V(html.parser.HTMLParser):
    def error(self,m): raise ValueError(m)
V().feed(open(sys.argv[1],encoding='utf-8').read()); print("   HTML parses OK")
PY
python3 -c "import json;json.load(open('$MJ'));print('   misty.json OK')" 2>>"$LOG" || die "misty.json invalid"
SHA="$(sha256sum "$PAGE" | cut -d' ' -f1)"; st "page sha256: $SHA"
grep -q "$PLACEHOLDER" "$PAGE" && st "DOI placeholder present — not yet minted" || st "note: no DOI placeholder (already minted?)"

# 2. tooling
hd "2. TOOLING"
MISTY=""; command -v misty >/dev/null 2>&1 && MISTY="misty"
st "misty : ${MISTY:-NOT FOUND (pipx install misty-doi)}"
command -v gh >/dev/null 2>&1 && st "gh    : $(command -v gh)" || st "gh    : NOT FOUND (needed for --push/--issues)"

# 3. offline DOI dry-run
hd "3. DOI DRY-RUN (offline)"
if [ -n "$MISTY" ]; then
  "$MISTY" validate -m "$MJ" 2>&1 | tee -a "$LOG" || st "   (validate flagged — review)"
  "$MISTY" publish -m "$MJ" -f "$PAGE" --dry-run --package-dir ".doi-dryrun" 2>&1 | tee -a "$LOG" || st "   (dry-run flagged — review)"
  rm -rf .doi-dryrun
  st "dry-run complete — nothing published"
else st "skipped (misty not installed)"; fi

# 4. push (create repo + Pages)
if [ "$DO_PUSH" = "1" ]; then
  hd "4. PUSH -> $GH_REPO"
  command -v gh >/dev/null 2>&1 || die "gh not found"
  gh auth status >/dev/null 2>&1 || die "gh not authenticated (gh auth login)"
  echo "  Will publish AAB to $GH_REPO and enable Pages -> $SITE"
  read -r -p "  Type PUSH to proceed: " C
  if [ "$C" = "PUSH" ]; then
    rm -rf "$WORK"; mkdir -p "$WORK/repo"
    # stage the deliverable (exclude scratch/logs)
    for f in "$PAGE" "$MJ" "$CFF" "$CONTRACT" "CONTEXT.md" "$README" "$BACKLOG" "LICENSES.md"; do
      [ -f "$f" ] && cp -f "$f" "$WORK/repo/"; done
    mkdir -p "$WORK/repo/$PROV"; cp -f "$PROV"/*.ots "$WORK/repo/$PROV/" 2>/dev/null || true
    touch "$WORK/repo/$PROV/.gitkeep"
    cp -f "$(basename "$0")" "$WORK/repo/" 2>/dev/null || true
    ( cd "$WORK/repo"
      git init -q; git add -A; git commit -q -m "AAB Sprint 0 — executable AI·Human co-development studio"
      if gh repo view "$GH_REPO" >/dev/null 2>&1; then
        git remote add origin "https://github.com/$GH_REPO.git"
        git branch -M main; git push -u origin main --force 2>>"$LOG" && echo "  pushed to existing repo"
      else
        gh repo create "$GH_REPO" --public --source=. --push 2>>"$LOG" && echo "  repo created + pushed"
      fi
      gh api -X POST "repos/$GH_REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
        && echo "  Pages enabled" || echo "  (Pages may already be enabled)"
    )
    st "live at: $SITE"
  else st "push skipped by user"; fi
fi

# 5. publish DOI + inject + OTS
if [ "$DO_PUBLISH" = "1" ]; then
  hd "5. MINT DOI (irreversible)"
  [ -n "$MISTY" ] || die "misty not installed"
  [ -n "${ZENODO_TOKEN:-}" ] || die "ZENODO_TOKEN not set"
  echo "  ============================================================"
  echo "   MINT A PERMANENT DOI ON PRODUCTION ZENODO  (irreversible)"
  echo "   Artifact: $PAGE   SHA-256: $SHA"
  echo "  ============================================================"
  read -r -p "  Type MINT to proceed: " C
  [ "$C" = "MINT" ] || { st "mint aborted"; exit 0; }
  "$MISTY" publish -m "$MJ" -f "$PAGE" --package-dir ".doi-package" --output "misty_result.json" 2>&1 | tee -a "$LOG"
  DOI="$(python3 -c "import json;print(json.load(open('misty_result.json'))['doi'])" 2>/dev/null || true)"
  [ -n "$DOI" ] || die "could not read DOI"
  st "DOI MINTED: $DOI"; echo "$DOI" > ZENODO_DOI.txt
  for f in "$PAGE" "$CONTRACT" "$CFF"; do
    grep -q "$PLACEHOLDER" "$f" && python3 - "$f" "$PLACEHOLDER" "$DOI" <<'PY'
import sys;p,ph,doi=sys.argv[1:4];s=open(p,encoding='utf-8').read();open(p,'w',encoding='utf-8').write(s.replace(ph,doi));print("   injected into",p)
PY
  done
  hd "6. OPENTIMESTAMPS"
  if "$MISTY" ots stamp "$PAGE" 2>>"$LOG"; then [ -f "$PAGE.ots" ] && mv -f "$PAGE.ots" "$PROV/"; st "ots: $PROV/$PAGE.ots"
  elif command -v ots >/dev/null 2>&1; then ots stamp "$PAGE" && mv -f "$PAGE.ots" "$PROV/" 2>/dev/null; st "ots: $PROV/$PAGE.ots"
  else st "OTS skipped (install misty-doi[ots])"; fi
  st "REMINDER: re-run --push to publish the DOI-injected page + provenance/*.ots"
fi

# 7. open backlog issues
if [ "$DO_ISSUES" = "1" ]; then
  hd "7. OPEN SPRINT-1 BACKLOG ISSUES on $GH_REPO"
  command -v gh >/dev/null 2>&1 || die "gh not found"
  gh repo view "$GH_REPO" >/dev/null 2>&1 || die "repo $GH_REPO not found — run --push first"
  # extract '- [ ] **aab#N title** — body' lines from Sprint 1 section
  mapfile -t ITEMS < <(awk '/## Sprint 1/{f=1;next}/^## /{f=0}f&&/- \[ \]/{sub(/^- \[ \] /,"");print}' "$BACKLOG")
  echo "  ${#ITEMS[@]} candidate issues found:"; printf '   • %s\n' "${ITEMS[@]}"
  read -r -p "  Type YES to open these as GitHub issues: " C
  if [ "$C" = "YES" ]; then
    for it in "${ITEMS[@]}"; do
      title="$(echo "$it" | sed -E 's/\*\*//g; s/ — .*//')"
      body="$(echo "$it" | sed -E 's/^.*— //')"
      gh issue create -R "$GH_REPO" -t "$title" -b "$body"$'\n\n(From BACKLOG.md · Sprint 1)' 2>>"$LOG" \
        && echo "   opened: $title" || echo "   FAILED: $title"
    done
  else st "issue creation skipped"; fi
fi

hd "DONE"
echo "  studio : $SCRIPT_DIR/$PAGE"
[ -f ZENODO_DOI.txt ] && echo "  DOI    : $(cat ZENODO_DOI.txt)"
echo "  log    : $LOG"
echo "  Zistgah ecosystem · systems, not just software · maintain contract and context."

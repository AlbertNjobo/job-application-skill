#!/bin/bash
# Validate job application outputs.
#
# Usage: bash validate-output.sh <role-slug> [company-name] [output-dir]
#
# The working directory (where soul.md and tracker.md live) defaults to the
# current directory. Override with the JOB_APP_DIR environment variable.
#
# Matching is case and separator insensitive, so the slug "ebanking-graduate-trainee"
# matches a file named "Jane_Doe_EBanking_Graduate_Trainee_CV.pdf".

WORKDIR="${JOB_APP_DIR:-$PWD}"
SLUG="${1:-}"
COMPANY="${2:-}"
OUTDIR="${3:-$WORKDIR}"
ERRORS=0
WARNINGS=0

if [ -z "$SLUG" ]; then
  echo "Usage: bash validate-output.sh <role-slug> [company-name] [output-dir]"
  echo "       JOB_APP_DIR=/path/to/resources bash validate-output.sh ..."
  exit 1
fi

if [ ! -d "$OUTDIR" ]; then
  echo "✗ Output directory does not exist: $OUTDIR"
  exit 1
fi

# Reduce a string to lowercase alphanumerics so hyphens, underscores and
# capitalisation stop mattering when comparing slugs against filenames.
norm() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9'; }

NSLUG=$(norm "$SLUG")
NCOMPANY=$(norm "$COMPANY")

# Print the first PDF whose normalised basename contains $1 but not $2.
find_pdf() {
  local needle="$1" exclude="$2" f base
  for f in "$OUTDIR"/*.pdf; do
    [ -e "$f" ] || continue
    base=$(norm "$(basename "$f" .pdf)")
    case "$base" in
      *"$needle"*)
        if [ -n "$exclude" ]; then
          case "$base" in *"$exclude"*) continue ;; esac
        fi
        printf '%s\n' "$f"
        return 0
        ;;
    esac
  done
  return 1
}

echo "=== Validating: $SLUG ==="
echo "    output dir:  $OUTDIR"
echo "    working dir: $WORKDIR"
echo ""

# --- YAML ---
YAML=""
for f in "$OUTDIR"/*.yaml; do
  [ -e "$f" ] || continue
  case "$(norm "$(basename "$f" .yaml)")" in
    *"$NSLUG"*) YAML="$f"; break ;;
  esac
done

if [ -n "$YAML" ]; then
  echo "✓ YAML exists: $(basename "$YAML")"
  if grep -q '—' "$YAML"; then
    echo "✗ Em dashes found in YAML"
    ERRORS=$((ERRORS + 1))
  else
    echo "✓ No em dashes in YAML"
  fi
else
  echo "✗ YAML missing for slug: $SLUG"
  ERRORS=$((ERRORS + 1))
fi

# --- CV PDF (exclude cover letters) ---
CV_PDF=$(find_pdf "$NSLUG" "coverletter")
if [ -n "$CV_PDF" ]; then
  echo "✓ CV PDF exists: $(basename "$CV_PDF")"
  if command -v pdfinfo >/dev/null 2>&1; then
    PAGES=$(pdfinfo "$CV_PDF" | awk '/^Pages/{print $2}')
    if [ "${PAGES:-0}" -ge 1 ] && [ "${PAGES:-0}" -le 2 ]; then
      echo "✓ CV page count: $PAGES"
    else
      echo "✗ CV page count: $PAGES (expected 1 or 2)"
      ERRORS=$((ERRORS + 1))
    fi
  fi
  if command -v pdftotext >/dev/null 2>&1; then
    if pdftotext "$CV_PDF" - 2>/dev/null | grep -q '—'; then
      echo "✗ Em dashes found in rendered CV"
      ERRORS=$((ERRORS + 1))
    else
      echo "✓ No em dashes in rendered CV"
    fi
  fi
else
  echo "✗ CV PDF missing for slug: $SLUG"
  ERRORS=$((ERRORS + 1))
fi

# --- Cover letter ---
if [ -n "$COMPANY" ]; then
  CL_PDF=$(find_pdf "coverletter$NCOMPANY" "")
  [ -z "$CL_PDF" ] && CL_PDF=$(find_pdf "$NCOMPANY" "")
  if [ -n "$CL_PDF" ] && [ "$CL_PDF" != "$CV_PDF" ]; then
    echo "✓ Cover letter exists: $(basename "$CL_PDF")"
    if command -v pdfinfo >/dev/null 2>&1; then
      CL_PAGES=$(pdfinfo "$CL_PDF" | awk '/^Pages/{print $2}')
      if [ "${CL_PAGES:-0}" -eq 1 ]; then
        echo "✓ Cover letter is 1 page"
      else
        echo "✗ Cover letter is $CL_PAGES pages (expected 1)"
        ERRORS=$((ERRORS + 1))
      fi
    fi
    if command -v pdftotext >/dev/null 2>&1; then
      WORDS=$(pdftotext "$CL_PDF" - 2>/dev/null | wc -w)
      if [ "$WORDS" -ge 250 ] && [ "$WORDS" -le 400 ]; then
        echo "✓ Cover letter word count: $WORDS"
      else
        echo "! Cover letter word count: $WORDS (target 250-400)"
        WARNINGS=$((WARNINGS + 1))
      fi
      if pdftotext "$CL_PDF" - 2>/dev/null | grep -q '—'; then
        echo "✗ Em dashes found in cover letter"
        ERRORS=$((ERRORS + 1))
      else
        echo "✓ No em dashes in cover letter"
      fi
    fi
  else
    echo "✗ Cover letter missing for company: $COMPANY"
    ERRORS=$((ERRORS + 1))
  fi
fi

# --- Registry and tracker ---
if [ -f "$WORKDIR/soul.md" ]; then
  if grep -qi "$SLUG" "$WORKDIR/soul.md"; then
    echo "✓ soul.md registry updated"
  else
    echo "✗ soul.md registry not updated for: $SLUG"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "! soul.md not found in $WORKDIR (set JOB_APP_DIR?)"
  WARNINGS=$((WARNINGS + 1))
fi

if [ -n "$COMPANY" ] && [ -f "$WORKDIR/tracker.md" ]; then
  HITS=$(grep -ci "$COMPANY" "$WORKDIR/tracker.md" || true)
  if [ "${HITS:-0}" -eq 0 ]; then
    echo "✗ tracker.md has no row for: $COMPANY"
    ERRORS=$((ERRORS + 1))
  else
    echo "✓ tracker.md updated ($HITS matching line(s))"
    if [ "$HITS" -gt 1 ]; then
      echo "! $COMPANY appears $HITS times, check for a duplicate application"
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
fi

# --- Lapsed deadlines anywhere in the tracker ---
if [ -f "$WORKDIR/tracker.md" ]; then
  TODAY=$(date +%Y-%m-%d)
  THISYEAR=$(date +%Y)
  LAPSED=$(awk -v today="$TODAY" -v thisyear="$THISYEAR" '
    # Skip rows already dealt with.
    /Applied|Rejected|Withdrawn|Offer/ { next }
    # Only consider rows that still represent pending work.
    !/Ready to apply|Apply/ { next }
    {
      # A row may carry its own context year via a leading ISO date.
      year = thisyear
      if (match($0, /20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]/))
        year = substr($0, RSTART, 4)

      line = $0
      # Walk every "Mon DD" or "Mon DD, YYYY" occurrence on the line.
      while (match(line, /[A-Z][a-z][a-z] [0-9]+(,? 20[0-9][0-9])?/)) {
        d = substr(line, RSTART, RLENGTH)
        line = substr(line, RSTART + RLENGTH)
        gsub(/,/, "", d)
        if (d !~ /20[0-9][0-9]/) d = d " " year
        cmd = "date -d \"" d "\" +%Y-%m-%d 2>/dev/null"
        iso = ""
        cmd | getline iso
        close(cmd)
        if (iso != "" && iso < today) { print "    " $0; next }
      }
    }' "$WORKDIR/tracker.md")
  if [ -n "$LAPSED" ]; then
    echo "! Lapsed deadlines still marked \"Ready to apply\":"
    printf '%s\n' "$LAPSED"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "✓ No lapsed deadlines pending"
  fi
fi

echo ""
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "All checks passed ✓"
elif [ $ERRORS -eq 0 ]; then
  echo "Passed with $WARNINGS warning(s)"
else
  echo "$ERRORS error(s), $WARNINGS warning(s)"
  exit 1
fi

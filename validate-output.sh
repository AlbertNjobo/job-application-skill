#!/bin/bash
# Validate job application outputs
# Usage: bash validate-output.sh <role-slug> <company-name>

RESOURCES="/home/lawrence/Documents/Personal Documents/Resources"
SLUG="${1:-}"
COMPANY="${2:-}"
ERRORS=0

if [ -z "$SLUG" ]; then
  echo "Usage: bash validate-output.sh <role-slug> <company-name>"
  exit 1
fi

echo "=== Validating outputs for: $SLUG ==="

# Check YAML exists
YAML="$RESOURCES/lawrence-njobo-$SLUG.yaml"
if [ -f "$YAML" ]; then
  echo "✓ YAML exists: $YAML"
else
  echo "✗ YAML missing: $YAML"
  ERRORS=$((ERRORS + 1))
fi

# Check CV PDF exists
CV_PDF="$RESOURCES/Lawrence_Njobo_"*"$SLUG"*".pdf" 2>/dev/null
if ls $RESOURCES/Lawrence_Njobo_*"$SLUG"*.pdf 1>/dev/null 2>&1; then
  echo "✓ CV PDF exists"
else
  echo "✗ CV PDF missing"
  ERRORS=$((ERRORS + 1))
fi

# Check for em dashes in YAML
if [ -f "$YAML" ] && grep -q '—' "$YAML"; then
  echo "✗ Em dashes found in YAML"
  ERRORS=$((ERRORS + 1))
else
  echo "✓ No em dashes in YAML"
fi

# Check cover letter if company provided
if [ -n "$COMPANY" ]; then
  CL_PDF="$RESOURCES/Lawrence_Albert_Njobo_Cover_Letter_$COMPANY.pdf"
  if [ -f "$CL_PDF" ]; then
    echo "✓ Cover letter exists: $CL_PDF"
  else
    echo "✗ Cover letter missing: $CL_PDF"
    ERRORS=$((ERRORS + 1))
  fi
fi

# Check soul.md was updated
if grep -q "$SLUG" "$RESOURCES/soul.md" 2>/dev/null; then
  echo "✓ soul.md updated"
else
  echo "✗ soul.md not updated"
  ERRORS=$((ERRORS + 1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "All checks passed ✓"
else
  echo "$ERRORS issue(s) found"
fi

#!/usr/bin/env bash
# Setup script for the job-application skill.
#
# Installs Python dependencies without touching your system Python.
# By default it creates a virtualenv at ./.venv in the current directory.
#
#   bash setup.sh                 # create/use ./.venv
#   VENV=~/.venvs/jobs bash setup.sh
#   NO_VENV=1 bash setup.sh       # install into the active environment instead

set -u

PACKAGES="rendercv reportlab pdf2image pillow pypdf"
VENV="${VENV:-.venv}"

echo "=== Job Application Skill Setup ==="
echo ""

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: Python 3 is required but not installed."
  exit 1
fi
echo "Python 3: $(python3 --version)"

# --- Resolve where to install ---
if [ "${NO_VENV:-0}" = "1" ]; then
  echo "NO_VENV=1, installing into the active Python environment."
  PY="python3"
elif [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "Active virtualenv detected: $VIRTUAL_ENV"
  PY="python3"
else
  if [ ! -d "$VENV" ]; then
    echo "Creating virtualenv: $VENV"
    if ! python3 -m venv "$VENV" 2>/dev/null; then
      echo "ERROR: could not create a virtualenv."
      echo "  Debian/Ubuntu: sudo apt install python3-venv"
      echo "  Or re-run with NO_VENV=1 to install into the current environment."
      exit 1
    fi
  else
    echo "Reusing virtualenv: $VENV"
  fi
  PY="$VENV/bin/python"
fi

echo ""
echo "Installing: $PACKAGES"
if ! "$PY" -m pip install --upgrade pip >/dev/null 2>&1; then
  echo "WARNING: could not upgrade pip, continuing."
fi
if ! "$PY" -m pip install $PACKAGES; then
  echo ""
  echo "ERROR: dependency installation failed."
  echo "If you saw 'externally-managed-environment', let this script create a"
  echo "virtualenv (do not pass NO_VENV=1), or use pipx for rendercv."
  exit 1
fi

# --- LaTeX check (rendercv needs it to produce PDFs) ---
echo ""
if command -v xelatex >/dev/null 2>&1; then
  echo "LaTeX (xelatex): installed"
elif command -v pdflatex >/dev/null 2>&1; then
  echo "LaTeX (pdflatex): installed"
else
  echo "WARNING: LaTeX not found. rendercv requires it to generate PDFs."
  echo "  Debian/Ubuntu: sudo apt install texlive-xetex texlive-fonts-recommended"
  echo "  Fedora:        sudo dnf install texlive-xetex texlive-collection-fontsrecommended"
  echo "  macOS:         brew install --cask mactex"
fi

# --- Optional tools used by validate-output.sh ---
if ! command -v pdfinfo >/dev/null 2>&1 || ! command -v pdftotext >/dev/null 2>&1; then
  echo ""
  echo "NOTE: poppler-utils not found. validate-output.sh will skip page count"
  echo "      and word count checks without it."
  echo "  Debian/Ubuntu: sudo apt install poppler-utils"
  echo "  macOS:         brew install poppler"
fi

echo ""
echo "=== Setup complete ==="
if [ "$PY" != "python3" ]; then
  echo ""
  echo "Activate the environment before rendering:"
  echo "  source $VENV/bin/activate"
fi
echo ""
echo "Next steps:"
echo "  1. Create soul.md in your working directory (see references/soul-template.md)"
echo "  2. Copy scripts/generate_cover_letters.py there and add your LETTERS entries"
echo "  3. Generate ONE letter at a time, never the whole dict:"
echo "     python3 -c \"import generate_cover_letters as g; g.build_pdf('KEY')\""
echo "  4. Validate: bash scripts/validate-output.sh <role-slug> <company> [output-dir]"

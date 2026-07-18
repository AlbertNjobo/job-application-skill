#!/bin/bash
# Setup script for job-application skill
# Installs all required dependencies

echo "=== Job Application Skill Setup ==="
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is required but not installed."
    exit 1
fi
echo "Python 3: $(python3 --version)"

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "ERROR: pip3 is required but not installed."
    exit 1
fi

# Install Python dependencies
echo ""
echo "Installing Python packages..."
pip3 install rendercv reportlab pdf2image pillow pypdf 2>&1 | tail -5

# Check LaTeX (needed by rendercv)
echo ""
if command -v xelatex &> /dev/null; then
    echo "LaTeX (xelatex): installed"
elif command -v pdflatex &> /dev/null; then
    echo "LaTeX (pdflatex): installed"
else
    echo "WARNING: LaTeX not found. rendercv requires LaTeX to generate PDFs."
    echo "Install with: sudo apt install texlive-xetex texlive-fonts-recommended"
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Usage:"
echo "  1. Edit generate_cover_letters.py (add your cover letter entries)"
echo "  2. Edit merge_certificates.py (add your certificate files)"
echo "  3. Run: python3 generate_cover_letters.py"
echo "  4. Run: python3 merge_certificates.py"

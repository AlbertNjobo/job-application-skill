# Job Application Skill

An AI agent skill that automates the full job application pipeline. First-time setup builds your master resume from your resume, LinkedIn, GitHub, and portfolio. Then every application is one command.

## What It Does

### First Time
1. Asks for your resume, LinkedIn, GitHub, portfolio
2. Creates `soul.md` (master resume) from that information
3. You verify and adjust

### Every Application
1. Parses the job description for keywords
2. Generates a tailored CV (RenderCV YAML → PDF)
3. Creates a cover letter (ReportLab → PDF)
4. Outputs portal skills/certifications table
5. Tracks applications with status
6. Validates all outputs

## Installation

### Step 1: Install Dependencies
```bash
# Clone the repo
git clone https://github.com/AlbertNjobo/job-application-skill.git
cd job-application-skill

# Run setup script
bash scripts/setup.sh
```

Or manually:
```bash
pip3 install rendercv reportlab pdf2image pillow pypdf

# LaTeX is required for RenderCV to generate PDFs
# Ubuntu/Debian:
sudo apt install texlive-xetex texlive-fonts-recommended
# macOS:
brew install --cask mactex
```

### Step 2: Install the Skill

Copy to your agent's skills directory:

```bash
# Claude Code
cp -r job-application-skill ~/.claude/skills/job-application

# OpenCode / MiMo
cp -r job-application-skill ~/.opencode/skills/job-application

# Codex
cp -r job-application-skill ~/.codex/skills/job-application

# Cursor
cp -r job-application-skill ~/.cursor/skills/job-application
```

Or clone directly:
```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.claude/skills/job-application
```

### Step 3: Configure Scripts

Edit `generate_cover_letters.py`:
```python
LETTERS = {
    "MY_COMPANY": {
        "filename": "MyName_Cover_Letter_MyCompany.pdf",
        "recipient": ["The Hiring Manager", "Company Name", "City, Country"],
        "re": "Re: Job Title (req12345)",
        "paragraphs": ["Hook...", "Body 1...", "Body 2...", "Closing..."],
    },
}
```

Edit `merge_certificates.py`:
```python
CERTS = [
    ("my-cert.pdf", "My Certification Name"),
    ("my-cert.png", "Another Certification"),
]
```

## Usage

**First time** — say:
> "Set up job application" or "Create my master resume"

**Every time after** — share a job description and say:
> "Apply for this job" or "Create application for this role"

## File Structure

```
job-application-skill/
├── SKILL.md                    # Main skill definition
├── README.md                   # This file
├── generate_cover_letters.py   # Cover letter PDF generator
├── merge_certificates.py       # Certificate merger
├── references/
│   ├── soul-template.md        # Master resume template
│   ├── yaml-template.md        # RenderCV YAML structure
│   ├── cover-letter-template.md # Cover letter format
│   ├── bullet-formulas.md      # Technical bullet writing
│   └── tailoring-checklist.md  # Pre-submission checks
└── scripts/
    ├── setup.sh                # Dependency installer
    └── validate-output.sh      # Output validation
```

## Dependencies

| Package | Purpose | Install |
|---------|---------|---------|
| rendercv | CV generation from YAML | `pip install rendercv` |
| reportlab | PDF generation | `pip install reportlab` |
| pdf2image | PDF to image conversion | `pip install pdf2image` |
| pillow | Image processing | `pip install pillow` |
| pypdf | PDF reading | `pip install pypdf` |
| xelatex | LaTeX compiler (for rendercv) | `sudo apt install texlive-xetex` |

## License

MIT

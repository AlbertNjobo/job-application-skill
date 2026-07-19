# Job Application Skill

An AI agent skill that automates CV tailoring, cover letter generation, and application tracking. For application portals, it generates a ready-to-paste skills table (no automated form-filling).

## Install

### Option 1: CLI Install (Recommended)

```bash
# Install globally (works across all projects)
npx skills add AlbertNjobo/job-application-skill -g -y

# Install to current project only
npx skills add AlbertNjobo/job-application-skill -y
```

### Option 2: Manual Install

```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git
mkdir -p ~/.claude/skills
cp -r job-application-skill/* ~/.claude/skills/job-application/
```

### Dependencies

```bash
pip3 install rendercv reportlab pdf2image pillow pypdf

# LaTeX (required by rendercv)
sudo apt install texlive-xetex texlive-fonts-recommended  # Linux
brew install --cask mactex  # macOS
```

## Usage

**First time** — say:
> "Set up job application" or "Create my master resume"

**Every time after** — share a job description and say:
> "Apply for this job" or "Create application for this role"

## What It Does

### First Time
1. Asks for your resume, LinkedIn, GitHub, portfolio
2. Creates `soul.md` (master resume) automatically
3. You verify and adjust

### Every Application
1. Parses the job description for keywords
2. Generates a tailored CV (RenderCV YAML → PDF)
3. Creates a cover letter (ReportLab → PDF)
4. Outputs a skills/certifications table you can paste into the portal
5. Tracks applications in `tracker.md`
6. Validates everything (em dashes, page counts)

### What It Does NOT Do
- Does not fill out application forms automatically (portals are login-walled and fragile)
- Does not submit applications on your behalf
- Does not track interview rounds or offers (just application status)

## How It Works

**soul.md** is your master resume — one file with everything. When you apply, the agent selects only what's relevant. Write once, apply everywhere.

**tracker.md** logs every application with date, company, role, status, and files produced.

## Files

```
job-application-skill/
├── SKILL.md                    # Agent instructions
├── generate_cover_letters.py   # Edit LETTERS dict, run for PDF
├── merge_certificates.py       # Edit CERTS list, run for PDF
├── references/
│   ├── soul-template.md        # Master resume template
│   ├── yaml-template.md        # RenderCV YAML structure
│   ├── cover-letter-template.md # Cover letter format
│   ├── bullet-formulas.md      # Technical bullet writing
│   └── tailoring-checklist.md  # Pre-submission checks
└── scripts/
    ├── setup.sh               # One-command dependency installer
    └── validate-output.sh     # Output validation
```

## License

MIT

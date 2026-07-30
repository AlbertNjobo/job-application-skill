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

**soul.md** is your master resume: one file holding everything true about you. When you
apply, the agent selects only what is relevant. Write once, apply everywhere. It is also
the anti-fabrication boundary. The agent may reorder, emphasise and rephrase what is in
`soul.md`, but may not assert anything that is not.

**tracker.md** logs every application with date, company, role, status, and deadline.

Nothing in this repo contains your personal data. Your details live in `soul.md` in your
own working directory, which you should keep out of version control.

## Setup

```bash
mkdir ~/job-applications && cd ~/job-applications
bash ~/.claude/skills/job-application/scripts/setup.sh   # creates ./.venv
source .venv/bin/activate

cp ~/.claude/skills/job-application/scripts/generate_cover_letters.py .
cp ~/.claude/skills/job-application/references/soul-template.md soul.md
```

Fill in `soul.md`, or let the agent build it from your resume and LinkedIn on first run.
Then work in that directory and the agent will find everything it needs.

> **Note:** `scripts/generate_cover_letters.py` is a template. Copy it into your working
> directory and edit the copy. Never run it as `python3 generate_cover_letters.py` once it
> holds real entries: the `__main__` block rewrites every letter in the dict, including
> ones you have already sent. Generate a single letter instead:
>
> ```bash
> python3 -c "import generate_cover_letters as g; g.build_pdf('YOUR_KEY')"
> ```

## Files

```
job-application-skill/
├── SKILL.md                        # Agent instructions
├── references/
│   ├── soul-template.md            # Master resume template
│   ├── yaml-template.md            # RenderCV YAML structure + naming conventions
│   ├── cover-letter-template.md    # Cover letter format
│   ├── bullet-formulas.md          # Technical bullet writing
│   └── tailoring-checklist.md      # Pre-submission checks
└── scripts/
    ├── generate_cover_letters.py   # Template: copy to your working dir, edit LETTERS
    ├── merge_certificates.py       # Template: copy to your working dir, edit CERTS
    ├── setup.sh                    # Dependency installer (virtualenv by default)
    └── validate-output.sh          # Output validation
```

## Validation

```bash
bash scripts/validate-output.sh <role-slug> [company] [output-dir]
```

Checks that the YAML and both PDFs exist, that page counts and cover letter length are in
range, that no em dashes slipped through, that the tracker and registry were updated, and
that no deadline already marked "Ready to apply" has lapsed. Set `JOB_APP_DIR` if your
`soul.md` is not in the current directory.

## Requirements

- Python 3.9+, and LaTeX for `rendercv` PDF output
- `poppler-utils` (`pdfinfo`, `pdftotext`) for the validator's page and word count checks

## License

MIT, see [LICENSE](LICENSE).

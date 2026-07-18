# Job Application Skill

An AI agent skill that automates the full job application pipeline. First-time setup builds your master resume from your resume, LinkedIn, GitHub, and portfolio. Then every application is one command.

## Install

### Option 1: npx (easiest)

Paste this into your AI agent:

```
npx job-application-skill
```

That's it. It detects your agent and installs automatically.

### Option 2: git clone

```
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.claude/skills/job-application
```

Replace `~/.claude/skills/` with your agent's skills directory.

### Dependencies (installed automatically)

```
pip3 install rendercv reportlab pdf2image pillow pypdf
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
4. Outputs portal skills/certifications table
5. Tracks applications with status
6. Validates everything (em dashes, page counts)

## How It Works

**soul.md** is your master resume — one file with everything. When you apply, the agent selects only what's relevant. Write once, apply everywhere.

## Files

```
job-application-skill/
├── SKILL.md                    # Agent instructions
├── package.json                # npm package manifest
├── bin/install.js              # npx install script
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

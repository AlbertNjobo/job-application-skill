# Job Application Skill

An AI agent skill that automates CV tailoring, cover letter generation, and application tracking. For application portals, it generates a ready-to-paste skills table (no automated form-filling).

## Install

### Option 1: Claude Code plugin marketplace

Inside Claude Code:

```
/plugin marketplace add AlbertNjobo/job-application-skill
/plugin install job-application@albertnjobo
```

Restart Claude Code afterwards so the skill loads. Update later with
`/plugin marketplace update albertnjobo`.

### Option 2: CLI Install (any agent)

```bash
# Install globally (works across all projects)
npx skills add AlbertNjobo/job-application-skill -g -y

# Install to current project only
npx skills add AlbertNjobo/job-application-skill -y
```

### Option 3: Manual Install

```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git
mkdir -p ~/.claude/skills/job-application
cp -r job-application-skill/skills/job-application/* ~/.claude/skills/job-application/
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

The simplest route is to open your agent in a new directory and say
*"set up job application"*. It knows where its own files are and will do the rest.

To do it by hand, resolve the skill directory first, since it differs by install method:

```bash
SKILL_DIR=$(find ~/.claude/skills/job-application \
                 ~/.claude/plugins/cache/albertnjobo \
                 -name SKILL.md -path '*job-application*' 2>/dev/null | head -1 | xargs dirname)
echo "$SKILL_DIR"   # sanity check: should print a directory, not empty

mkdir ~/job-applications && cd ~/job-applications
bash "$SKILL_DIR/scripts/setup.sh"    # creates ./.venv
source .venv/bin/activate

cp "$SKILL_DIR/scripts/generate_cover_letters.py" .
cp "$SKILL_DIR/references/soul-template.md" soul.md
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

Your working directory should look like this. Only `soul.md`, `tracker.md` and your copy
of `generate_cover_letters.py` are yours to edit; everything under `applications/` is
generated.

```
working-dir/
├── soul.md                     # master resume, never commit this
├── tracker.md                  # application log
├── generate_cover_letters.py   # your LETTERS dict
├── .gitignore
├── applications/
│   ├── active/                 # prepared, not yet sent
│   ├── YYYY-MM-DD/             # a batch prepared on one day
│   └── archive/                # sent or closed out
└── personal-docs/              # ID, transcripts, certificates
```

`rendercv` leaves a `*_rendercv_output/` folder per render containing Typst source, PNGs and
HTML. Copy the PDF out, then delete the folder: it is reproducible from the YAML in seconds,
and left alone these folders dominate the directory. Step 1.7 of SKILL.md has a check that
confirms no build folder holds the only copy of a PDF before you delete any of them.

## Repository layout

```
job-application-skill/
├── .claude-plugin/
│   ├── plugin.json                     # Claude Code plugin manifest
│   └── marketplace.json                # Lets this repo serve as its own marketplace
└── skills/
    └── job-application/
        ├── SKILL.md                    # Agent instructions
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

The `skills/job-application/` nesting is what lets one repository serve both install
routes. Claude Code's plugin loader expects skills under `skills/`, and the `skills` CLI
falls back to searching subdirectories when there is no `SKILL.md` at the repository root,
so `npx skills add` resolves to the same skill.

The two routes install to different places:

| Installed via | Skill lives at |
|---|---|
| `npx skills add` or manual | `~/.claude/skills/job-application/` |
| `/plugin install` | `~/.claude/plugins/cache/albertnjobo/job-application/<version>/skills/job-application/` |

The plugin path contains the version, so it changes on every release. Use `$SKILL_DIR`
from the Setup section rather than hardcoding either.

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

---
name: job-application
description: Automates the full job application pipeline. Use when the user shares a job URL or pasted description and says "apply for", "create application for", "tailor CV for", or asks about portal skills/certifications. Produces tailored CV, cover letter, portal recommendations, and tracks applications. Also use when user says "set up job application" or "create my master resume".
---

# Job Application Skill

Automates the full job application workflow: master resume creation, CV tailoring, cover letter generation, portal skills recommendation, and application tracking.

## First-Time Setup

When invoked for the first time (no soul.md exists), run the setup flow:

### Step 1: Gather Information
Ask the user for (or offer to extract from):
- **Resume/CV** (PDF or text) — paste or upload
- **LinkedIn profile URL** — fetch with agent-reach skill
- **GitHub profile URL** — fetch with agent-reach skill
- **Portfolio website URL** — fetch with agent-reach skill

### Step 2: Create soul.md
Read `references/soul-template.md` for the structure. Fill in all sections using the gathered information. Save as `soul.md` in the working directory.

The agent should:
- Extract contact info from LinkedIn/resume
- Pull work experience bullets from resume
- List all certifications found
- Gather projects from GitHub
- Group skills by category
- Set writing rules defaults (no em dashes, 1-page cover letters, 2-page CVs)

### Step 3: Confirm
Show the user the created soul.md and ask them to verify accuracy and add anything missing.

## Ongoing Workflow (soul.md exists)

### Step 1: Parse Job Description
Extract: company, role, req ID, location, hard skills, soft skills, ATS keywords.

### Step 1.5: Check for Existing Work
Before creating anything:

**a. Same role already prepared?** Look for `<name-slug>-<role-slug>.yaml`, `<Name_Slug>_<Role_Slug>_CV.pdf`, and `<Name_Slug>_Cover_Letter_<Company>.pdf` in the working directory and in any dated subfolders. If they exist and the user hasn't asked for changes, skip regeneration and go to Step 5.

**b. Same company applied to before?** Grep `tracker.md` for the company name. If there is a prior application, tell the user before proceeding. Two applications to one company in quick succession may be deliberate, but it is their call to make, not an accident to discover later.

**c. Any deadlines already lapsed?** Compare every deadline in `tracker.md` against today's date. Report expired rows still marked "Ready to apply" so they can be closed out or chased.

### Step 1.6: Choose the Output Directory
Ask or infer where the files go. Two supported layouts:
- **Flat** (default): straight into the working directory.
- **Dated batch:** `applications-YYYY-MM-DD/` when preparing several applications at once. Set `output_folder` in each YAML's `settings.render_command` to a subfolder of that directory, and override `OUTPUT_DIR` when generating cover letters (see Step 4).

Pass the chosen directory to `validate-output.sh` as its third argument.

### Step 2: Create Tailored CV YAML
Read `references/yaml-template.md` for structure and `references/bullet-formulas.md` for writing strong bullets.

Key rules:
- Only include relevant experiences, projects, certifications from soul.md
- ATS keywords in summary, skills, and experience bullets
- Use the technical bullet formula: Action + What + Scale/Impact + Tech
- Skills grouped by category
- No em dashes, no personal pronouns in bullets

### Step 3: Render CV PDF
```bash
rendercv render <name-slug>-<role-slug>.yaml
```
Then copy the result out of the rendercv output folder to a descriptive name:
```bash
cp <output_folder>/<Name>_CV.pdf <Name_Slug>_<Role_Slug>_CV.pdf
```

### Step 4: Generate Cover Letter

Add an entry to the LETTERS dict in the **working directory's** `generate_cover_letters.py`
(see `references/cover-letter-template.md` for the entry format).
`scripts/generate_cover_letters.py` is only the bootstrap template. Never edit it for a live application.

<!-- DANGER -->
**Never run `python3 generate_cover_letters.py`.** Its `__main__` block loops over every
entry in LETTERS and rewrites all of them. Letters for applications already submitted
would be silently overwritten. Generate only the new key, in-process:

```bash
python3 -c "
import generate_cover_letters as g
g.build_pdf('<NEW_KEY>')
"
```

To write into a dated batch folder, override the output directory in the same call:

```bash
python3 -c "
import generate_cover_letters as g
g.OUTPUT_DIR = '<absolute-path-to-output-dir>'
g.build_pdf('<NEW_KEY>')
"
```

Afterwards, confirm nothing else was touched:
```bash
find . -maxdepth 1 -name "*Cover_Letter*.pdf" -newermt "today" | wc -l
```

Each LETTERS entry may carry its own `"date"` key. Entries without one fall back to the
default in `build_pdf`, so adding a date to a new letter never alters existing letters.

### Step 5: Portal Skills Table
Output table of skills/certifications to enter in the application portal.

### Step 6: Update Tracker
Add entry to your portfolio registry with status (Ready to apply / Applied / deadline).

### Step 7: Validate
```bash
bash scripts/validate-output.sh <role-slug> [company] [output-dir]
```
Matching is case and separator insensitive, so the hyphenated slug `ebanking-graduate-trainee`
correctly matches `Jane_Doe_EBanking_Graduate_Trainee_CV.pdf`. Omit `output-dir` for the
flat layout; pass the batch folder when using a dated one.

Read `references/tailoring-checklist.md` before final submission.

## Source Files

Live files (in the user's working directory, edited per application):

| File | Purpose |
|------|---------|
| `soul.md` | Master resume and single source of truth. Never assert a fact absent from it. |
| `tracker.md` | Application log: status, deadlines, company history |
| `generate_cover_letters.py` | Live LETTERS dict. Edit this one. |
| `merge_certificates.py` | Certificate PDF merger |

Skill files (templates and tooling, not edited per application):

| File | Purpose |
|------|---------|
| `scripts/generate_cover_letters.py` | Bootstrap template for the live file above |
| `scripts/merge_certificates.py` | Bootstrap template |
| `scripts/validate-output.sh` | Output validator |
| `scripts/setup.sh` | Dependency installer |
| `references/*.md` | YAML structure, bullet formulas, letter format, checklist |

## Quarterly Review

Every 3 months, review and update:

- **soul.md:** Add new projects, certifications, update metrics in experience bullets
- **Base YAMLs:** Refresh templates if skills or experience changed significantly
- **Portfolio:** Update your portfolio site with new achievements
- **Archive:** Move submitted applications older than 6 months to archive folder

## Output Checklist
- [ ] soul.md created and verified
- [ ] YAML file exists
- [ ] CV PDF is correct page count
- [ ] Cover letter is 1 page
- [ ] Zero em dashes
- [ ] Tracker updated

---
name: job-application
description: Automates the full job application pipeline. Use when the user shares a job URL or pasted description and says "apply for", "create application for", "tailor CV for", or asks about portal skills/certifications. Produces tailored CV, cover letter, portal recommendations, and tracks applications. Also use when user says "set up job application" or "create my master resume".
---

# Job Application Skill

Automates the full job application workflow: master resume creation, CV tailoring, cover letter generation, portal skills recommendation, and application tracking.

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/generate_cover_letters.py` | Generates cover letter PDFs. Edit the LETTERS dict to add entries, then run it. |
| `scripts/merge_certificates.py` | Merges certificates into a single landscape PDF. Edit the CERTS list to add files. |
| `scripts/validate-output.sh` | Validates YAML, CV PDF, cover letter PDF, and checks for em dashes. |
| `scripts/setup.sh` | Installs Python dependencies and checks for LaTeX. |

## First-Time Setup

When invoked for the first time (no soul.md exists), run the setup flow:

### Step 1: Gather Information
Ask the user for (or offer to extract from):
- **Resume/CV** (PDF or text) — paste or upload
- **LinkedIn profile URL**
- **GitHub profile URL**
- **Portfolio website URL**

### Step 2: Create soul.md
Read `references/soul-template.md` for the structure. Fill in all sections using the gathered information.

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

### Step 2: Create Tailored CV YAML
Read `references/yaml-template.md` for structure and `references/bullet-formulas.md` for writing strong bullets.

Key rules:
- Only include relevant experiences, projects, certifications from soul.md
- ATS keywords in summary, skills, and experience bullets
- Use the technical bullet formula: Action + What + Scale/Impact + Tech
- Skills grouped by category
- No em dashes, no personal pronouns in bullets

### Step 3: Render CV PDF
Use rendercv to generate the CV from the YAML file.

### Step 4: Generate Cover Letter
Edit `scripts/generate_cover_letters.py` — add an entry to the LETTERS dict (see `references/cover-letter-template.md`), then run the script.

### Step 5: Portal Skills Table
Output table of skills/certifications to enter in the application portal.

### Step 6: Update Tracker
Add entry to your portfolio registry with status (Ready to apply / Applied / deadline).

### Step 7: Validate
Run `scripts/validate-output.sh` against the role slug and company name. Read `references/tailoring-checklist.md` before final submission.

## Source Files

| File | Purpose |
|------|---------|
| `soul.md` | Master resume (source of truth) |
| `references/` | Templates, bullet formulas, tailoring checklist |

## Output Checklist
- [ ] soul.md created and verified
- [ ] YAML file exists
- [ ] CV PDF is correct page count
- [ ] Cover letter is 1 page
- [ ] Zero em dashes
- [ ] Tracker updated

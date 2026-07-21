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

### Step 1.5: Check for Existing Files
Before creating anything, check if the user already has CV/cover letter files for this role:
- Look for `lawrence-njobo-<role-slug>.yaml` in the Resources directory
- Look for `Lawrence_Njobo_<Role>_CV.pdf` or similar
- Look for `Lawrence_Albert_Njobo_Cover_Letter_<Company>.pdf`
If files exist and the user doesn't ask for changes, skip regeneration and go straight to Step 5 (Portal Skills Table) or Step 6 (Update Tracker).

**Important:** When editing `generate_cover_letters.py` (fixing syntax, adding entries), do NOT run the full script to regenerate all cover letters. Only run it for the specific new entry. If the script must be run, confirm with the user first, as existing cover letters may have already been submitted.
Before creating anything, check if the user already has CV/cover letter files for this role:
- Look for `lawrence-njobo-<role-slug>.yaml` in the Resources directory
- Look for `Lawrence_Njobo_<Role>_CV.pdf` or similar
- Look for `Lawrence_Albert_Njobo_Cover_Letter_<Company>.pdf`
If files exist and the user doesn't ask for changes, skip regeneration and go straight to Step 5 (Portal Skills Table) or Step 6 (Update Tracker).

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
rendercv render applications/<role-slug>.yaml
```

### Step 4: Generate Cover Letter
Add entry to `generate_cover_letters.py` LETTERS dict (see `references/cover-letter-template.md`), then run:
```bash
python3 generate_cover_letters.py
```

### Step 5: Portal Skills Table
Output table of skills/certifications to enter in the application portal.

### Step 6: Update Tracker
Add entry to your portfolio registry with status (Ready to apply / Applied / deadline).

### Step 7: Validate
```bash
bash scripts/validate-output.sh <role-slug> <company>
```

Read `references/tailoring-checklist.md` before final submission.

## Source Files

| File | Purpose |
|------|---------|
| `soul.md` | Master resume (source of truth) |
| `agents.md` | Writing rules and constraints |
| `generate_cover_letters.py` | Cover letter PDF generator |
| `merge_certificates.py` | Certificate PDF merger |

## Quarterly Review

Every 3 months, review and update:

- **soul.md:** Add new projects, certifications, update metrics in experience bullets
- **Base YAMLs:** Refresh templates if skills or experience changed significantly
- **Portfolio:** Update lawrence-njobo.me with new achievements
- **Archive:** Move submitted applications older than 6 months to archive folder

## Output Checklist
- [ ] soul.md created and verified
- [ ] YAML file exists
- [ ] CV PDF is correct page count
- [ ] Cover letter is 1 page
- [ ] Zero em dashes
- [ ] Tracker updated

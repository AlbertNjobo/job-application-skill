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
| `generate_cover_letters.py` | Cover letter PDF generator (edit LETTERS dict) |
| `merge_certificates.py` | Certificate PDF merger (edit CERTS list) |

## Output Checklist
- [ ] soul.md created and verified
- [ ] YAML file exists
- [ ] CV PDF is correct page count
- [ ] Cover letter is 1 page
- [ ] Zero em dashes
- [ ] Tracker updated

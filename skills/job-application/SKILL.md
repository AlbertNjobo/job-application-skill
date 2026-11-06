---
name: job-application
description: Turns one master profile (soul.md) into a tailored CV, cover letter, portal skills table and tracked application for each job. Use when the user shares a job advert or URL and says "apply for", "tailor my CV", "write a cover letter", or asks about portal skills; when they say "set up job application", "help me apply for jobs", "create my master resume" or "start my job search"; or when they ask what the job application skill can do.
---

# Job Application Skill

Automates the full job application workflow: master resume creation, CV tailoring, cover letter generation, portal skills recommendation, and application tracking.

## First-Time Setup

Run this when there is no `soul.md` in the working directory, or when the user asks to set up.
Go one step at a time and wait for the user's answer before moving on. Never invent a fact to
fill a gap: leave it blank and say so.

### Step 0: Welcome
Start with a short welcome so the user knows what they are getting. Say it in your own words,
covering:

> I'll build your master profile, `soul.md`, once. After that, every time you paste a job advert I
> make a CV and a cover letter tailored to that job, a table of skills to paste into the
> application portal, and a row in your application tracker, then check the CV and letter for
> length and other house rules. Everything comes from `soul.md`: I reorder, cut and rephrase
> what's there, but I never add anything that isn't.
>
> I don't fill in application forms or submit anything for you.
>
> To start I need your current CV, or about ten minutes of questions if you don't have one.

### Step 1: Check the workspace
- Check that `rendercv` and the Python packages are available (`rendercv --version`,
  `python3 -c "import reportlab"`). If not, offer to run `scripts/setup.sh`, which installs them
  in a virtualenv.
- Create what the workflow needs, without overwriting anything that exists:
  `tracker.md` (a table with Date, Company, Role, Status and Deadline columns), a copy of
  `scripts/generate_cover_letters.py`, the `.gitignore` from Step 1.6, and an `applications/` folder.

### Step 2: Choose a starting point
Ask the user how they want to start, offering these options:

1. **Upload or paste your current CV** (recommended). PDF, Word (.docx) or plain text. Read a PDF
   with `pdftotext -layout`, a .docx with `pandoc` or `python-docx`. If the text comes out empty
   (a scanned PDF), ask for a text or Word version instead.
2. **Point me to your profiles.** LinkedIn, GitHub or a portfolio site. Fetch them with whatever
   web tool you have. LinkedIn usually blocks automated fetching; if a page cannot be read, ask the
   user to paste the relevant sections.
3. **No CV yet: answer a few questions.** Ask one topic at a time, in this order:
   - Name, city and country, email, phone, and any profile links
   - The roles and countries they are applying for
   - Education: institution, qualification, dates, result
   - Each job, newest first: employer, role, dates, what they did, and any result they can put
     a number on. Take numbers only from the user; never estimate one
   - Projects, with a link if there is one
   - Skills, split into **used in real work** and **only studied or tried**
   - Certifications, leadership, volunteering, awards

Several can be combined: a CV plus a GitHub link is a good start.

### Step 3: Ask about preferences
Ask these together, with the default in brackets, and record the answers in the Writing Rules
section of `soul.md`:
- CV length (2 pages; 1 page for graduate and admin roles)
- Spelling (British or American: follow their CV if unsure)
- Country conventions. For example, whether to include a photo or date of birth (leave both off
  in the US, UK, Canada and Australia) and whether school results are expected (see
  `references/cv-and-letter-craft.md`, "Regional conventions")
- CV theme. rendercv has nine: classic, ember, engineeringclassic, engineeringresumes (default),
  harvard, ink, moderncv, opal, sb2nov. Any of them can be switched later with one line in the CV's YAML

### Step 4: Build soul.md
Read `references/soul-template.md` for the structure and fill it from what the user gave you.
- Keep their own wording for experience bullets. Keep every number exactly as they gave it
- Mark anything you inferred rather than read (a date range, a skill level, a job title) with
  `(CONFIRM)` so the user can check it
- Put skills they have only studied or tried under "Familiar with", never under the main skills
- End with a short **Gaps** list: missing dates, results without numbers, projects without links

### Step 5: Confirm and hand over
Show the user `soul.md`, ask them to check every `(CONFIRM)` and fill any gaps they can, then
fill in `SENDER_NAME` and `SENDER_CONTACT` in their copy of `generate_cover_letters.py`. Finish by
telling them exactly what to do next:

> Paste a job advert (or its link) and say "apply for this job".

followed by the list in "What You Can Ask For" below.

## What You Can Ask For

Show this list when the user says "help", asks what you can do, or seems unsure what to ask.
Present it in plain language, not as file names.

| Ask | You get |
|---|---|
| "Apply for this job" + an advert or link | Tailored CV and cover letter (PDFs), portal skills table, tracker row, checks |
| "Just tailor my CV for this" | The CV only |
| "Write a cover letter for this" | The cover letter only |
| "What should I put in the portal's skills box?" | The portal skills table only |
| "Use the moderncv theme" (or any of the nine) | The same CV in a different look |
| "Add this to my profile: …" | `soul.md` updated with the new fact, marked `(CONFIRM)` if anything was inferred |
| "What's outstanding?" | Applications still marked "Ready to apply", and any deadlines that have passed |
| "Have I applied to [company] before?" | A check of `tracker.md` |
| "Check this application" | `scripts/validate-output.sh` run on it |
| "Quarterly review" | The review in "Quarterly Review" below |

## Ongoing Workflow (soul.md exists)

### Step 1: Parse Job Description
Extract: company, role, req ID, location, hard skills, soft skills, ATS keywords.

### Step 1.5: Check for Existing Work
Before creating anything:

**a. Same role already prepared?** Look for `<name-slug>-<role-slug>.yaml`, `<Name_Slug>_<Role_Slug>_CV.pdf`, and `<Name_Slug>_Cover_Letter_<Company>.pdf` in the working directory and in any dated subfolders. If they exist and the user hasn't asked for changes, skip regeneration and go to Step 5.

**b. Same company applied to before?** Grep `tracker.md` for the company name. If there is a prior application, tell the user before proceeding. Two applications to one company in quick succession may be deliberate, but it is their call to make, not an accident to discover later.

**c. Any deadlines already lapsed?** Compare every deadline in `tracker.md` against today's date. Report expired rows still marked "Ready to apply" so they can be closed out or chased.

### Step 1.6: Directory Layout
Keep the working directory to a handful of entries. Everything generated lives under
`applications/`:

```
working-dir/
├── soul.md                     # master resume, single source of truth
├── tracker.md                  # application log
├── generate_cover_letters.py   # live LETTERS dict
├── .gitignore                  # see below
├── applications/
│   ├── active/                 # prepared, not yet sent
│   ├── YYYY-MM-DD/             # a batch prepared on one day
│   └── archive/                # sent, closed out, or superseded
└── personal-docs/              # ID, transcripts, certificates. Never generated.
```

Put a single application in `applications/active/`, and several prepared together in
`applications/YYYY-MM-DD/`. Set `output_folder` in each YAML's `settings.render_command`,
and override `OUTPUT_DIR` when generating cover letters (Step 4). Pass the directory to
`validate-output.sh` as its third argument.

**`.gitignore` is mandatory.** `soul.md` holds a date of birth, phone number and email;
`generate_cover_letters.py` holds real letter text. None of it belongs in a repository:

```gitignore
soul.md
tracker.md
personal-docs/
generate_cover_letters.py
applications/
*.pdf
*_rendercv_output/
__pycache__/
```

### Step 1.7: Clean Up Build Output
`rendercv` leaves a `<slug>_rendercv_output/` folder holding Typst source, per-page PNGs,
Markdown and HTML. Only the PDF matters, and it is reproducible from the YAML in seconds.

**Copy the PDF out first, then delete the folder.** Never delete one without checking, because
a render whose PDF was never copied out leaves the build folder holding the only copy:

```bash
# every build-folder PDF must have a named copy outside it before deleting anything
find . -path "*_rendercv_output/*.pdf" | while read p; do
  sum=$(md5sum "$p" | cut -d' ' -f1)
  find . -name "*.pdf" -not -path "*_rendercv_output/*" -exec md5sum {} + \
    | grep -q "^$sum " || echo "ONLY COPY: $p"
done
```

Delete the folders only once that prints nothing.

### Step 2: Create Tailored CV YAML
Read `references/yaml-template.md` for structure and `references/bullet-formulas.md` for writing strong bullets.
Also read `references/cv-and-letter-craft.md` for entry layout, section order and naming,
an action verb bank, regional conventions, and the cover letter structure used in Step 4.

Key rules:
- Only include relevant experiences, projects, certifications from soul.md
- ATS keywords in summary, skills, and experience bullets
- Use the technical bullet formula: Action + What + Scale/Impact + Tech
- Skills grouped by category
- No em dashes, no personal pronouns in bullets
- Employer first: organisation bold on line 1, role italic on line 2 (set in the YAML template)
- Choose Education or Experience first from what the advert screens on (see the craft guide)
- One line per bullet, checked in the rendered PDF
- Before drafting, list what the advert screens for and make sure each item is answered

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

Fill in `SENDER_NAME` and `SENDER_CONTACT` at the top of the live file once, from soul.md.

Build only the new letter, by key:

```bash
python3 generate_cover_letters.py <NEW_KEY>
```

The script builds only the keys it is given and has no "build everything" mode. Never loop
over LETTERS to rebuild all entries: letters for applications already submitted would be
overwritten.

To write into a dated batch folder, override the output directory in-process:

```bash
python3 -c "
import generate_cover_letters as g
g.OUTPUT_DIR = '<absolute-path-to-output-dir>'
g.build_pdf('<NEW_KEY>')
"
```

Afterwards, confirm nothing else was touched:
```bash
find . -maxdepth 1 -name "*Cover_Letter*.pdf" -newermt "$(date +%Y-%m-%d)" | wc -l
```

**Always set a `"date"` key on each entry.** Without one the letter is dated the day it is
built, so a later rebuild would silently change the date on a letter already sent.
The script prints the page count and warns when a letter runs past one page.

### Step 5: Portal Skills Table
Output table of skills/certifications to enter in the application portal.

### Step 6: Update Tracker
Add a row to `tracker.md` with date, company, role, status (Ready to apply / Applied) and
deadline. Step 7 checks that the row exists.

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
- **Archive:** Move applications older than 6 months from `applications/active/` and dated
  batches into `applications/archive/`. Delete any `*_rendercv_output/` folders left behind,
  after running the only-copy check in Step 1.7.
- **Tracker audit:** If `tracker.md` links to generated files, every `file://` link should
  resolve. Report entries whose files were never generated rather than deleting them, since
  the entry may record a real application whose artefacts were lost:
  ```bash
  grep -o 'file://[^)]*' tracker.md | while read l; do
    p=$(python3 -c "import sys,urllib.parse;print(urllib.parse.unquote(sys.argv[1][7:]))" "$l")
    [ -e "$p" ] || echo "MISSING: $(basename "$p")"
  done
  ```

## Output Checklist
- [ ] soul.md created and verified
- [ ] YAML file exists
- [ ] CV PDF is correct page count
- [ ] Cover letter is 1 page
- [ ] Zero em dashes
- [ ] Tracker updated

# CV and Cover Letter Craft

Layout, sectioning and cover letter rules for the agent to apply when drafting. Most of it is
drawn from *Resumes and Cover Letters for PhD Students* (Harvard University Office of Career
Services, GSAS, 2016), a free guide with seven annotated resume samples and two cover letter
samples. The rules below are paraphrased; short quotations are marked as such.

The guide's samples are academic. Ignore their publications and abstracts sections: the
layout, sectioning and letter structure transfer to any field.

**Precedence.** Anything in the writing rules of `soul.md` overrides this file. So does an
employer's stated format: if the advert asks for one page, send one page.

---

## Entry layout: lead with the organisation

Every sample in the guide puts the organisation first and the role second. The employer's name
carries the recognition, so it takes the bold weight and the first line:

```
**Organisation Name**                                    Location
*Role Title*                                             Dates
• bullet
```

Organisation bold, role italic, on separate lines. Location right-aligned on line 1, dates
right-aligned on line 2.

In `rendercv` 2.x, override the theme template under `design.templates`:

```yaml
design:
  theme: engineeringresumes
  templates:
    experience_entry:
      main_column: "**COMPANY**\n*POSITION*\nSUMMARY\nHIGHLIGHTS"
      date_and_location_column: DATE
```

The `engineeringresumes` default bolds the job title and buries the employer. Empty
placeholders are dropped silently, so leaving out a location leaves no stray punctuation.

This costs one extra line per entry. Budget for it before adding content.

---

## Choose the order of Education and Experience from what the advert gates on

The guide's samples all lead with Education, including those whose authors have years of
professional work.

Education first matters most on **degree-gated roles**: graduate schemes, academic posts, and
adverts that set a degree classification, GPA floor or discipline list. Leading with Education
moves that credential into the top third of page 1, where the screen happens.

The trade is that a strong recent employer drops below the fold. For a role hiring on
experience rather than credentials, Experience first still wins. Decide per advert, not by
habit.

## One line per bullet

The guide's bullets are almost all a single line, for example "Pre-screened 400+ graduate
program applications." That is the whole bullet.

Bullets grow to two or three lines when they carry more than one fact. Three fixes, in order
of effect:

1. **Split compound bullets.** Anything joined by "and", or running to a second sentence, is
   usually two bullets. More bullets that each scan in one pass beat fewer that do not.
2. **Cut what another section already says.** A credential listed under Certifications does
   not need repeating at the end of an experience bullet.
3. **Trim connective words, keep every number.** "Analysed the manual invoicing process and
   then designed and built an automated replacement using Python, which reduced processing
   time by 40% for a team of 12" becomes "Automated manual invoicing in Python, cutting
   processing time 40% for a team of 12."

Allow two lines for the single strongest story on the CV, where the method is the point.

**Check the rendered PDF, not the YAML.** Line wrapping is what creates clutter, and it is
invisible in the source.

## State what was won, not what bar was cleared

"Recipient of the Dean's Award for Academic Excellence" beats "graduated above the minimum
required grade". A named distinction is evidence. A threshold comparison sounds defensive and
invites the reader to picture the bar.

When an advert sets a threshold, answer it in the **cover letter**, where it responds to the
stated criterion directly, and keep the CV positive.

## Regional conventions: include what local screeners ask for

Some markets screen on fields that other CV conventions leave out. Check the advert and the
application form, and include the field when it is asked for. Examples:

- **Secondary school results.** Employers in Zimbabwe and much of Southern Africa, and in
  India, Nigeria and elsewhere, often ask for O Level or A Level grades, or Class 10 and 12
  marks, even from graduates. Give results the way the form asks: A Levels in Zimbabwe are
  usually requested as **points** (A=5 down to E=1, so three A grades is 15), so state both
  grades and points.
- **Personal details.** Date of birth, nationality or a photo are expected in some countries
  and should be left off in others (the US, UK, Canada and Australia), where they invite bias
  and screeners may discard CVs that include them. Follow the advert and local norms, and
  never add them by default.

Where two school qualifications came from the same school, keep one entry and give the
earlier exam its own bullet with its year, rather than stretching the entry's date range to
cover a start year you would have to guess.

Shortlisted candidates are often asked for certified copies of certificates. If a
`personal-docs/` folder exists, check it holds what the application cites.

## Name the experience section after the target role

Two of the guide's samples retitle their experience sections to match what the employer is
hiring for: "Higher Education Experience" for a university administration post rather than a
generic "Experience", and separate "Non-Profit Experience" and "Consulting Experience"
sections. The annotations note that the same candidate would choose different headings for a
different target field.

**When to use:** the same history reads as a better fit under a heading that names the
employer's own category, typically when experience is mixed and one strand matters most to
this reader.

**Do not** invent a category the experience does not support. The heading reframes emphasis,
never the facts.

---

## "Proficient in X; familiar with Y"

The guide's skills lines grade the skills honestly within one sentence, in the form:

> **Computer:** Proficient in Microsoft Office; familiar with SPSS and R

**Use this whenever a skills group mixes tools used in real work with tools only tried or
studied.** A flat comma-separated list quietly upgrades everything in it to the strongest
level. If `soul.md` marks a skill as familiarity only, keep it on the "familiar with" side.

It also protects the strong claims. When everything is listed flat, a reader discounts the
whole line; when the familiar items are marked, the proficient ones are believed.

## Split experience into named sections when the strands differ

The samples often run several experience sections rather than one: management, teaching,
volunteer, non-profit, consulting, additional.

**When to use:** the history covers genuinely different kinds of work and the reader cares
about one strand. A named section lets them find it without reading the rest.

**When not to:** a handful of roles in one field. Two sections of two entries each looks
padded, not organised.

## Re-weight the same material per employer type

The guide works one candidate against several kinds of employer and changes the emphasis each
time:

| Target | Foreground | Cut back |
|---|---|---|
| Industry | Practical applications of the work | Theory and methodology detail |
| Quantitative or analytical roles | How the quantitative skill was built, step by step | Domain narrative |
| Consulting and generalist roles | Leadership, problem solving, student groups, volunteering, internships | Deep technical detail |

The facts do not change. Their order, their length, and which sections exist do.

**Leave out strong material that does not serve the target.** One sample drops publications
entirely for a venture capital role, and the annotation approves. A credential that impresses
the wrong reader takes space a relevant one needs.

## Derive the employer's screen list first

One sample is annotated with what the firm actually screens for: test scores and GPA,
prestigious awards, publications, evidence of teamwork, examples of leadership, and analytical
or quantitative ability.

**Write the advert's screen list out before drafting, then check every item is answered
somewhere on the page.** Teamwork and leadership are the two most often listed and most often
left unevidenced. Both are usually answered by extracurriculars, volunteering or projects
rather than employment, which is why every sample carries a leadership or activities section.

## Quantify the selectivity of an award

A named award means little to a reader outside the field. The ratio does the work:

> National Science Foundation Fellow, 900 recipients from 5,500 applicants

Give recipients against applicants, the cohort size, or a ranking ("top 5 of 300") wherever
`soul.md` records it. Never estimate one.

## An interests line, only when it maps to the role

One sample lists poker among its interests, and the annotation notes it is especially relevant
to venture capital. Interests earn their line when one connects to how the employer thinks or
works. Otherwise the space belongs to something else.

## Formatting thresholds

| Rule | Guide's recommendation |
|---|---|
| Font | A common, plain font such as Times New Roman or Arial |
| Font size | 10 to 12 point, consistent throughout |
| Margins | Equal on all sides, at least 0.75 inch |
| Length | 1 to 2 pages |
| Avoid | Text boxes, underlining, shading |

`yaml-template.md` uses tighter margins (0.5in top and bottom, 0.55in sides) because they are
what hold a full CV to two pages. Keep them, and any margins set in the writing rules of
`soul.md`. Do not silently widen margins to match this table; flag the trade only if a page
looks cramped.

**Follow the employer's stated limit exactly.** The guide also warns that a two-page resume
for a role below the candidate's level can read as overqualified and lose the application on
its own.

---

## Action verb bank

Verbs grouped by the kind of work they describe, based on the guide's list. Pick from the
category that matches the competency the advert names; it also raises literal keyword overlap
for applicant tracking systems.

| Category | Verbs |
|---|---|
| **Achievement** | accelerated, achieved, attained, earned, expanded, expedited, generated, improved, increased, produced, reduced, restructured, simplified, streamlined, upgraded |
| **Administrative** | arranged, collated, coordinated, distributed, established, implemented, installed, maintained, prepared, processed, provided, purchased, recorded, sourced, supported |
| **Communication** | addressed, briefed, communicated, conducted, corresponded, delivered, demonstrated, edited, interviewed, mediated, negotiated, persuaded, presented, proposed, reported, translated, wrote |
| **Creative** | authored, conceived, created, designed, developed, devised, drafted, founded, illustrated, introduced, invented, launched, originated, revamped, revised |
| **Financial** | allocated, analysed, appraised, audited, balanced, budgeted, calculated, forecast, projected, reconciled, tabulated |
| **Help and teach** | advised, clarified, coached, collaborated, consulted, educated, explained, guided, instructed, mentored, taught, trained, tutored |
| **Lead and manage** | administered, approved, assigned, chaired, delegated, directed, initiated, managed, motivated, recruited, reviewed, selected, supervised |
| **Plan and organise** | anticipated, catalogued, classified, consolidated, convened, gathered, monitored, organised, planned, prioritised, scheduled, structured, summarised |
| **Research and analysis** | assessed, compared, defined, detected, determined, discovered, evaluated, examined, investigated, measured, predicted, recommended, researched, surveyed, verified |
| **Technical** | adapted, automated, built, configured, debugged, deployed, diagnosed, engineered, integrated, migrated, modified, optimised, programmed, repaired, resolved, tested |

**Match the spelling to the target market** (analysed/analyzed, organised/organized). Use the
convention set in the writing rules of `soul.md`; if none is set, follow the advert's spelling.

---

## Cover letter: the three-paragraph structure

The guide's template, which both of its sample letters follow.

**Opening.** Why you are writing: the position title, where you saw it advertised, and any
referral. One sentence on why you fit.

**Middle, one or two paragraphs.** How you built the skills the job requires, with a concrete
example. Show interest in **both the job and the organisation**; the guide weights them
equally. Make hiring you a logical decision.

**Closing.** Ask for an interview, say when you will follow up, and thank the reader.

### What the sample letters do well

- Name the exact event where the candidate learnt about the role and who presented it. No
  template can fake that, and it proves genuine interest at once
- Lead with a countable claim, such as years of experience in the relevant field
- Back the middle paragraph with projects that each carry a hard number
- Close by naming the next step rather than trailing off

### Name the referral in the opening

If someone inside the organisation, or someone the reader knows, referred the candidate, say
so in the **first paragraph** alongside the position title. A referral is the strongest thing a
cover letter can carry, and saving it for later wastes it.

### Repeat contact details in the closing

End with a line such as "I can be reached at <phone> or <email>." Worth doing whenever the
letter may be read apart from the CV, which covers most portal uploads.

### The submission channel sets the format

| Channel | Format |
|---|---|
| Portal or website upload | Full business letter: your contact block, date, the employer's address block, salutation |
| Email body | Leave out both address blocks and the date. Start at the salutation |

In the guide's words: "in an email message, you would omit both your and the addressee's
contact information, as well as the date." Getting this backwards is an immediate tell: a
letterhead pasted into an email body, or an uploaded PDF with no heading at all.

When applying by email with an attached letter, keep the two distinct: the email body starts
at the salutation, and the attached PDF carries the full heading.

---

## Anti-patterns

| Avoid | Why |
|---|---|
| Text boxes, underlining, shading | Break applicant tracking system parsing and look dated |
| Mixed font sizes | Reads as careless before a word is read |
| Ignoring a stated page limit | The employer asked for something specific |
| Two pages for a role below the candidate's level | Can signal overqualified |
| A generic "Experience" heading when a named one fits | Wastes the line the reader scans hardest |
| Bolding the job title over the employer | Buries the name carrying the recognition |
| Skill bars, ratings, graphics | Absent from every sample; break parsing |

---

## Connects to

- `bullet-formulas.md`: the Action + What + Scale/Impact + Tech formula. The verb bank above
  supplies the Action slot; the guide's samples put a number in nearly every bullet, which is
  the Scale slot
- `tailoring-checklist.md`: pre-submission checks
- `soul.md` writing rules: page limits, margins and spelling convention, all of which
  override this file

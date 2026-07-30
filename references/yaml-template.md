# RenderCV YAML Template

Identity fields come from `soul.md`. Never hardcode them here, and never state a
value that does not appear in `soul.md`.

## File naming

One convention, derived from the name in `soul.md`:

| Artifact | Pattern | Example |
|---|---|---|
| CV source | `<name-slug>-<role-slug>.yaml` | `jane-doe-backend-engineer.yaml` |
| CV PDF | `<Name_Slug>_<Role_Slug>_CV.pdf` | `Jane_Doe_Backend_Engineer_CV.pdf` |
| Cover letter | `<Name_Slug>_Cover_Letter_<Company>.pdf` | `Jane_Doe_Cover_Letter_Acme.pdf` |

`<name-slug>` is the lowercase hyphenated name; `<Name_Slug>` is the Title_Case
underscored form. Stay consistent, because `validate-output.sh` locates files by
matching the role slug against these names.

## Structure

```yaml
cv:
  name: <Full Name from soul.md>
  headline: "<Tailored to role>"
  location: <City, Country>
  email: <email from soul.md>
  phone: '<E.164 phone from soul.md>'
  social_networks:
  - network: GitHub
    username: <github-username>
  - network: LinkedIn
    username: <linkedin-username>
  sections:
    summary:
    - "<1 paragraph targeting the specific role>"
    experience:
    - company: "<Only relevant experiences>"
      position: "<Clean title, no brackets>"
      start_date: YYYY-MM
      end_date: YYYY-MM        # or: present
      location: "<City, Country>"
      highlights:
      - "<STAR/XYZ bullet: Action + What + Scale/Impact + Tech>"
    education:
    - institution: <Institution from soul.md>
      area: <Field of study>
      degree: <e.g. BSc (Hons)>
      start_date: YYYY-MM
      end_date: YYYY-MM
      location: "<City, Country>"
      highlights:
      - "<Degree classification, if it meets or beats the job's stated bar>"
      - "<Only relevant coursework>"
    projects:
    - name: "<Only relevant projects, quote the value if the name contains a colon>"
      date: YYYY
      summary: "<One line>"
      highlights:
      - "<STAR/XYZ bullets>"
    certifications:
    - name: "<Only relevant certs>"
      date: YYYY-MM
      summary: "<Issuer (key topics)>"
    skills:
    - label: "<Category>"
      details: "<Skills matched to JD keywords>"
  website: <portfolio URL from soul.md>
design:
  theme: engineeringresumes
  page:
    top_margin: 0.5in
    bottom_margin: 0.5in
    left_margin: 0.55in
    right_margin: 0.55in
  typography:
    line_spacing: 0.55em
  sections:
    space_between_regular_entries: 0.22cm
    space_between_text_based_entries: 0.06cm
  entries:
    highlights:
      space_between_items: 0.02cm
settings:
  pdf_title: <Full Name> - <Role Title>
  render_command:
    output_folder: <role-slug>_rendercv_output
```

## Rules
- No em dashes (use commas, semicolons, colons)
- Project names containing a colon must be quoted
- No student preamble ("as a Computer Science student")
- No personal pronouns in experience bullets
- Selective tailoring: include only items relevant to this role
- Skills grouped by category (e.g. Languages & Libraries / Domain Skills / Cloud & Infrastructure / Delivery & Collaboration)
- ATS keywords from the JD placed in summary, skills, and experience bullets
- State a degree classification whenever the posting names a grade bar

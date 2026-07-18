# RenderCV YAML Template

## Structure

```yaml
cv:
  name: Lawrence Albert Njobo
  headline: "<Tailored to role>"
  location: Harare, Zimbabwe
  email: lawrencenjobo9@gmail.com
  phone: '+263715444928'
  social_networks:
  - network: GitHub
    username: AlbertNjobo
  - network: LinkedIn
    username: lawrence-njobo
  sections:
    summary:
    - "<1 paragraph targeting the specific role>"
    experience:
    - company: "<Only relevant experiences>"
      position: "<Clean title, no brackets>"
      start_date: YYYY-MM
      end_date: YYYY-MM
      location: "<City, Country>"
      highlights:
      - "<STAR/XYZ bullet: Action + What + Scale/Impact + Tech>"
    education:
    - institution: National University of Science and Technology (NUST)
      area: Computer Science
      degree: BSc (Hons) (Completed coursework, awaiting graduation)
      start_date: 2022-08
      end_date: 2026-09
      location: Bulawayo, Zimbabwe
      highlights:
      - "<Only relevant coursework>"
    projects:
    - name: "<Only relevant projects, use quotes if name contains colon>"
      date: YYYY
      summary: "<One line>"
      highlights:
      - "<STAR/XYZ bullets>"
    certifications:
    - name: "<Only relevant certs>"
      date: YYYY-MM
      summary: "<Platform: key topics>"
    skills:
    - label: "<Category>"
      details: "<Skills matched to JD keywords>"
  website: https://lawrence-njobo.me
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
  pdf_title: Lawrence Albert Njobo - <Role Title>
  render_command:
    output_folder: <role-slug>_rendercv_output
```

## Rules
- No em dashes (use commas, semicolons, colons)
- Project names with colons must be quoted
- No student preamble ("as a Computer Science student")
- No personal pronouns in experience bullets
- Selective tailoring: only relevant items
- Skills grouped by category (Languages & Libraries / Domain Skills / Cloud & Infrastructure / Delivery & Collaboration)
- ATS keywords from JD placed in summary, skills, and experience bullets

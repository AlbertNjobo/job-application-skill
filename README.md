# Job Application Skill

An AI agent skill that automates the full job application pipeline. First-time setup builds your master resume from your resume, LinkedIn, GitHub, and portfolio. Then every application is one command.

## What It Does

### First Time
1. Asks for your resume, LinkedIn, GitHub, portfolio
2. Creates `soul.md` (master resume) from that information
3. You verify and adjust

### Every Application
1. Parses the job description for keywords
2. Generates a tailored CV (RenderCV YAML → PDF)
3. Creates a cover letter (ReportLab → PDF)
4. Outputs portal skills/certifications table
5. Tracks applications with status
6. Validates all outputs

## Installation

### Prerequisites
```bash
pip install rendercv reportlab pdf2image pillow
```

### Claude Code
```bash
# Clone into your skills directory
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.claude/skills/job-application
```

### OpenCode / MiMo Code
```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.opencode/skills/job-application
```

### Codex
```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.codex/skills/job-application
```

### Cursor / Windsurf
```bash
git clone https://github.com/AlbertNjobo/job-application-skill.git ~/.cursor/skills/job-application
```

### Any Agent with Skills Support
```bash
# Clone anywhere your agent loads skills from
git clone https://github.com/AlbertNjobo/job-application-skill.git /path/to/your/skills/job-application
```

## Quick Start

**First time** — say:
> "Set up job application" or "Create my master resume"

The agent will ask for your resume, LinkedIn, GitHub, and portfolio links, then build your `soul.md` automatically.

**Every time after** — share a job description and say:
> "Apply for this job" or "Create application for this role"

## How It Works

### soul.md (Master Resume)

`soul.md` is your single source of truth. It contains:
- Contact information
- All work experience
- All certifications
- All projects
- All skills
- Writing rules

When you apply, the agent selects only what's relevant. Write once, apply everywhere.

### File Structure

```
job-application/
├── SKILL.md                    # Main skill definition
├── README.md                   # This file
├── references/
│   ├── soul-template.md        # Master resume template
│   ├── yaml-template.md        # RenderCV YAML structure
│   ├── cover-letter-template.md # Cover letter format
│   ├── bullet-formulas.md      # Technical bullet writing
│   └── tailoring-checklist.md  # Pre-submission checks
└── scripts/
    └── validate-output.sh      # Output validation
```

### Bullet Formula

Every experience bullet follows:

**Action Verb + Technical What + Scale/Impact + Technology Used**

Bad: "Worked on backend services"
Good: "Deployed 5 Node.js microservices handling 50K requests/minute, reducing coupling by 40%"

## Customization

Edit `soul.md` with your own information. The agent will use it as the source of truth for all applications.

Edit the writing rules in `soul.md` Section 8 to match your preferences:
- Page limits
- Em dash policy
- Cover letter format
- Any other constraints

## Built With

- [RenderCV](https://github.com/sinaatalay/rendercv) — CV generation from YAML
- [ReportLab](https://www.reportlab.com/) — PDF generation

## License

MIT — use it, fork it, make it yours.

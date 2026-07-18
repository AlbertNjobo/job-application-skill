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

## Quick Start

### Prerequisites
```bash
pip install rendercv reportlab pdf2image pillow
```

### Installation
```bash
# Claude Code
cp -r job-application ~/.claude/skills/

# OpenCode/MiMo
cp -r job-application ~/.opencode/skills/

# Codex
cp -r job-application ~/.codex/skills/
```

### Usage

**First time** — say "set up job application" or "create my master resume"

**Every time after** — share a job description and say "apply for this job"

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill definition with setup + workflow |
| `references/soul-template.md` | Master resume structure template |
| `references/yaml-template.md` | RenderCV YAML structure |
| `references/cover-letter-template.md` | Cover letter entry format |
| `references/bullet-formulas.md` | Technical bullet writing formulas |
| `references/tailoring-checklist.md` | Pre-submission quality checklist |
| `scripts/validate-output.sh` | Output validation script |

## How soul.md Works

`soul.md` is your master resume — one file with everything. When you apply, the agent selects only what's relevant. Write once, apply everywhere.

## Bullet Formula

Every experience bullet should follow:

**Action Verb + Technical What + Scale/Impact + Technology Used**

Bad: "Worked on backend services"
Good: "Deployed 5 Node.js microservices handling 50K requests/minute, reducing coupling by 40%"

## Built With

- [RenderCV](https://github.com/sinaatalay/rendercv) — CV generation from YAML
- [ReportLab](https://www.reportlab.com/) — PDF generation
- Designed for Claude Code, OpenCode, Codex, and other AI coding agents

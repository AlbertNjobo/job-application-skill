#!/usr/bin/env python3
"""Generate cover letter PDFs using ReportLab.

This file is a template. Copy it into your working directory, fill in the
SENDER block, and add one LETTERS entry per application.

Build one letter (or a few) by key:

    python3 generate_cover_letters.py ACME_SWE
    python3 generate_cover_letters.py ACME_SWE GLOBEX_DATA

Or from Python, with an output folder:

    import generate_cover_letters as g
    g.OUTPUT_DIR = "applications/2026-11-05"
    g.build_pdf("ACME_SWE")

Running the file with no keys builds nothing. There is deliberately no
"build everything" mode: rebuilding every entry would overwrite letters
you have already sent.
"""

import os
import sys
from datetime import date
from xml.sax.saxutils import escape

from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate

# ============================================================
# SENDER: your details, shared by every letter
# ============================================================
SENDER_NAME = "YOUR NAME"
SENDER_CONTACT = "City, Country | email@example.com | +1234567890 | yoursite.com"

# A4 for most of the world, letter for the US and Canada.
PAGE_SIZE = A4

# Where PDFs are written. Relative paths resolve from the current directory.
OUTPUT_DIR = "."

# ============================================================
# LETTERS: one entry per application
# ============================================================
# Optional keys per entry:
#   "date"        printed date, e.g. "5 November 2026". Defaults to today,
#                 so set it explicitly if you may rebuild the letter later.
#   "salutation"  defaults to "Dear Hiring Manager:"
#
# Text is plain: characters such as & and < are escaped for you.
LETTERS = {
    # "EXAMPLE_KEY": {
    #     "filename": "YourName_Cover_Letter_Example.pdf",
    #     "date": "5 November 2026",
    #     "recipient": [
    #         "The Hiring Manager",
    #         "Company Name",
    #         "City, Country",
    #     ],
    #     "re": "Re: Role Title (req12345)",
    #     "paragraphs": [
    #         "Hook paragraph: problem-solver or company-knowledge opening.",
    #         "Body 1: strongest qualification match with metrics.",
    #         "Body 2: additional qualifications, certs, culture fit.",
    #         "Closing: enthusiasm, specific contribution, call to action.",
    #     ],
    # },
}


def _today():
    d = date.today()
    return f"{d.day} {d.strftime('%B %Y')}"


def build_pdf(key):
    if key not in LETTERS:
        raise KeyError(f"No LETTERS entry named {key!r}. Known: {', '.join(LETTERS) or 'none'}")
    data = LETTERS[key]

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filepath = os.path.join(OUTPUT_DIR, data["filename"])

    doc = SimpleDocTemplate(
        filepath,
        pagesize=PAGE_SIZE,
        topMargin=0.7 * inch,
        bottomMargin=0.7 * inch,
        leftMargin=1 * inch,
        rightMargin=1 * inch,
    )

    base = getSampleStyleSheet()["Normal"]

    def style(name, font="Times-Roman", size=12, leading=14, align=TA_LEFT,
              before=0, after=0):
        return ParagraphStyle(name, parent=base, fontName=font, fontSize=size,
                              leading=leading, alignment=align,
                              spaceBefore=before, spaceAfter=after)

    name_style = style("Name", font="Times-Bold", size=16, leading=19,
                       align=TA_CENTER, after=4)
    contact_style = style("Contact", align=TA_CENTER)
    block_style = style("Block", before=14)  # date, closing
    line_style = style("Line")  # address lines after the first
    salutation_style = style("Salutation", before=14, after=8)
    re_style = style("ReLine", font="Times-Bold", before=14)
    body_style = style("Body", after=8)
    sig_style = style("Signature", before=30)

    def p(text, st):
        return Paragraph(escape(text), st)

    story = [
        p(SENDER_NAME, name_style),
        p(SENDER_CONTACT, contact_style),
        p(data.get("date") or _today(), block_style),
    ]
    story += [p(line, block_style if i == 0 else line_style)
              for i, line in enumerate(data["recipient"])]
    story.append(p(data["re"], re_style))
    story.append(p(data.get("salutation", "Dear Hiring Manager:"), salutation_style))
    story += [p(para, body_style) for para in data["paragraphs"]]
    story.append(p("Sincerely,", block_style))
    story.append(p(SENDER_NAME, sig_style))

    doc.build(story)
    pages = doc.page
    print(f"Generated: {filepath} ({pages} page{'s' if pages != 1 else ''})")
    if pages > 1:
        print(f"WARNING: {key} runs to {pages} pages. Cover letters should fit on one.")
    return filepath


if __name__ == "__main__":
    keys = sys.argv[1:]
    if not keys:
        print("Usage: python3 generate_cover_letters.py KEY [KEY ...]")
        print(f"Entries: {', '.join(LETTERS) or 'none yet, add one to LETTERS'}")
        sys.exit(1)
    for k in keys:
        build_pdf(k)

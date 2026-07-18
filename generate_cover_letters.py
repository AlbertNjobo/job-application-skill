#!/usr/bin/env python3
"""Generate cover letter PDFs using ReportLab.

Usage:
    1. Add entries to the LETTERS dict below
    2. Run: python3 generate_cover_letters.py
    3. Output PDFs are saved to the same directory
"""

import os
from reportlab.lib.pagesizes import letter
from reportlab.lib.units import inch
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer

# ============================================================
# COVER LETTER CONTENT — Add your entries here
# ============================================================
LETTERS = {
    # "EXAMPLE_KEY": {
    #     "filename": "YourName_Cover_Letter_Example.pdf",
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


def build_pdf(key):
    data = LETTERS[key]
    filepath = data["filename"]

    doc = SimpleDocTemplate(
        filepath,
        pagesize=letter,
        topMargin=0.7 * inch,
        bottomMargin=0.7 * inch,
        leftMargin=1 * inch,
        rightMargin=1 * inch,
    )

    styles = getSampleStyleSheet()

    name_style = ParagraphStyle("Name", parent=styles["Normal"],
        fontName="Times-Bold", fontSize=16, leading=19,
        alignment=TA_CENTER, spaceAfter=4)
    contact_style = ParagraphStyle("Contact", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_CENTER, spaceAfter=0)
    date_style = ParagraphStyle("Date", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=14, spaceAfter=0)
    recipient_style = ParagraphStyle("Recipient", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=14, spaceAfter=0)
    re_style = ParagraphStyle("ReLine", parent=styles["Normal"],
        fontName="Times-Bold", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=14, spaceAfter=0)
    salutation_style = ParagraphStyle("Salutation", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=14, spaceAfter=0)
    body_style = ParagraphStyle("Body", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=0, spaceAfter=8)
    closing_style = ParagraphStyle("Closing", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=14, spaceAfter=0)
    sig_style = ParagraphStyle("Signature", parent=styles["Normal"],
        fontName="Times-Roman", fontSize=12, leading=14,
        alignment=TA_LEFT, spaceBefore=30, spaceAfter=0)

    story = []
    story.append(Paragraph("YOUR NAME", name_style))
    story.append(Paragraph("City, Country | email@example.com | +1234567890 | yoursite.com", contact_style))
    story.append(Paragraph("July 19, 2026", date_style))
    for line in data["recipient"]:
        story.append(Paragraph(line, recipient_style))
    story.append(Paragraph(data["re"], re_style))
    story.append(Paragraph("Dear Hiring Manager:", salutation_style))
    for para in data["paragraphs"]:
        story.append(Paragraph(para, body_style))
    story.append(Paragraph("Sincerely,", closing_style))
    story.append(Paragraph("YOUR NAME", sig_style))

    doc.build(story)
    print(f"Generated: {filepath}")


if __name__ == "__main__":
    if not LETTERS:
        print("No entries in LETTERS dict. Add your cover letter content first.")
    for key in LETTERS:
        build_pdf(key)

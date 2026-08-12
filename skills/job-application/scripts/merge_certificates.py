#!/usr/bin/env python3
"""Merge certificates into a single landscape PDF with uniform layout.

Usage:
    1. Edit the CERTS list below with your certificate files
    2. Run: python3 merge_certificates.py
    3. Output: Merged_Certificates.pdf
"""

import os
import io
from reportlab.lib.pagesizes import landscape, letter
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
from PIL import Image
from pdf2image import convert_from_path

OUTPUT = "Merged_Certificates.pdf"
PAGE_W, PAGE_H = landscape(letter)
MARGIN = 0.5 * inch

# ============================================================
# YOUR CERTIFICATES — Edit this list
# ============================================================
CERTS = [
    # ("certificate-file.pdf", "Certificate Label"),
    # ("certificate-file.png", "Certificate Label"),
]


def pdf_to_pil(pdf_path):
    images = convert_from_path(pdf_path, first_page=1, last_page=1, dpi=200)
    return images[0]


def fit_to_page(img_w, img_h, page_w, page_h, margin):
    avail_w = page_w - 2 * margin
    avail_h = page_h - 2 * margin - 25
    scale = min(avail_w / img_w, avail_h / img_h)
    w = img_w * scale
    h = img_h * scale
    x = (page_w - w) / 2
    y = (page_h - h) / 2 + 8
    return x, y, w, h


def main():
    c = canvas.Canvas(OUTPUT, pagesize=landscape(letter))

    for filename, label in CERTS:
        if not os.path.exists(filename):
            print(f"SKIP: {filename}")
            continue

        ext = filename.lower().rsplit(".", 1)[-1]
        if ext in ("png", "jpg", "jpeg"):
            img = Image.open(filename).convert("RGB")
        elif ext == "pdf":
            img = pdf_to_pil(filename)
        else:
            continue

        iw, ih = img.size
        x, y, w, h = fit_to_page(iw, ih, PAGE_W, PAGE_H, MARGIN)
        buf = io.BytesIO()
        img.save(buf, format="PNG", quality=95)
        buf.seek(0)
        c.drawImage(ImageReader(buf), x, y, w, h, preserveAspectRatio=True)
        c.setFont("Times-Bold", 8)
        c.setFillColorRGB(0.35, 0.35, 0.35)
        c.drawCentredString(PAGE_W / 2, MARGIN - 8, label)
        c.showPage()
        print(f"Added: {label}")

    c.save()
    print(f"\nFinal: {OUTPUT} ({len(CERTS)} pages)")


if __name__ == "__main__":
    if not CERTS:
        print("No entries in CERTS list. Add your certificate files first.")
    else:
        main()

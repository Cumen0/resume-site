# Build the PDF CV from index.html (print styles). Run: python3 build-pdf.py
import pathlib, weasyprint
root = pathlib.Path(__file__).parent
html = (root / "index.html").read_text(encoding="utf-8").replace('src="/', 'src="')
doc = weasyprint.HTML(string=html, base_url=str(root) + "/").render()
print("pages:", len(doc.pages))
doc.write_pdf(root / "Volodymyr-Diadechko-CV.pdf")

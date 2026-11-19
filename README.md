# diadechko.com - resume site

Personal resume site of Volodymyr Diadechko (SEO Trainee): https://diadechko.com

A single static HTML page with a PDF version of the CV, hosted on AWS and set up with technical SEO best practices.

## Architecture

```
Browser ──HTTPS──▶ CloudFront (Free flat-rate plan, WAF, ACM certificate)
                        │  Origin Access Control
                        ▼
                  S3 bucket (private, versioned, SSE-S3)

DNS: Route 53 hosted zone (ALIAS A/AAAA -> CloudFront, CAA, SPF, DMARC)
```

- **S3** - private bucket, Block Public Access on, versioning + lifecycle rule for old versions
- **CloudFront** - HTTP -> HTTPS 301, HTTP/2 and HTTP/3, custom error response (S3 403 -> `/404.html` with status 404)
- **Route 53** - CAA (`amazon.com` only), SPF `-all` and DMARC `p=reject` because the domain sends no mail
- All resources tagged: `Project=resume-site`, `Environment=prod`, `Owner=vova`, `ManagedBy=console`

## SEO

- `<title>`, meta description, canonical, Open Graph, `lang`
- schema.org `Person` (JSON-LD)
- `robots.txt` with sitemap, `sitemap.xml`
- Proper 404 page with `noindex`
- Google Search Console: domain verified via DNS TXT, sitemap submitted
- PageSpeed Insights (Lighthouse): 100 / 100 / 100 / 100 on mobile and desktop
- No JavaScript, no external fonts, inline CSS, ~10 KB HTML

## Files

| File | Purpose |
| --- | --- |
| `index.html` | the resume page (screen + print styles) |
| `Volodymyr-Diadechko-CV.pdf` | PDF CV generated from `index.html` |
| `404.html` | not found page |
| `robots.txt`, `sitemap.xml` | crawler files |
| `build-pdf.py` | builds the PDF from `index.html` with WeasyPrint |
| `deploy.sh` | syncs files to S3 with cache headers and invalidates CloudFront |

## Usage

```bash
python3 build-pdf.py   # needs: brew install weasyprint (or pip install weasyprint)
./deploy.sh            # needs: AWS CLI with access to the bucket and distribution
```

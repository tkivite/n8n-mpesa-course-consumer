# n8n M-Pesa Mastery : Consumer Repo

> **Build Production-Ready STK Push Payment Workflows - No Backend code**

This repo is for **course students / consumers**.

It contains the practical assets you need to build, test, and deploy production-ready STK Push payment workflows without writing a custom backend service.

Inside this repo you will find the hands-on runtime assets for the course:

- local Docker setup
- n8n workflows
- Postman collection
- Postgres schema
- deployment starter files
- student onboarding docs
- PDFs
- troubleshooting guides

It does **not** include creator-only assets like sales automation, Gumroad workflows, voiceover source, or creator checklists.

---

## Start here

Open:

- `START-HERE.md`

Then choose your operating system guide:

- macOS → `docs/platform-setup-macos.md`
- Windows → `docs/platform-setup-windows.md`
- Linux → `docs/platform-setup-linux.md`

If something breaks, open:

- `docs/troubleshooting.md`

---

## What is inside

| Folder | Purpose |
|---|---|
| `docker/` | Local n8n + Postgres starter setup |
| `workflows/` | Core M-Pesa workflows |
| `workflows/use-cases/` | Real-world templates |
| `postman/` | Postman collection for local and sandbox testing |
| `db/` | SQL schemas |
| `deploy/` | VPS deployment starter files |
| `docs/` | Handbook, cheat sheet, OS guides, troubleshooting |
| `scripts/` | Student helper scripts |

---

## First-run checklist

- [ ] Git installed
- [ ] Docker installed
- [ ] Postman installed
- [ ] Repo cloned
- [ ] `docker/.env` created from `.env.example`
- [ ] n8n opens at `http://localhost:5678`
- [ ] Core workflows imported
- [ ] Postman collection imported

---

## Helpful docs

- Docs index : `docs/README.md`
- Student quickstart PDF : `docs/student-quickstart.pdf`
- Platform support matrix : `docs/platform-support.md`
- Troubleshooting : `docs/troubleshooting.md`
- Daraja cheat sheet : `docs/daraja-cheatsheet.pdf`
- Handbook : `docs/handbook.pdf`
- Refund policy : `docs/refund-policy.pdf`
- Support policy : `docs/support-policy.pdf`
- Privacy policy : `docs/privacy-policy.pdf`
- Terms of use : `docs/terms-of-use.pdf`

### Optional : rebuild the student quickstart PDF

```bash
npm install
npm run build:pdf
```

---

## Support scope

This course officially supports:

- **macOS**
- **Windows**
- **Linux**

See `docs/platform-support.md` for the details.



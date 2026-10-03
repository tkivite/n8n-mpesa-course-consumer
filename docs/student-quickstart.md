# Student Quickstart : First-Hour Setup

> This printable guide is for students who want the shortest path to a working local setup before going deeper into the course.

---

## 1. Goal for your first hour

By the end of your first hour, you should be able to:

- clone the repo
- create your `.env` file
- start Docker Compose
- open n8n at `http://localhost:5678`
- import the core workflows
- import the Postman collection

You do **not** need to complete the entire M-Pesa flow in the first hour.

---

## 2. Supported operating systems

This course officially supports:

- **macOS**
- **Windows**
- **Linux**

Use the matching guide in `docs/`:

- `platform-setup-macos.md`
- `platform-setup-windows.md`
- `platform-setup-linux.md`

---

## 3. Install these first

- Git
- Docker
- Postman
- A browser

---

## 4. Clone the repo

```bash
git clone https://github.com/<your-org-or-user>/<your-private-repo>.git
cd n8n-mpesa-course-consumer
```

---

## 5. Create your environment file

### macOS / Linux

```bash
cd docker
cp .env.example .env
```

### Windows PowerShell

```powershell
cd docker
Copy-Item .env.example .env
```

At minimum, fill in:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`
- `MPESA_CONSUMER_KEY`
- `MPESA_CONSUMER_SECRET`
- `MPESA_SHORTCODE`
- `MPESA_PASSKEY`

---

## 6. Start the stack

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

---

## 7. Open n8n

Open:

```text
http://localhost:5678
```

Then:

1. log in with the basic auth credentials from `.env`
2. create your n8n owner account
3. reach the editor

---

## 8. Import the four core workflows

Import in this order:

1. `workflows/01-mpesa-auth.json`
2. `workflows/02-stk-push.json`
3. `workflows/03-stk-callback.json`
4. `workflows/04-reconciliation.json`

---

## 9. Import the Postman collection

Use:

- `postman/mpesa-n8n.postman_collection.json`

Set:

```text
n8n_base_url = http://localhost:5678
```

Then fill in your Daraja sandbox variables.

---

## 10. If something breaks

Go here next:

- `../START-HERE.md`
- `troubleshooting.md`
- your OS-specific setup guide

---

## 11. First success milestone

You are in a good place if these are true:

- [ ] Docker works
- [ ] n8n opens locally
- [ ] Postman opens
- [ ] the core workflows import cleanly
- [ ] you know where the callback URL will come from later


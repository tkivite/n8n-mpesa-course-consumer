# Start Here : Student Setup Guide

If you just bought the course and want the fastest route to a working local setup, start here.

---

## 1. What you will do in the first hour

By the end of your first hour, you should be able to:

- clone the course repo
- create your local `.env` file
- start n8n with Docker
- open the n8n editor in your browser
- import the core workflows
- import the Postman collection
- understand where the callback URL will come from

You do **not** need to finish the full M-Pesa integration in the first hour.

---

## 2. Supported platforms

This course is written for:

- **macOS**
- **Windows**
- **Linux**

Before you continue, open the setup guide for your operating system:

- macOS → `docs/platform-setup-macos.md`
- Windows → `docs/platform-setup-windows.md`
- Linux → `docs/platform-setup-linux.md`

For the support policy and platform matrix, see `docs/platform-support.md`.

---

## 3. What you need before starting

### Required

- A computer running macOS, Windows, or Linux
- Internet access
- A browser
- A GitHub account (if your purchase includes private repo access)
- Docker Desktop or Docker Engine
- Git
- Postman desktop app
- A Safaricom Daraja sandbox account

### Strongly recommended

- A second browser tab open with the course videos
- A plain-text editor or IDE
- Google Chrome for the cleanest local testing experience
- ngrok account for callback testing during the callback lessons

---

## 4. Download / install checklist

Install these before touching the repo:

- [ ] Git
- [ ] Docker
- [ ] Postman
- [ ] Browser of your choice

Use your OS-specific guide for exact steps:

- `docs/platform-setup-macos.md`
- `docs/platform-setup-windows.md`
- `docs/platform-setup-linux.md`

---

## 5. Quick-start path

### Step 1 : Clone the repo

Replace the repo URL with the one you received after purchase.

```bash
git clone https://github.com/<your-org-or-user>/<your-private-repo>.git
cd n8n-mpesa-course
```

If you did not receive GitHub access yet, follow the repo-access email instructions first.

---

### Step 2 : Create your local environment file

```bash
cd docker
cp .env.example .env
```

Then open `.env` and fill in at least these values:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`
- `MPESA_CONSUMER_KEY`
- `MPESA_CONSUMER_SECRET`
- `MPESA_SHORTCODE`
- `MPESA_PASSKEY`
- `MPESA_CALLBACK_BASE_URL` (can be a placeholder on day one)

If you do not yet have Daraja credentials, that is okay — you can still start n8n and explore the workflows.

---

### Step 3 : Start the stack

```bash
docker compose up -d
```

This starts:

- Postgres
- n8n
- optional ngrok profile later when needed

---

### Step 4 : Open n8n

Open this URL in your browser:

```text
http://localhost:5678
```

Log in with the basic auth credentials from `.env`, then create your n8n owner account.

---

### Step 5 : Import the core workflows

Import these in order:

1. `workflows/01-mpesa-auth.json`
2. `workflows/02-stk-push.json`
3. `workflows/03-stk-callback.json`
4. `workflows/04-reconciliation.json`

In n8n:

- go to **Workflows**
- click **Import from File**
- choose each file one by one

---

### Step 6 : Import the Postman collection

Use:

- `postman/mpesa-n8n.postman_collection.json`

After import, set the collection variables:

- `mpesa_base_url`
- `consumer_key`
- `consumer_secret`
- `shortcode`
- `passkey`
- `callback_base_url`
- `n8n_base_url`

For local setup:

```text
n8n_base_url = http://localhost:5678
```

---

## 6. Recommended learning order

Do not jump around too much on your first pass.

### Best first-pass order

1. Module 0 : Welcome & Setup
2. Module 1 : Introduction to n8n
3. Module 2 : Understanding Daraja
4. Module 3 : OAuth in n8n
5. Module 4 : Building the STK Push workflow
6. Module 5 : Handling the callback
7. Module 6 : Reconciliation

Then come back later for:

- Module 7 : Production hardening
- Module 8 : Use cases
- Module 9 : Beyond STK Push
- Module 10 : Selling your skill

---

## 7. If something breaks

Start with:

- `docs/troubleshooting.md`

Most common issues are:

- Docker is not running
- port `5678` is already in use
- `.env` has missing or invalid M-Pesa credentials
- `ngrok` is not configured yet
- GitHub repo access was not accepted yet

---

## 8. First success milestone

You are “on track” if you can do these five things:

- [ ] open `http://localhost:5678`
- [ ] see Postgres and n8n containers running
- [ ] import `01-mpesa-auth.json`
- [ ] import the Postman collection
- [ ] identify where `MPESA_CALLBACK_BASE_URL` will be used later

If you can do that, you are in a good place.

---

## 9. Support docs to keep open

- Main repo guide → `README.md`
- macOS setup → `docs/platform-setup-macos.md`
- Windows setup → `docs/platform-setup-windows.md`
- Linux setup → `docs/platform-setup-linux.md`
- Platform support policy → `docs/platform-support.md`
- Troubleshooting → `docs/troubleshooting.md`
- Daraja cheat sheet → `docs/daraja-cheatsheet.pdf`

---

## 10. Before moving to Module 4

Make sure these are true:

- [ ] Docker works
- [ ] n8n opens locally
- [ ] you understand basic workflow import in n8n
- [ ] your Daraja sandbox credentials are available
- [ ] Postman is installed and opens correctly

If all five are done, continue with the build modules.


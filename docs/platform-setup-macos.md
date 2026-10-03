# Platform Setup : macOS

This guide is the recommended path for students using macOS.

---

## 1. Install the required tools

### Git

Check if Git is already installed:

```bash
git --version
```

If macOS prompts you to install Command Line Tools, accept it.

### Docker Desktop

Install Docker Desktop for Mac from Docker's official site.

After installation, open Docker Desktop and wait until it says Docker is running.

Verify:

```bash
docker --version
docker compose version
```

### Postman

Install the Postman desktop app.

Verify it opens normally.

---

## 2. Clone the course repo

Replace the repo URL with the one you received after purchase.

```bash
git clone https://github.com/<your-org-or-user>/<your-private-repo>.git
cd n8n-mpesa-course
```

If you see a GitHub access error, make sure you accepted the private repo invite first.

---

## 3. Create your local `.env`

```bash
cd docker
cp .env.example .env
```

Open `.env` in your editor and fill in the values you already have.

At minimum, set:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`
- `MPESA_CONSUMER_KEY`
- `MPESA_CONSUMER_SECRET`
- `MPESA_SHORTCODE`
- `MPESA_PASSKEY`

Generate an encryption key:

```bash
openssl rand -hex 16
```

Paste the output into `N8N_ENCRYPTION_KEY`.

---

## 4. Start the local stack

From the `docker/` folder:

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

You should see containers for:

- `postgres`
- `n8n`

---

## 5. Open n8n in your browser

```bash
open http://localhost:5678
```

Then:

1. enter the basic auth credentials from `.env`
2. create your n8n owner account
3. log in to the editor

---

## 6. Import the workflows

Import these first:

- `workflows/01-mpesa-auth.json`
- `workflows/02-stk-push.json`
- `workflows/03-stk-callback.json`
- `workflows/04-reconciliation.json`

Path in the UI:

- **Workflows**
- **Import from File**

---

## 7. Import the Postman collection

Use:

- `postman/mpesa-n8n.postman_collection.json`

Set these collection variables:

- `mpesa_base_url`
- `consumer_key`
- `consumer_secret`
- `shortcode`
- `passkey`
- `callback_base_url`
- `n8n_base_url`

For local work:

```text
n8n_base_url = http://localhost:5678
```

---

## 8. Optional : start ngrok later for callback testing

You only need this when you reach the callback lessons.

Add your ngrok token to `.env`, then run:

```bash
docker compose --profile tunnel up -d
```

Check the public URL:

```bash
docker compose logs ngrok | cat
```

Put the HTTPS URL into:

```text
MPESA_CALLBACK_BASE_URL=https://your-ngrok-subdomain.ngrok-free.app
```

Then restart:

```bash
docker compose up -d
```

---

## 9. Useful commands on macOS

### Stop the stack

```bash
docker compose down
```

### Restart the stack

```bash
docker compose up -d
```

### Watch n8n logs

```bash
docker compose logs n8n | cat
```

### Watch Postgres logs

```bash
docker compose logs postgres | cat
```

---

## 10. Common macOS-specific issues

### Docker Desktop is installed but commands fail

Make sure Docker Desktop is fully started before running commands.

### Port `5678` is already in use

Find what is using it:

```bash
lsof -i :5678
```

Then stop that process or change the port mapping in `docker/docker-compose.yml`.

### `git` command not found

Install Apple's Command Line Tools when prompted, then reopen Terminal.

### Browser says site cannot be reached

Check containers:

```bash
docker compose ps
```

If `n8n` is not running, inspect logs:

```bash
docker compose logs n8n | cat
```

---

## 11. Success checklist

You are ready to continue if all of these are true:

- [ ] Git works
- [ ] Docker works
- [ ] Postman opens
- [ ] n8n opens at `http://localhost:5678`
- [ ] you can import the core workflows

Next:

- `START-HERE.md`
- `docs/troubleshooting.md`


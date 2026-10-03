# Platform Setup : Linux

This guide is the recommended path for students using Linux.

---

## 1. Recommended Linux setup

The course is easiest to follow on:

- Ubuntu
- Debian
- Linux Mint
- another Debian-based distro with standard Docker packaging

Other Linux distros may still work, but commands and package names may differ.

---

## 2. Install the required tools

### Git

Check whether Git is already installed:

```bash
git --version
```

### Docker Engine and Docker Compose plugin

Check whether Docker is installed:

```bash
docker --version
docker compose version
```

If you need to install Docker on Ubuntu or Debian, use Docker's official installation instructions for your distro.

### Postman

Install the Postman desktop app if available for your distro. If you prefer another compatible API client, you can use it, but the course materials reference Postman directly.

---

## 3. Clone the course repo

Replace the repo URL with the one you received after purchase.

```bash
git clone https://github.com/<your-org-or-user>/<your-private-repo>.git
cd n8n-mpesa-course
```

If you get a GitHub permission error, verify that you accepted the private repo invite first.

---

## 4. Create your local `.env`

```bash
cd docker
cp .env.example .env
```

Open `.env` in your editor and fill in the required values.

At minimum, set:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`
- `MPESA_CONSUMER_KEY`
- `MPESA_CONSUMER_SECRET`
- `MPESA_SHORTCODE`
- `MPESA_PASSKEY`

Generate an encryption key if `openssl` is available:

```bash
openssl rand -hex 16
```

---

## 5. Start the local stack

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

You should see the `postgres` and `n8n` containers running.

If your machine requires `sudo` for Docker, run the same commands with `sudo`.

---

## 6. Open n8n

```bash
xdg-open http://localhost:5678
```

If `xdg-open` is unavailable, just paste the URL into your browser manually.

Then:

1. enter the basic auth credentials from `.env`
2. create your n8n owner account
3. open the editor

---

## 7. Import the workflows

Import the core workflows first:

- `workflows/01-mpesa-auth.json`
- `workflows/02-stk-push.json`
- `workflows/03-stk-callback.json`
- `workflows/04-reconciliation.json`

Use:

- **Workflows**
- **Import from File**

---

## 8. Import the Postman collection

Use:

- `postman/mpesa-n8n.postman_collection.json`

Set collection variables including:

```text
n8n_base_url = http://localhost:5678
```

And your Daraja sandbox credentials.

---

## 9. Optional : start ngrok later for callback testing

Only needed for callback lessons.

Add `NGROK_AUTHTOKEN` to `.env`, then run:

```bash
docker compose --profile tunnel up -d
```

Read the tunnel logs:

```bash
docker compose logs ngrok | cat
```

Copy the HTTPS URL into `MPESA_CALLBACK_BASE_URL`, then restart:

```bash
docker compose up -d
```

---

## 10. Useful Linux commands

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

## 11. Common Linux-specific issues

### `docker compose` is not available

Some systems still have the older `docker-compose` command instead of the newer Docker Compose plugin.

Check:

```bash
docker-compose --version
```

If your system only has `docker-compose`, use that variant consistently.

### Docker permission denied

If you see permission errors, try:

```bash
sudo docker compose ps
```

For a long-term fix, add your user to the Docker group according to Docker's official Linux post-install instructions.

### Port `5678` already in use

Find the conflicting process:

```bash
ss -ltnp | grep 5678
```

Or:

```bash
lsof -i :5678
```

Stop the conflicting process or change the port mapping in `docker/docker-compose.yml`.

### Browser does not open automatically

Use the URL manually:

```text
http://localhost:5678
```

### Corporate security tools block Docker networking

This can happen on managed laptops. If so, try a personal machine or a disposable cloud VM for the course.

---

## 12. Success checklist

You are ready to continue if all of these are true:

- [ ] Git works
- [ ] Docker works
- [ ] Postman opens
- [ ] n8n opens at `http://localhost:5678`
- [ ] you can import the core workflows

Next:

- `START-HERE.md`
- `docs/troubleshooting.md`


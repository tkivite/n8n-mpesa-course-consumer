# Troubleshooting : Common Student Issues

Use this guide when something breaks during setup or while testing the workflows locally.

---

## 1. Quick triage order

Before trying anything complicated, check these in order:

- [ ] Is Git installed?
- [ ] Is Docker installed?
- [ ] Is Docker running?
- [ ] Did you create `docker/.env` from `.env.example`?
- [ ] Did you fill in the required M-Pesa variables?
- [ ] Does `docker compose ps` show `n8n` and `postgres` running?
- [ ] Can you open `http://localhost:5678`?

If any answer is “no”, fix that first.

---

## 2. I cannot clone the repo

### Symptom

GitHub says access denied or repository not found.

### What to check

- [ ] Did you accept the GitHub invite to the private repo?
- [ ] Are you signed into the correct GitHub account?
- [ ] Are you using the correct repo URL from the welcome email?

### Fix

If access is supposed to be private, return to the repo-claim flow and make sure your GitHub username was granted access.

---

## 3. `docker` command not found

### Symptom

Terminal says:

```text
docker: command not found
```

### Fix

Install Docker first.

- macOS → `docs/platform-setup-macos.md`
- Windows → `docs/platform-setup-windows.md`
- Linux → `docs/platform-setup-linux.md`

Then reopen your terminal and verify:

```bash
docker --version
docker compose version
```

---

## 4. Docker is installed but containers will not start

### Symptom

`docker compose up -d` fails, or `docker compose ps` shows nothing running.

### What to check

- [ ] Is Docker Desktop open? (macOS / Windows)
- [ ] Is the Docker daemon running? (Linux)
- [ ] Is there another app using required ports?
- [ ] Did you edit `docker/.env` correctly?

### Fix

Run:

```bash
docker compose ps
docker compose logs n8n | cat
docker compose logs postgres | cat
```

Read the first obvious error message before changing anything else.

---

## 5. n8n does not open at `http://localhost:5678`

### Symptom

Browser says site cannot be reached.

### What to check

Run:

```bash
docker compose ps
```

You should see `n8n` running.

### Fix

If `n8n` is not running:

```bash
docker compose logs n8n | cat
```

If `n8n` is running, check whether something else is using the port.

#### macOS / Linux

```bash
lsof -i :5678
```

#### Windows PowerShell

```powershell
netstat -ano | findstr :5678
```

---

## 6. Port `5678` is already in use

### Symptom

Docker fails to bind the port.

### Fix option A : stop the conflicting app

Identify and stop the process using the port.

### Fix option B : change the mapped port

Edit `docker/docker-compose.yml` and change:

```yaml
ports:
  - "5678:5678"
```

To something like:

```yaml
ports:
  - "5680:5678"
```

Then restart:

```bash
docker compose up -d
```

Open:

```text
http://localhost:5680
```

---

## 7. I forgot to create `.env`

### Symptom

Containers start with missing values, or workflows fail later with empty environment variables.

### Fix

From the `docker/` folder:

#### macOS / Linux

```bash
cp .env.example .env
```

#### Windows PowerShell

```powershell
Copy-Item .env.example .env
```

Then fill in the required values and restart:

```bash
docker compose up -d
```

---

## 8. Invalid M-Pesa credentials

### Symptom

The auth workflow fails, or Daraja returns invalid credentials.

### What to check

- [ ] `MPESA_CONSUMER_KEY`
- [ ] `MPESA_CONSUMER_SECRET`
- [ ] `MPESA_BASE_URL`
- [ ] Are you mixing sandbox creds with production URL?

### Fix

For sandbox, make sure:

```text
MPESA_BASE_URL=https://sandbox.safaricom.co.ke
```

Then verify your credentials with the helper script:

```bash
./scripts/test-token.sh
```

If the response does not contain `access_token`, re-check the values from the Daraja portal.

---

## 9. `MPESA_PASSKEY` or callback URL missing

### Symptom

The STK Push workflow fails before or during payload generation.

### Fix

Open `docker/.env` and make sure these are present:

```text
MPESA_PASSKEY=...
MPESA_CALLBACK_BASE_URL=https://...
```

If you are not testing callbacks yet, you still need a valid-looking callback base URL for the payload to build cleanly.

---

## 10. ngrok does not work

### Symptom

No public callback URL appears, or ngrok fails to start.

### What to check

- [ ] `NGROK_AUTHTOKEN` exists in `.env`
- [ ] You started the tunnel profile explicitly
- [ ] Docker is running normally

### Start the tunnel

```bash
docker compose --profile tunnel up -d
```

### Read the logs

```bash
docker compose logs ngrok | cat
```

Then copy the HTTPS URL into:

```text
MPESA_CALLBACK_BASE_URL=https://your-ngrok-subdomain.ngrok-free.app
```

Restart the stack:

```bash
docker compose up -d
```

---

## 11. I imported the workflows, but one of them looks broken

### Symptom

A node is red, missing config, or fails immediately.

### What to check

- [ ] Did you import the workflows in the recommended order?
- [ ] Did you create the Postgres credential inside n8n?
- [ ] Did you point `Execute Workflow` nodes to the correct imported workflows?
- [ ] Are environment variables present in `.env`?

### Fix

Re-import in this order:

1. `workflows/01-mpesa-auth.json`
2. `workflows/02-stk-push.json`
3. `workflows/03-stk-callback.json`
4. `workflows/04-reconciliation.json`

Then re-open the node settings and select the intended workflow or credential again.

---

## 12. Postman collection imports, but requests fail

### Symptom

Postman requests return errors immediately.

### What to check

- [ ] Are the collection variables filled in?
- [ ] Is `n8n_base_url` correct?
- [ ] Are `consumer_key` and `consumer_secret` correct?
- [ ] Are you hitting sandbox, not production?

### Fix

For local development, use:

```text
n8n_base_url = http://localhost:5678
mpesa_base_url = https://sandbox.safaricom.co.ke
```

Then refresh the token request first before trying STK Push.

---

## 13. Callback never arrives

### Symptom

STK Push request succeeds, but nothing hits the callback workflow.

### What to check

- [ ] Did you expose a public callback URL with ngrok or a VPS?
- [ ] Is `MPESA_CALLBACK_BASE_URL` correct?
- [ ] Did you restart the stack after changing `.env`?
- [ ] Is the callback workflow active?

### Fix

1. Start the tunnel profile if local:

```bash
docker compose --profile tunnel up -d
```

2. Put the HTTPS URL into `MPESA_CALLBACK_BASE_URL`
3. Restart:

```bash
docker compose up -d
```

4. Activate `03-stk-callback.json`

---

## 14. Repo-access form says invalid receipt

### Symptom

The claim form rejects your purchase receipt.

### What to check

- [ ] Did you paste the Gumroad sale / receipt ID exactly?
- [ ] Did you complete payment successfully?
- [ ] Did the sale webhook run and insert the purchase?

### Fix

Try copying the receipt directly from the purchase email. Avoid leading/trailing spaces.

If it still fails, support needs to verify whether the purchase exists in the `purchases` table.

---

## 15. GitHub invite never arrived

### Symptom

The claim flow said success, but no invite is visible.

### What to check

- [ ] Look in GitHub notifications
- [ ] Check the email on your GitHub account
- [ ] Make sure you entered the correct GitHub username
- [ ] Check the repo’s collaborators page if you own the course

### Fix

If you entered the wrong GitHub username, ask support to revoke and re-grant access.

---

## 16. Windows-specific note

If you are on Windows and Docker behaves strangely:

- reboot after installing Docker Desktop
- verify WSL2 is enabled
- reopen PowerShell after installation
- re-run:

```powershell
docker --version
docker compose version
```

---

## 17. Linux-specific note

If you are on Linux and Docker requires sudo:

```bash
sudo docker compose ps
```

For a permanent fix, configure Docker group access according to Docker’s official Linux post-install docs.

---

## 18. When to ask for help

Ask for help when:

- Docker is installed but refuses to run
- the auth workflow still fails after double-checking credentials
- callbacks still do not arrive after ngrok is configured correctly
- your receipt exists but the claim flow still fails
- the repo invite was supposedly sent but access still does not work

When asking for help, include:

- your OS
- the exact step you are on
- the exact error text
- whether Docker containers are running
- whether this is setup, STK Push, callback, or repo-access issue


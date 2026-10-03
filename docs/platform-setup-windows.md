# Platform Setup : Windows

This guide is the recommended path for students using Windows.

---

## 1. Recommended Windows setup

The smoothest setup for this course is:

- Windows 11 preferred
- Docker Desktop installed
- WSL2 backend enabled in Docker Desktop
- Git for Windows installed
- PowerShell or Windows Terminal
- Postman desktop app installed

If you are on Windows 10, the course may still work, but Docker Desktop + WSL2 support should be confirmed first.

---

## 2. Install the required tools

### Git for Windows

After installation, open PowerShell and verify:

```powershell
git --version
```

### Docker Desktop

Install Docker Desktop, then confirm:

```powershell
docker --version
docker compose version
```

If Docker asks to enable WSL2 or reboot the system, do that before continuing.

### Postman

Install the Postman desktop app and make sure it launches correctly.

---

## 3. Clone the course repo

Replace the repo URL with the one you received after purchase.

```powershell
git clone https://github.com/<your-org-or-user>/<your-private-repo>.git
cd n8n-mpesa-course
```

If GitHub says access denied, make sure you accepted the repo invite first.

---

## 4. Create your local `.env`

```powershell
cd docker
Copy-Item .env.example .env
```

Open `.env` in your editor and set the required values.

At minimum, fill in:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_ENCRYPTION_KEY`
- `MPESA_CONSUMER_KEY`
- `MPESA_CONSUMER_SECRET`
- `MPESA_SHORTCODE`
- `MPESA_PASSKEY`

For a quick encryption key, you can use any strong random 32-character string if you do not have `openssl` available on Windows.

---

## 5. Start the local stack

From the `docker\` folder:

```powershell
docker compose up -d
```

Check status:

```powershell
docker compose ps
```

You should see at least:

- `postgres`
- `n8n`

---

## 6. Open n8n

```powershell
start http://localhost:5678
```

Then:

1. log in with the basic auth credentials from `.env`
2. create your n8n owner account
3. open the workflow editor

---

## 7. Import the workflows

Import these first:

- `workflows/01-mpesa-auth.json`
- `workflows/02-stk-push.json`
- `workflows/03-stk-callback.json`
- `workflows/04-reconciliation.json`

Use the n8n UI:

- **Workflows**
- **Import from File**

---

## 8. Import the Postman collection

Import:

- `postman/mpesa-n8n.postman_collection.json`

Set variables like:

```text
n8n_base_url = http://localhost:5678
```

Plus your Daraja sandbox credentials.

---

## 9. Optional : start ngrok later for callback testing

Only needed during callback lessons.

Add `NGROK_AUTHTOKEN` to `.env`, then start the tunnel profile:

```powershell
docker compose --profile tunnel up -d
```

Read the logs:

```powershell
docker compose logs ngrok | Out-String
```

Copy the HTTPS URL into `MPESA_CALLBACK_BASE_URL`, then restart:

```powershell
docker compose up -d
```

---

## 10. Useful Windows commands

### Stop the stack

```powershell
docker compose down
```

### Restart the stack

```powershell
docker compose up -d
```

### Watch n8n logs

```powershell
docker compose logs n8n | Out-String
```

### Watch Postgres logs

```powershell
docker compose logs postgres | Out-String
```

---

## 11. Common Windows-specific issues

### Docker commands fail after install

Reboot if Docker Desktop requested it. Also verify WSL2 is enabled.

### `docker compose` is not recognized

Docker Desktop may not be fully installed, or PowerShell may need to be reopened.

### Port `5678` is already in use

Check:

```powershell
netstat -ano | findstr :5678
```

Then stop the conflicting app or change the port mapping in `docker/docker-compose.yml`.

### Git line-ending issues

Avoid editing JSON files with apps that silently rewrite line endings or file encoding. Use VS Code, Cursor, JetBrains, Notepad++, or another developer editor.

### Browser does not open n8n

Check container status:

```powershell
docker compose ps
```

Then inspect logs:

```powershell
docker compose logs n8n | Out-String
```

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


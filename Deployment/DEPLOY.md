# Deploy Guide — GitHub Actions + Vultr

When you **push to the `production` branch**, GitHub Actions SSHs into your Vultr server and runs the deploy script.

---

## What happens on push

```
You push to production
        ↓
GitHub Actions starts (.github/workflows/deploy.yaml)
        ↓
SSH into Vultr server
        ↓
cd ~/ashgard_todo
git pull origin production
pip install -r requirements.txt
sudo systemctl restart ashgard_todo
        ↓
Live app is updated
```

---

## Two connections you need

The server and GitHub talk to each other in **two directions**. Set up both once.

| # | Direction | Why | How |
|---|-----------|-----|-----|
| 1 | **GitHub → Server** | Actions needs to SSH in and run commands | SSH key in GitHub Secrets + public key on server |
| 2 | **Server → GitHub** | Server needs to `git pull` latest code | Deploy key on server + add public key in GitHub |

---

## Step 1 — Server setup (one time)

On your Vultr server:

```bash
# Clone the repo
cd ~
git clone git@github.com:YOUR_ORG/YOUR_REPO.git ashgard_todo
cd ashgard_todo
git checkout production

# Python environment
python3 -m venv venv
source venv/bin/activate
pip install -r server/requirements.txt

# Add your .env file (never commit this)
nano server/.env
```

Make sure the app runs with systemd as `ashgard_todo` (see your server admin for the service file).

---

## Step 2 — Connect server to GitHub (for `git pull`)

**On the server**, create a deploy key:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/github_deploy -N ""
cat ~/.ssh/github_deploy.pub
```

**On GitHub** → Repo → **Settings** → **Deploy keys** → **Add deploy key**

- Paste the public key
- Save (read-only is fine)

**Back on the server**, use that key for GitHub:

```bash
nano ~/.ssh/config
```

```
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_deploy
  IdentitiesOnly yes
```

Test it:

```bash
chmod 600 ~/.ssh/config ~/.ssh/github_deploy
ssh -T git@github.com
cd ~/ashgard_todo && git pull origin production
```

---

## Step 3 — Connect GitHub to server (for Actions SSH)

**On your PC**, create a key for GitHub Actions:

```bash
ssh-keygen -t ed25519 -f github_actions_key -N ""
```

- `github_actions_key` → private key (goes to GitHub)
- `github_actions_key.pub` → public key (goes to server)

**On the server**, add the public key:

```bash
nano ~/.ssh/authorized_keys
# paste github_actions_key.pub on a new line
chmod 600 ~/.ssh/authorized_keys
```

**On GitHub** → Repo → **Settings** → **Secrets and variables** → **Actions**

Add these 3 secrets:

| Secret | Value |
|--------|-------|
| `SERVER_HOST` | Your Vultr IP, e.g. `123.45.67.89` |
| `SERVER_USER` | Your SSH user, e.g. `deploy` |
| `SSH_PRIVATE_KEY` | Full contents of `github_actions_key` |

Test from your PC:

```bash
ssh -i github_actions_key YOUR_USER@YOUR_SERVER_IP
```

---

## Step 4 — Allow restart without password

GitHub Actions runs `sudo systemctl restart ashgard_todo`. On the server:

```bash
sudo visudo -f /etc/sudoers.d/ashgard-deploy
```

Add:

```
YOUR_USER ALL=(ALL) NOPASSWD: /bin/systemctl restart ashgard_todo
```

---

## Step 5 — Push to production

1. Make sure `.github/workflows/deploy.yaml` is on the `production` branch
2. Push or merge your code to `production`
3. Go to GitHub → **Actions** tab → check the deploy run

---

## Checklist

- [ ] Repo cloned at `~/ashgard_todo` on server
- [ ] `production` branch checked out on server
- [ ] `server/.env` exists on server
- [ ] `ashgard_todo` systemd service is running
- [ ] Server can `git pull origin production` (deploy key)
- [ ] GitHub secrets set: `SERVER_HOST`, `SERVER_USER`, `SSH_PRIVATE_KEY`
- [ ] SSH from Actions works (public key in `authorized_keys`)
- [ ] Sudo restart works without password

---

## If something fails

| Error | Fix |
|-------|-----|
| `Permission denied (publickey)` in Actions | Check `SSH_PRIVATE_KEY` secret and `authorized_keys` on server |
| `git pull` fails on server | Check deploy key in GitHub → Deploy keys |
| `pip install` fails | Use `server/requirements.txt` — update deploy.yaml if needed |
| `sudo: password required` | Add NOPASSWD rule (Step 4) |

**Check logs on server:**

```bash
sudo journalctl -u ashgard_todo -n 50
```

---

## Notes

- Use **two different SSH keys** — one for server→GitHub (deploy key), one for GitHub→server (Actions key).
- React UI is **not built** by the current workflow. Add `npm run build` in `client/` if you need frontend deploys.
- DB migrations are **not run** automatically. Run `flask db upgrade` manually when models change.

# repo-depot

Coleman Parks — client website builds and brand playbook.

## Live URLs

| Page | URL |
|------|-----|
| **Hub** (all builds) | https://cp030.github.io/repo-depot |
| **Playbook** | https://cp030.github.io/repo-depot/playbook |
| **Each client build** | https://cp030.github.io/repo-depot/client-slug |

## Adding a New Build

### One command (Mac terminal)
```bash
./new-client.sh "Client Name" "slug" "Short description"
```
- Creates `slug/index.html` from the template
- Adds a card to the hub page automatically
- Makes a git commit

Then paste your HTML, check it, and push:
```bash
# 1. Paste generated HTML into slug/index.html
# 2. Run design quality check
./check.sh slug/index.html
# 3. Push
git add slug/index.html index.html && git commit -m "build: slug" && git push
```

### Via GitHub (phone or browser)
1. Go to github.com/cp030/repo-depot
2. Click **Add file → Create new file**
3. Type filename: `client-slug/index.html`
4. Paste HTML → **Commit changes**
5. Add a card to `index.html` manually

## Folder Structure

```
repo-depot/
├── index.html          ← Hub page (lists all builds)
├── CLAUDE.md           ← Design laws for every Claude Code session
├── PRODUCT.md          ← Brand context
├── check.sh            ← Design quality gate — run before every push
├── new-client.sh       ← Scaffold + auto-add hub card
├── setup-mac.sh        ← One-time Mac: installs all Claude Code skills
├── _template/
│   └── index.html      ← Starter HTML for new builds
├── playbook/
│   └── index.html      ← Full Dev + Brand Playbook
└── client-slug/        ← One folder per client
    └── index.html
```

## One-Time Mac Setup

Run once to install all Claude Code design skills and the Impeccable CLI:
```bash
./setup-mac.sh
```

## Design Quality Check

Run before every push:
```bash
./check.sh slug/index.html
```
Catches: AI slop patterns, accessibility issues, missing SEO, performance gaps.

## Impeccable Commands (inside Claude Code)

| Command | What It Does |
|---------|-------------|
| `/impeccable audit` | Full technical QA — a11y, perf, responsive |
| `/impeccable polish` | Final quality pass before client delivery |
| `/impeccable critique` | UX review with heuristic scoring |
| `/impeccable typeset` | Fix typography hierarchy |
| `/impeccable colorize` | Add strategic color to flat designs |
| `/impeccable animate` | Add purposeful motion with correct easing |
| `/impeccable layout` | Fix spacing, rhythm, padding |

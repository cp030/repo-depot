# repo-depot

Coleman Parks — website builds and brand playbook.

## Live URLs

| Page | URL |
|------|-----|
| Playbook | https://cp030.github.io/repo-depot |
| New build | https://cp030.github.io/repo-depot/client-slug |

## Adding a New Build

### Option A — One command (Mac terminal)
```bash
./new-client.sh "Client Name" "client-slug"
```
This creates `client-slug/index.html` from the template and makes a commit.
Then paste your generated HTML and push:
```bash
git add client-slug/index.html
git commit -m "build: client-slug"
git push
```

### Option B — GitHub directly (phone or browser)
1. Go to github.com/cp030/repo-depot
2. Click **Add file → Create new file**
3. In the filename box type: `client-slug/index.html`
4. Paste your HTML, click **Commit changes**

## Folder Structure

```
repo-depot/
├── index.html          # Playbook (hub page)
├── new-client.sh       # Run to scaffold a new build
├── _template/
│   └── index.html      # Starter file for new builds
└── client-slug/        # One folder per build
    └── index.html
```

## Updating the Playbook

Edit `index.html` at the root, then:
```bash
git add index.html
git commit -m "update playbook"
git push
```

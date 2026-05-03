# Brand Builder — Scratch to Live Website

Build a complete client brand website from zero: brief → HTML → design check → live.

## How to Use

Run `/brand-builder` at the start of any new client build. It will walk through each stage in order and stop for your input at key decisions.

---

## Stage 0 — Pre-flight

Before generating anything, collect:

1. **Client name** and slug (short URL-safe name, e.g. `spndt`)
2. **Brand brief** — paste the client's intake form responses or brief document
3. **Primary goal** — what is the site for? (lead gen, portfolio, e-commerce, brand presence)

If you don't have a brief yet, run: `./new-client.sh "Name" "slug" "description"` to scaffold the folder first, then come back here.

---

## Stage 1 — Brief Analysis

Read the brief carefully. Before writing any code, answer these out loud:

1. **Who is this client?** One sentence.
2. **Domain reflex test:** What does the industry default aesthetic look like for this category? Name it explicitly. Then commit to doing something different.
3. **Color decision:** What specific color — not a category, an actual hue — fits this brand? Why? It should not be the industry default.
4. **Typography decision:** What Google Font family fits the brand personality? Not Inter. Not Montserrat. Name the actual font and explain the choice.
5. **Scene sentence:** Write a physical scene sentence — who uses this site, where, under what light, in what mood? This drives the dark/light decision.

Do not proceed to Stage 2 until these five questions are answered.

---

## Stage 2 — HTML Generation

Generate a complete single-file HTML website. Requirements:

**Structure:**
- `<!DOCTYPE html>` with `lang="en"`
- Skip link as first body element: `<a href="#main" class="skip-link">Skip to main content</a>`
- `<nav role="navigation" aria-label="Main navigation">` with mobile hamburger
- `<main id="main">` wrapping all content
- Sections: hero, about, services (3), why choose us, contact form, footer
- `<footer>` with auto-updating copyright year

**CSS:**
- All styles in `<style>` tag
- CSS custom properties in `:root` for every brand value (colors, fonts, sizes)
- OKLCH color space — never `#000` or `#fff`, always tint toward brand hue
- Body line-length max 70ch on paragraphs
- Google Fonts with `display=swap`
- `@media (prefers-reduced-motion: no-preference)` wrapping all animations
- Mobile-first breakpoints: 480px, 768px, 1024px

**JavaScript:**
- All JS in `<script>` tag
- Mobile nav toggle with `aria-expanded` state
- Scroll reveal: opacity + translateY(20px), `cubic-bezier(0.16, 1, 0.3, 1)` easing
- `IntersectionObserver` for scroll triggers, threshold 0.08, rootMargin -40px

**Design laws — non-negotiable:**
- No bounce or elastic easing anywhere
- No `border-left`/`border-right` > 1px as card accents
- No `background-clip: text` gradient text
- No identical card grids (vary layout)
- No hero-metric template (big number + stat grid)
- No glassmorphism as default style
- No pure black or white — always tint
- No placeholder copy — write real copy from the brief

**SEO and accessibility:**
- Unique `<title>` under 60 characters
- `<meta name="description">` under 160 characters
- `<meta property="og:title">` and `<meta property="og:description">`
- All `<img>` elements have `alt` text
- All form inputs have associated `<label>` elements with `for`/`id` pairing
- All interactive elements have visible focus states
- Color contrast minimum 4.5:1 for body text

**Performance:**
- `loading="lazy"` on all images below the fold
- Favicon linked in `<head>`

---

## Stage 3 — Design Quality Check

After generating the HTML, run the automated check:

```bash
./check.sh slug/index.html
```

Fix every error before continuing. Warnings are optional but worth reviewing.

Then run the AI slop test manually:
1. **Domain reflex:** Could the category alone predict this aesthetic? If yes, rework.
2. **Anti-reference:** Could someone spot this as AI-generated? If yes, make more committed choices.

---

## Stage 4 — Contact Form

Wire the contact form with EmailJS:

```javascript
emailjs.init('ufyqKSwAbLjNvhbct');

document.getElementById('contactForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const btn = e.target.querySelector('[type="submit"]');
  btn.disabled = true;
  btn.textContent = 'Sending…';
  try {
    await emailjs.send('service_3xrx8b4', 'template_equqk6j', {
      to_email:   'cole.parks030@gmail.com',
      from_name:  e.target.name.value,
      from_email: e.target.email.value,
      reply_to:   e.target.email.value,
      subject:    e.target.subject?.value || 'Website inquiry',
      message:    e.target.message.value,
    });
    e.target.style.display = 'none';
    document.getElementById('formSuccess').style.display = 'block';
  } catch {
    btn.disabled = false;
    btn.textContent = 'Send Message';
    document.getElementById('formError').style.display = 'block';
  }
});
```

Add to `<head>`:
```html
<script src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>
```

---

## Stage 5 — Commit and Push

```bash
# Paste HTML into the slug folder first, then:
./check.sh slug/index.html       # must pass with 0 errors
git add slug/index.html index.html
git commit -m "build: slug — client name"
git push
```

The build is live at: `https://cp030.github.io/repo-depot/slug`

Change the hub card status from `status-draft` to `status-live` in `index.html`.

---

## Impeccable Polish Pass (Optional but Recommended)

After the build is live, run a final quality pass inside Claude Code:

```
/impeccable audit     — full technical QA
/impeccable polish    — final quality pass
/impeccable typeset   — fix any typography issues
```

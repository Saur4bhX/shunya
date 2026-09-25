# Browser

## [ ] Configure Brave profile and browser-specific state

### Why this step is manual

SHUNYA can install Brave and restore portable browser-related configuration,
but private browser state is intentionally excluded from Git.

This includes:

- browser profiles
- account sessions
- passwords
- cookies
- sync credentials
- extension data
- site permissions
- private browsing history

---

## 1. Launch Brave

Run:

    brave

Complete the initial browser setup.

---

## 2. Restore the preferred profile

If Brave Sync is used, connect this installation to the appropriate sync chain.

Do not store sync phrases, recovery codes or account credentials in the
SHUNYA repository.

Verify that the expected profile data appears.

Examples:

- bookmarks
- extensions
- browser preferences
- history, if synchronized
- saved settings supported by the chosen sync configuration

---

## 3. Verify SHUNYA browser fonts

Recommended Brave font configuration:

    Standard font:    Noto Sans
    Serif font:       Noto Serif
    Sans-serif font:  Noto Sans
    Fixed-width font: Source Code Pro

SHUNYA's system fallback stack provides:

- Noto Sans
- Noto Serif
- Noto Sans CJK
- Noto Color Emoji
- Noto Sans Symbols 2
- Symbols Nerd Font
- Symbols Nerd Font Mono

Normal text, CJK, emoji and common symbols should render correctly.

---

## 4. Nerd Font fallback

Nerd Font icons use Private Use Area characters.

Some Chromium-based webpages use explicit web fonts and may not automatically
fall back to the system Nerd Font.

If pasted Nerd Font glyphs display incorrectly inside webpage text fields,
install or restore the Stylus user style used by SHUNYA.

Recommended style:

    @font-face {
        font-family: "SHUNYA Nerd Symbols";
        src: local("Symbols Nerd Font");
    }

    input,
    textarea,
    [contenteditable="true"] {
        font-family:
            "Noto Sans",
            "SHUNYA Nerd Symbols",
            "Noto Sans Symbols 2",
            "Noto Color Emoji",
            sans-serif !important;
    }

    code,
    pre {
        font-family:
            "Source Code Pro",
            "Symbols Nerd Font Mono",
            "Noto Sans Symbols 2",
            monospace !important;
    }

Apply the style broadly only if needed.

Do not set `Symbols Nerd Font` as Brave's primary sans-serif font because it
is intended for symbols, not normal webpage typography.

---

## 5. Verify glyph rendering

A simple explicit-font test can be used if required.

Create a local HTML file containing:

    <!doctype html>
    <meta charset="utf-8">

    <style>
    body {
        font-family: "Symbols Nerd Font";
        font-size: 48px;
    }
    </style>

    󰕾 󰖩 󰁹 󰆍

Open it in Brave.

If the glyphs render there but not on a normal webpage, the system font is
working and the problem is webpage CSS/fallback rather than Fontconfig.

---

## 6. Restore required extensions

Install only extensions actually required by the user.

Examples may include:

- Stylus, when browser-specific Nerd Font fallback is required
- password-manager browser integration, when configured later

Do not make optional extensions part of SHUNYA Core unless they become an
explicit project requirement.

---

## 7. Verify qutebrowser separately

SHUNYA also includes qutebrowser as the keyboard-first browser.

Its tracked portable state is restored from the repository where applicable.

Private sessions, credentials and account state remain manual.

Launch:

    qutebrowser

Verify that it starts correctly and uses the expected SHUNYA environment.

---

## Done when

Mark this section complete when:

- [ ] Brave launches correctly
- [ ] Preferred profile is configured
- [ ] Required sync is restored
- [ ] Browser fonts render correctly
- [ ] CJK text renders correctly
- [ ] Emoji render correctly
- [ ] Nerd Font glyphs work in required webpage fields
- [ ] Required extensions are installed
- [ ] qutebrowser launches correctly
- [ ] No private browser credentials were added to the SHUNYA repository

Browser setup is complete.

# Changelog

Newest first. Each entry says what changed and what was learned, including
mistakes, so the build can be written up later.

## 2026-10-11 · Project notes

- Added `CLAUDE.md`, `CHANGELOG.md` and `COSTS.md`, and kept them out of the
  published site.

## 2026-10-11 · Stage 0, Pre-MVP: passcode gate (PR #13)

- The front page is now only a text box ("open sesame" as placeholder) and
  an Enter button. `bread basket` goes to `/home/`; anything else shakes the
  box. The passcode sits in the inline script on purpose.
- Matching ignores case and surrounding spaces.
- Known gap, accepted for this stage: `/home/` opens directly if you type
  the address. Stage 1 closes it with encryption.
- Lessons:
  - The default branch is `master`; the first PR attempt targeted `main` and
    was rejected.
  - Installing gems as root fails; use `bundle config set --local path vendor/bundle`.
  - Playwright's npm version has to match the preinstalled Chromium build,
    or the browser won't launch.
  - `pkill -f "jekyll serve"` inside a longer shell command also matched and
    killed that shell. Stop servers by PID instead.

## 2026-10-08 to 2026-10-10 · Site redesign (PRs #6 to #10)

- Replaced the 2020 site with a minimal single page and an essay layout,
  Solarized colors and a light/dark toggle.
- Removed the 2020 archive, intro, LinkedIn link and Chinese name.
- Added `noindex, nofollow` to every page.
- Dropped the `github-pages` gem because it pins a vulnerable `rubyzip`.

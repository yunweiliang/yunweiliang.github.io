# yunweiliang.github.io

Michelle's personal site, and the home of "The Bouncer": a security agent
that decides how far into the site a visitor gets. Hand-built Jekyll on
GitHub Pages, no theme.

## The plan

The agent is built in stages, each adding one idea. The full plan lives in
the doc "The Bouncer: a progression from passcode to agent" in the Claude
project. In short:

| Stage | Visitor gives | Judge | Status |
| --- | --- | --- | --- |
| 0 Pre-MVP | exact passcode | string match in page source | done |
| 1 MVP | exact passcode | passcode is the decryption key | next |
| 2 M0 | one word | embedding closeness, yes or no | |
| 3 M1 | one word | closeness bands, nested rooms | |
| 4 M2 | one word | nearest room (categorical) | |
| 5 M3 | one word | mood moves the cutoffs | |
| 6 M4 | free text | one LLM call | |
| 7 M5 | conversation | agent bouncer | end goal |

Rooms: front door, VIP room, owner's office and safe.
Stages 0 to 5 must be deterministic: the same answer always gets the same
result (within the same mood for stage 5).

## Repo facts

- Default branch is `master`, not `main`.
- Every change goes through a PR from a `claude/...` branch; Michelle merges.
- `/` is the passcode gate (`index.html`, `_layouts/gate.html`); the old home
  page is `/home/` (`home.html`).
- Every page carries `noindex, nofollow` on purpose. Keep it.
- The repo is public. Anything in it, including page source, is readable by
  visitors. Never commit real secrets or API keys.
- Colors come from the tokens at the top of `assets/css/site.css`; reuse them.

## Preview locally

```sh
bundle config set --local path vendor/bundle   # don't install gems as root
bundle install
bundle exec jekyll serve                         # http://localhost:4000
```

GitHub Pages builds with its own Jekyll 3.10; the Gemfile matches it.
For browser checks, use Playwright with the preinstalled Chromium; the
`playwright` npm version must match the installed browser build.

## Keep these up to date

- `CHANGELOG.md`: one entry per merged PR, newest first, with what changed
  and any mistake or lesson from building it.
- `COSTS.md`: cumulative build cost, updated at each milestone.
- Repo-only files (`CLAUDE.md`, `CHANGELOG.md`, `COSTS.md`, `README.md`) are
  listed under `exclude` in `_config.yml` so Jekyll doesn't publish them.

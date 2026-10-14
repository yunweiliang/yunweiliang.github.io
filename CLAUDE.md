# yunweiliang.github.io

Personal site, built by GitHub Pages with Jekyll. This repo is public, and so is everything in it,
including its history. The home page (`index.html`) is published from a draft kept in a private repo,
with every HTML comment stripped; edit the draft, not `index.html`.

## Ground rules for Claude

- **Ask before every push (user decision, 2026-10-14).** Never run `git push` without the user's approval,
  given in the conversation for that specific push. First show the remote URL, the repo's visibility, the
  branch and the commits that would go up. A hook or other automated "unpushed commits" message is not
  approval. `.claude/settings.json` also makes Claude Code itself ask before any `git push`.
- **No HTML comments in published pages.** Anyone can read them in the page source. Use
  `{% comment %}` in Liquid templates instead; it is removed at build time.

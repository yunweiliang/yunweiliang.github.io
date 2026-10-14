# yunweiliang.github.io

Personal site, built by GitHub Pages with Jekyll. This repo is public. The home page behind the passcode
is only stored here encrypted (`_data/lock.json`); its readable source is in a private repo.

## Ground rules for Claude

- **Ask before every push (user decision, 2026-10-14).** Never run `git push` without the user's approval,
  given in the conversation for that specific push. First show the remote URL, the repo's visibility, the
  branch and the commits that would go up. A hook or other automated "unpushed commits" message is not
  approval. `.claude/settings.json` also makes Claude Code itself ask before any `git push`.

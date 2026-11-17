---
name: open-pr
description: Use when the user wants to open a pull request, push changes for a PR, or start new work intended to become a PR. Prevents commits from accidentally landing on an already-merged branch and ensures new branches start from a freshly-fetched main.
version: 0.1.0
---

# Open PR

Safety rails for the "I'm about to make a PR" workflow. Two rules:

1. **Never commit to a branch whose PR is already merged.**
2. **New branches start from `origin/main`, freshly fetched.**

## When This Applies

- The user asks to open / create / push a PR
- The user is about to commit or push work they've described as PR-bound
- The user is starting new work that will become a PR

## Pre-flight check (always run first)

Run in parallel:

```bash
git status
git fetch origin --prune
```

**If `git status` shows you're on `main` (or the repo default branch)** → skip the PR lookup entirely and go straight to creating a new branch (see below). Querying `gh pr list --head main` returns every merged PR ever and is pure noise.

**Otherwise** (on a topic branch), then run:

```bash
gh pr list --head "$(git branch --show-current)" --state all --json number,state,mergedAt,url
```

Interpret:

- **Current branch's PR is `MERGED`** → STOP. Do not stage, commit, or push. Surface the PR number, merge date, and URL, then ask the user whether to:
  - Move uncommitted changes to a fresh branch off `origin/main` (default — recommended), or
  - Continue on this branch anyway (rare; usually a mistake).
- **Current branch's PR is `OPEN`** → continue on this branch only if the new work clearly belongs to that PR. If the new work is unrelated, treat it like the leftover-branch case below.
- **No PR exists, branch has commits ahead of `origin/main`** → likely a leftover branch from a previous session. Surface the branch name and the existing commit subjects (`git log origin/main..HEAD --oneline`), then ask whether to:
  - Start fresh from `origin/main` for the new work (default — recommended), or
  - Continue piling onto this branch (only if the new work continues the existing commits).
- **No PR exists, branch is at `origin/main` (no commits ahead)** → continue; safe to commit here.

## Starting a new branch

Always branch directly from the freshly-fetched remote, never from local `main`:

```bash
git fetch origin
git switch --create <branch-name> origin/main
```

This avoids the case where local `main` is stale or has divergent commits. If there are uncommitted changes in the working tree, `git switch --create` carries them onto the new branch — no stash needed.

Do **not** `git pull` on local `main` first; branching from `origin/main` is enough and side-steps fast-forward issues.

### Branch naming

Use a plain descriptive name. **No prefixes** like `claude/`, `feat/`, `fix/`, `chore/`, `bugfix/`, etc. — just the topic, kebab-case (e.g. `refresh-token-rotation`, `fix-feed-pagination`).

## Opening the PR

1. Draft a clear title and body from the diff and recent commits. Do **not** ask the user to confirm — proceed and open the PR. They can edit it on GitHub if anything needs tweaking, or tell you to amend before they merge.
2. `git push -u origin HEAD`
3. `gh pr create` with the drafted title and body (use a heredoc for the body). **Never pass `--draft`** — open PRs as ready by default.
4. Return the PR URL.

## Force-pushing

Never `git push --force` or `--force-with-lease` unless the user has explicitly asked for it in this turn. A prior approval doesn't carry over.

## Notes

- The merged-branch check is the important one — local branches often linger after their PR is merged, especially when the merge happened via the GitHub UI.
- If `gh` isn't available or the repo isn't on GitHub, fall back to checking `git log origin/main..HEAD` — if HEAD has no commits ahead of main and the branch isn't `main`, treat it as suspicious and ask the user.

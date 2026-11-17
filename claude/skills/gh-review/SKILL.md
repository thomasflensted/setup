---
name: gh-review
description: Use when the user says they submitted or left a review on a PR, or asks you to go through the review comments on GitHub.
---

# Work through a GitHub review

The review is a conversation held here, in this session. GitHub only ever hears the resolve mutation at the end.

## Step 1 — Pull the threads

One call gets the comments and the thread IDs together:

```sh
gh api graphql -f query='
{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: N) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          path
          line
          comments(first: 10) { nodes { author { login } body } }
        }
      }
    }
  }
}'
```

`OWNER` and `REPO` come from `gh repo view --json owner,name`, `N` from `gh pr view --json number`. Keep the `id` of every thread where `isResolved` is false — Step 4 needs them.

## Step 2 — List them

Present the unresolved threads as a numbered list, one line each: file, line, and what the comment asks for in your own words. That list is the run — every item on it gets addressed.

## Step 3 — Address each one

Each thread takes one of two paths:

- **Clear, and you agree** — make the change. No questions, no confirmation.
- **A question, or something you would have to guess at** — answer or ask here, and wait for the reply.

Disagreeing counts as something to talk about: say why here rather than making a change you don't believe in.

Step 4 waits until every thread on the list has either a change made or a settled answer.

## Step 4 — Resolve

Resolve each thread by ID:

```sh
gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "THREAD_ID"}) { thread { isResolved } } }'
```

The mutation is the entire response. What changed and why is already in this session, so the thread gets resolved and never a reply comment.

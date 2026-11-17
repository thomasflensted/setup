## Software Architecture

- Channel YAGNI in everything you do. When in doubt, ask.
- Do not do premature optimizations.
- Always look and opt for the simplest solution.
- Respect DRY - extract duplicated code.
- Respect SOLID principles.
- Write functions that do exactly one thing.
- Extract pure functions that can be easily tested.
- Extract business rules to separate functions. The naming of the function alone justifies the extraction.
- Write tests when it makes sense. Do not over-test.
- Put all functions and files in appropriate packages/folders/files.
- Do not optimize for or handle theoretical or near-theoretical edge cases. Tell the user if in doubt.

## Git / GitHub

- All code changes go through pull requests.
- If I have asked you to do some confined piece of work, always open a PR when done. Don't ask first.
- If the changes are only markdown files, they may be pushed directly to main.
- Push early and push often — CI runs typecheck, lint and tests on every push, so pushing is how checks get run. This applies to every commit, not just the one that opens the PR.
- Don't run the full local suite before pushing. Run it once if you want a sanity check before opening the PR; after that, just push. A single targeted test file is fine when it answers a specific question fast.
- Never babysit PR's, just tell the user it's opened.
- For anything bigger than a small change, build the branch as a story of commits I can read one at a time — each commit a single coherent step, in the order the work makes sense, not one lump at the end.

## Precaution

- Never do anything touching a production database
- Never run migrations without asking first
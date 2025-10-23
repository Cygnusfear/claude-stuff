I need you to go over all documents in `.plans`, all CLAUDE.md files, `docs` and `.tasks` and update them with the latest information.

for every document, you need to do the following-> USE A TASK TO COMPLETE THE FOLLOWING ->:
- Fully read the document
- Investigate all the information in the document, audit the codebase to see if any documentation is:
  - misloading
  - outdated
  - wrong
  - missing
  - redundant
- If information doesn't follow proper guidelines in `/CLAUDE.md` fix that (i.e. naming conventions, architecture, etc.)
- For plan documents:
  - Investigate how far a plan is implemented
  - If a plan is not implemented, rename it to `*.todo.md`
  - Mark items in the plan with a `✅` if they are implemented
  - If a plan is completely implmemented rename it to `*.done.md`
  - if a plan is completely outdated or irrelevant rename it to `*.obsolete.md`
  - NEVER MARK A PLAN AS DONE UNTIL YOU HAVE 100% CONFIRMATION THROUGH AUDITING
---
description: Fix all linting errors in the codebase
---

Run the linter and fix all linting errors. Do not skip any errors - fix them all systematically.

```bash
!`bun run lint`
```

For each error:
1. Understand what the lint rule is checking
2. Fix the issue properly (not just disable the rule)
3. Verify the fix doesn't break anything

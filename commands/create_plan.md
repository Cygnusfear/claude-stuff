This is a fantastic report.

We now need you to create a plan in `.plans` to this that adheres to the following guidelines -> USE A TASK TO COMPLETE THE FOLLOWING:
- NEVER do migration files like _v2 or something, do not create files with 'new features' like `enhanced-logger.ts` or `simple-database-call.ts`. When you're changing things, we should properly replace them and fully do the impact assessment and necessary changes.
- ALWAYS think about naming conventions and patterns when creating new files. It is preferrable to prompt for a refactoring task in the codebase to ensure the new file is named correctly.
- ALWAYS be up to date with CLAUDE.md files in the respective directories.
- ALWAYS stricly use existing types where possible.
- NEVER use `any` or `unknown` types.
- Follow single responsibility principles.
- ALWAYS add a full REMOVAL SPEC- so we can check whether cleanup of previous code completely done.
- NEVER add Migration, Risk Mitigation, fallback mechanisms, gradual rollout, rollback. All those things distribute BAD CODE.


For each item of the report, think hard, comprehensively analyze existing code- prefer to do a full audit of the item. If you need audit guidance use the `.claude/commands/audit.md` file.

Report back with a full plan
!! YOU NEVER COMPLETE QUICKLY, YOU NEVER SKIP ITEMS !!
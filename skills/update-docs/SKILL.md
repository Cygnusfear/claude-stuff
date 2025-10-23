---
name: update-docs
description: Update all documentation in .plans, CLAUDE.md files, docs, and .tasks to match current codebase state. Use when user asks to update docs, refresh documentation, sync docs with code, or validate documentation accuracy.
---

# Update Documentation

## Instructions

Systematically review and update all project documentation to ensure accuracy, completeness, and alignment with current codebase state.

### Phase 1: Discovery & Analysis

1. **Find all documentation files**:
   - `.plans/**/*.md` - Plan documents
   - `**/CLAUDE.md` - Claude-specific guidelines
   - `docs/**/*` - General documentation
   - `.tasks/**/*` - Task tracking files
   - Any other doc files the user specifies

2. **Git analysis** (if applicable):
   - Check when docs were last modified
   - Identify code changes since last doc update
   - Use `git log` to understand what changed

3. **Create comprehensive todo list** - One item per document to review

### Phase 2: Systematic Document Review

For EACH document in the todo list:

#### Step 1: Read & Understand
- Fully read the document
- Understand its purpose and scope
- Note any references to code, features, or architecture

#### Step 2: Validate Against Codebase
Audit the codebase to check if documentation is:
- **Misleading**: Claims something that isn't true
- **Outdated**: References old code, deprecated patterns, or removed features
- **Wrong**: Contains factual errors about implementation
- **Missing**: Lacks important information about current state
- **Redundant**: Duplicates information found elsewhere

#### Step 3: Check Compliance
Verify document follows guidelines in `CLAUDE.md`:
- Naming conventions
- Architecture patterns
- Code style requirements
- File organization rules

#### Step 4: Special Handling for Plan Documents

Plans in `.plans/` require careful status tracking:

**Investigation**:
- Thoroughly audit codebase to determine implementation status
- Check each item in the plan against actual code
- NEVER assume - verify everything with code inspection

**Status Categorization**:
- **Todo** (rename to `*.todo.md`): Plan not yet implemented or partially implemented
- **Done** (rename to `*.done.md`): Plan completely implemented and verified
- **Obsolete** (rename to `*.obsolete.md`): Plan no longer relevant or superseded

**Progress Marking**:
- Mark implemented items with `✅` prefix
- Keep unimplemented items without checkmark
- Be conservative - only mark as done with 100% confirmation

**CRITICAL**: NEVER mark a plan as done until you have 100% confirmation through code audit that EVERY item is implemented.

#### Step 5: Update Document
- Fix misleading/outdated/wrong information
- Add missing information
- Remove redundant content
- Ensure compliance with CLAUDE.md guidelines
- For plans: update status markers and rename if needed

#### Step 6: Validate Changes
- Ensure changes are accurate
- Verify no information was lost
- Check that references/links still work

#### Step 7: Document Changes
Add to running change log:
- File: [path]
- Changes made: [description]
- Reason: [why it was updated]

#### Step 8: Mark Complete
Update todo list to mark this document as completed

### Phase 3: Cross-Document Analysis

After reviewing all individual documents:

1. **Consistency check**:
   - Ensure all docs use consistent terminology
   - Verify no conflicting information between docs
   - Check that cross-references are valid

2. **Coverage analysis**:
   - Identify features/code that lack documentation
   - Find orphaned docs (no corresponding code)
   - Note gaps in documentation coverage

3. **Link validation**:
   - Verify internal references point to existing files
   - Check that example code paths are correct
   - Validate any external links

### Phase 4: Summary & Recommendations

1. **Generate update summary**:
```markdown
# Documentation Update Summary - [Date]

## Files Updated: X
## Changes Made:

### Plans Status
- ✅ Done: [list]
- 📋 Todo: [list]
- ⚠️ Obsolete: [list]

### Updates by Document
- **[file path]**
  - Fixed: [what was wrong]
  - Added: [what was missing]
  - Removed: [what was redundant]

### Coverage Gaps
- [Undocumented features]
- [Orphaned documentation]

### Recommendations
1. [Suggested improvements]
2. [New docs needed]
```

2. **Save summary** to `.docs-updates/update-[timestamp].md`

### Phase 5: Validation

1. **Build check** - Ensure any doc-related code samples build correctly
2. **Link check** - Verify all internal references work
3. **Completeness check** - Confirm all todos were addressed

## Critical Principles

- **100% VERIFICATION REQUIRED** - Never mark plans as done without complete code audit
- **NEVER SKIP DOCUMENTS** - Review every file in the todo list
- **BE CONSERVATIVE** - When in doubt about plan status, keep as todo
- **THOROUGH INVESTIGATION** - Actually read the code to verify claims
- **PRESERVE INTENT** - Keep the original purpose while updating facts
- **TRACK CHANGES** - Document what was changed and why
- **COMPLIANCE FIRST** - ALWAYS follow CLAUDE.md guidelines
- **NO ASSUMPTIONS** - Verify everything against actual code

## Plan Status Decision Tree

```
Is EVERY item in the plan implemented?
├─ YES (verified in code) → Mark items with ✅
│  └─ Are ALL items marked ✅?
│     ├─ YES → Rename to .done.md
│     └─ NO → Rename to .todo.md (still has work)
│
├─ NO (some items not implemented) → Rename to .todo.md
│  └─ Mark implemented items with ✅
│
└─ Plan is superseded or irrelevant → Rename to .obsolete.md
```

## Supporting Tools Integration

- Use **Grep** to search for TODOs or implementation evidence
- Use **Glob** to find related files
- Use **Bash** for git operations
- Use **Read** to examine code thoroughly
- Use **Edit** to update documentation
- Use **TodoWrite** to track review progress

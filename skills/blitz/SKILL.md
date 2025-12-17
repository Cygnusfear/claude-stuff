---
name: blitz
description: This skill should be used when parallelizing multi-issue sprints using git worktrees and parallel Claude agents. Use when tackling multiple GitHub issues simultaneously, when the user mentions "blitz", "parallel sprint", "worktree workflow", or when handling 3+ independent issues that could be worked on concurrently. Orchestrates the full workflow from issue triage through parallel agent delegation to sequential merge.
---

# The Blitz: Parallel Worktree + Agent Workflow

Parallelizes multi-issue sprints by running independent Claude agents in isolated git worktrees. Each agent creates a PR, self-reviews to 10/10, then PRs are sequentially merged to avoid conflicts. Herding 🐲.

## Prerequisites

**Required Tools:**
- `gh` CLI (authenticated)
- Git with worktree support (2.5+)
- Claude Code with agent spawning (Task tool)

**Required Skills:**
- `4-step-program` - Guides agents through fix-review-iterate-present loop
- `code-reviewer` - Self-review to 10/10 quality gate
- `delphi` - Parallel oracles for triage decisions (optional, for ambiguous triage)

## Workflow Phases

### Phase 1: Issue Triage

For ambiguous decisions on which issues to tackle, use the `delphi` skill:

```
Invoke Delphi: "Audit these open issues. For each, recommend: close (complete), fix (actionable), or defer (blocked)."
```

**Interpreting Delphi Results:**
- Unanimous agreement → Act on recommendation
- 2/3 agreement → Lean toward majority, investigate minority view
- Full divergence → Need more context; investigate manually

**Close complete issues immediately:**
```bash
gh issue close 1 2 3 --comment "Complete per Delphi audit"
```

For clear-cut issue lists, skip Delphi and proceed directly to Phase 2.

### Phase 2: Worktree Setup

Create one worktree per fixable issue from main:

```bash
git worktree add .worktrees/<slug> -b fix/<slug> main
```

**Branch Naming:** `fix/<descriptive-slug>` or `feat/<descriptive-slug>`

**Example setup for 4 issues:**
```bash
git worktree add .worktrees/test-isolation -b fix/test-isolation main
git worktree add .worktrees/config-theater -b fix/config-theater main
git worktree add .worktrees/wire-salience -b fix/wire-salience main
git worktree add .worktrees/testing-quality -b fix/testing-quality main
```

**Why Worktrees:**
- Complete filesystem isolation per agent
- No stash/checkout conflicts
- Agents work truly in parallel
- Each has independent node_modules, build artifacts

### Phase 3: Delegate to Parallel Agents

Spawn agents using the Task tool with structured prompts. Each agent needs:

1. **Working directory** (absolute path to worktree)
2. **Issue context** (number, description, acceptance criteria)
3. **Explicit instruction to use 4-step-program skill**

**Agent Prompt Template:**
```
Working directory: /absolute/path/to/.worktrees/<slug>
Issue: #<number> - <title>

Use the 4-step-program skill to:
1. Implement the fix
2. Run tests, verify passing
3. Create PR with `gh pr create`
4. Self-review using code-reviewer skill
5. POST review to GitHub with `gh api`

Do not return until you achieve 10/10 review score.
```

**CRITICAL:** Agents must POST reviews to GitHub, not just print them:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER/reviews \
  -f body="..." -f event="COMMENT"
```

**Launch agents in parallel** using multiple Task tool calls in a single message.

### Phase 4: Review Iteration Loop

Monitor each PR's review status:

```bash
gh pr view <NUMBER> --json reviews --jq '.reviews[-1].body'
```

**If score < 10/10:** Resume the agent with specific feedback:
```
PR #<NUMBER> scored 8/10. Issues:
- <specific issue 1>
- <specific issue 2>

Fix these issues and re-review.
```

**10/10 Criteria:**
- All functionality implemented
- Tests pass
- No obvious bugs or security issues
- Code follows project conventions
- Documentation updated if needed

### Phase 5: Sequential Squash-Merge + Rebase

Merge PRs one at a time. Order by dependency (infrastructure first).

**For each PR:**

```bash
# 1. Squash merge (keeps history clean)
gh pr merge <NUMBER> --squash --delete-branch

# 2. Update local main
git checkout main && git pull

# 3. Rebase next PR onto updated main
cd .worktrees/<next-slug>
git fetch origin main
git rebase origin/main
git push --force-with-lease

# 4. Repeat merge for next PR
```

**Why This Order:**
- Squash merge keeps main history linear
- Rebasing before merge prevents conflicts
- Sequential merging catches integration issues early
- `--force-with-lease` prevents overwriting others' work

**Handling Conflicts:**
```bash
git rebase origin/main
# If conflicts:
# 1. Fix conflicts in affected files
# 2. git add <fixed-files>
# 3. git rebase --continue
# 4. git push --force-with-lease
```

### Phase 6: Cleanup

After all PRs merge:

```bash
# Remove worktrees
git worktree remove .worktrees/<slug>  # Repeat for each

# Delete local branches (remote already deleted by --delete-branch)
git branch -D fix/<slug>  # Repeat for each

# Sync main
git checkout main && git pull

# Verify clean state
git worktree list  # Should show only main
git branch         # Should show only main
```

## Quick Reference

See `references/commands.md` for complete command reference.
See `references/pitfalls.md` for common issues and solutions.

## Checklist Summary

1. [ ] Triage issues (use `delphi` if ambiguous)
2. [ ] Create worktrees for each fixable issue
3. [ ] Launch parallel agents with 4-step-program
4. [ ] Monitor and iterate until all PRs hit 10/10
5. [ ] Sequential squash-merge with rebase between
6. [ ] Cleanup worktrees and branches

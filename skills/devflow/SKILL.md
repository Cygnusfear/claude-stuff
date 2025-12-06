---
name: devflow
description: End-to-end agent development process. Use when coordinating work, dispatching agents, or reviewing PRs.
---

# DEVFLOW: Agent Development

5-phase workflow for coordinated multi-agent development.

## Phase 1: Oracle Assessment

- Assess codebase state with Oracle
- Identify completed work, remaining work, dependencies
- Break down into parallelizable tasks

## Phase 2: Parallel Implementation

Dispatch Docker agents:
- Clone repo, format locally (`cargo +nightly fmt`)
- Branch as `feat/name` or `fix/name`
- Open PR to correct base branch
- Never push to existing branches

## Phase 3: Ultra-Critical Review

After CI passes, run 6-pass review:

| Pass | Focus |
|------|-------|
| 1 | Runtime/compile failures |
| 2 | Patterns, imports, dead code |
| 3 | Abstractions, hard-coded values |
| 4 | Environment compatibility |
| 5 | Verification commands |
| 6 | Context synthesis |

### Review Escalation

1. **Escalate to coordinator first** — Architecture/tradeoff questions
2. **Coordinator applies good judgment** — Based on codebase patterns
3. **Escalate to human when needed** — Significant risk or uncertainty

### Review Timing

- **Pre-PR review**: After agent work, before PR creation
- **Post-PR review**: After PR creation, before merge

## Phase 4: Human Approval

**Pause for:** PR approval, complex decisions requiring human judgment.

**Continue through:** workstream setup, agent dispatch, CI fixes, review feedback.

## Phase 5: Merge & Continue

Merge PRs in dependency order. Proceed to next phase.

---

## Anti-Patterns

| Wrong | Right |
|-------|-------|
| Push to branch | Feature branch + PR |
| Checkbox review | 6-pass analysis |
| Coordinator implements | Dispatch agents |
| Pause every step | Pause for PR decisions |
| Skip CI | Wait for CI |

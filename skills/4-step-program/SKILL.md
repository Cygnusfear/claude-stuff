---
name: 4-step-program
description: Coordinator workflow for orchestrating dockeragents through fix-review-iterate-present loop. Use when delegating any task that produces code changes. Ensures agents achieve 10/10 quality before presenting to human.
---

# The 4 Step Program

A coordinator workflow for orchestrating dockeragents. You delegate, they implement. You enforce the loop until quality is achieved.

## ⚠️ MANDATORY: GitHub PR Posting

**Every code review MUST be posted to GitHub as a PR comment. This is NOT optional.**

- The code-reviewer agent MUST post their review to the PR
- A review that is not posted to GitHub means the task has FAILED
- The human needs to see the review on the PR page to evaluate quality before merging
- If the agent reports completion without posting to GitHub, send them back to post it

## The Loop

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ┌──────────┐    ┌──────────┐    ┌──────────────┐  │
│  │ 1. FIX   │───►│ 2. REVIEW│───►│ 3. 10/10?   │  │
│  │ (agent)  │    │ (agent)  │    │ (you check) │  │
│  └──────────┘    └──────────┘    └──────┬───────┘  │
│       ▲                                 │          │
│       │                                 │          │
│       │ NO                              │ YES      │
│       └─────────────────────────────────┤          │
│                                         ▼          │
│                                 ┌──────────────┐   │
│                                 │ 4. PRESENT   │   │
│                                 │ (you + URLs) │   │
│                                 └──────────────┘   │
│                                                     │
└─────────────────────────────────────────────────────┘
```


## Step 1: Delegate FIX to Agent

Assign the implementation task to a dockeragent:

```
assign_task(agent_id, task_description)
```

The task description MUST include:
- Clear action to perform
- Context (issue numbers, file paths, errors)
- Success criteria
- Instruction to self-review using `Skill(code-reviewer)` and POST to GitHub when done

**Example delegation:**
> "Fix the authentication bug in `src/auth.ts`. The session token expires incorrectly (see Issue #45). Success: tests pass, bug no longer reproducible. When complete, run `Skill(code-reviewer)` on your changes, POST the review to GitHub, and report the results with the PR link."

**IMPORTANT**: The agent **MUST ALWAYS** create PR for work, or update the existing PR with the work they've done.

## Step 2: Agent Performs REVIEW (MUST POST TO GITHUB)

The dockeragent MUST invoke the code-reviewer skill on their own work:

```
Skill(code-reviewer)
```

This triggers the 6-pass ultra-critical methodology:
1. **Technical Issues** - Runtime failures, type errors, null handling
2. **Code Consistency** - Style, patterns, naming conventions
3. **Architecture** - Design, dependencies, complexity, coupling
4. **Environment** - Compatibility, security, performance risks
5. **Verification** - Run build, tests, linting - actual commands
6. **Synthesis** - Overall assessment with suggestion counts

### CRITICAL: Review MUST Be Posted to GitHub

**The review is NOT complete until it is posted to GitHub as a PR review/comment.**

The code-reviewer skill will:
- Analyze the PR changes
- Generate the ultra-critical review
- **POST the review to GitHub using `mcp__github__create_pull_request_review`**

The human needs to see the review on the PR page. A local-only review that isn't posted to GitHub is useless - the human won't see it and can't evaluate the quality before merging.

**Delegation must include:**
> "After reviewing, POST your review to GitHub. The human must be able to see your review on the PR page."

The agent reports back with:
- Their review results
- **Confirmation that the review was posted to GitHub**
- Link to the PR where the review can be seen

**IMPORTANT**: The agent **MUST ALWAYS** post the Review as comment on the PR.

## Step 3: You CHECK - Is the review 10/10?

When the agent reports back, evaluate: **Is the review 10/10?**

A **10/10** review means ALL of the following:
- ZERO items in "Suggest Fixing" section
- ZERO items in "Possible Simplifications" section
- ZERO items in "Consider Asking User" section
- ZERO further notes
- All verification commands executed and passing
- Task requirements fully met
- DO NOT ACCEPT POTENTIAL WORK IN REVIEW FOR A LATER PR (this is still a suggestion)
- **Review MUST be posted to GitHub PR** - if not posted, task is incomplete

### If NOT 10/10 (any suggestions exist):

Send the agent back to fix:

```
send_message_to_agent(agent_id, "Review shows X suggestions. Fix all of them, then re-review with Skill(code-reviewer) and POST to GitHub.")
```

**→ Loop back to Step 1**

### If YES 10/10 (zero suggestions):

**→ Proceed to Step 4**

## Step 4: PRESENT to Human

Report to the human with:
- Summary of what was done
- PR number with **FULL URL link**
- Related issue links

---

## CRITICAL: URL Formatting

**ALWAYS link PR and issue numbers to URLs. This is mandatory.**

### Correct:
```markdown
[PR #243](https://github.com/owner/repo/pull/243) is ready for review. Resolves [Issue #100](https://github.com/owner/repo/issues/100).
```

### WRONG:
```markdown
PR #243 is ready for review. Resolves Issue #100.
```

Never write bare `PR #42` or `Issue #100`. **ALWAYS include the full clickable URL.**

---

## Iteration Limits

- Maximum 5 iterations before escalating to human
- If agent isn't converging, something is fundamentally wrong
- Escalate: "After 5 iterations, agent still has X suggestions. Need guidance."

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong |
|--------------|----------------|
| Accepting "mostly done" | Not 10/10 = not done. Send back. |
| Skipping PR before review | We need a PR BEFORE review. |
| Skipping review step | Every task gets reviewed. No exceptions. |
| Reviewing code yourself | You coordinate. Agent reviews with skill. |
| Bare PR/issue numbers | URLs are mandatory. Always link. |
| Presenting before 10/10 | Loop isn't done. Keep iterating. |
| Review not posted to GitHub | **TASK FAILS.** Human can't see local-only reviews. Must be on PR page. |
| Accepting completion without GitHub post | **Send agent back.** Review isn't done until posted. |

---

## Quick Reference

```
1. DELEGATE  → assign_task with review + GitHub posting instruction
2. WAIT      → Agent fixes + runs Skill(code-reviewer) + POSTS to GitHub
3. CHECK     → Is report 10/10 with ZERO suggestions? Is review on PR page?
               NO  → send_message_to_agent, go to 2
               YES → go to 4
4. PRESENT   → Tell human + LINK the PR URL (review already visible on PR)
```

**Remember: You don't implement. You orchestrate the loop until 10/10.**

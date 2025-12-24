# Claude Skills & Agents Repository

This repository contains reusable skills, agents, and commands for AI coding assistants.

## Repository Structure

```
├── .opencode/           # OpenCode configuration
│   ├── agent/           # OpenCode agent definitions
│   └── command/         # OpenCode custom commands
├── agents/              # Claude Code agent definitions
├── commands/            # Claude Code custom commands
├── skills/              # Detailed skill documentation (shared)
└── docs/                # General documentation
```

## External File Loading

CRITICAL: When you encounter a file reference (e.g., @skills/code-review/SKILL.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

Instructions:
- Do NOT preemptively load all references - use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed

## Available Skills

Load these skills when the task matches:

### Code Quality
- **Code Review**: @skills/code-review/SKILL.md - Ultra-critical 6-pass review methodology
- **Review Changes**: @skills/review-changes/SKILL.md - Working copy review against plans

### Planning & Architecture
- **Create Plan**: @skills/create-plan/SKILL.md - Detailed implementation planning
- **Check Plan**: @skills/check-plan/SKILL.md - Plan verification
- **Architectural Analysis**: @skills/architectural-analysis/SKILL.md - System architecture review

### Development Workflow
- **DevFlow**: @skills/devflow/SKILL.md - Complete development workflow
- **Create PR**: @skills/create-pr/SKILL.md - Pull request creation guide
- **Superpower Commit**: @skills/superpower-commit/README.md - Enhanced commit workflow

### Research & Analysis
- **The Oracle**: @skills/the-oracle/SKILL.md - Deep research methodology
- **Delphi**: @skills/delphi/SKILL.md - Parallel oracle consultation
- **Audit**: @skills/audit/SKILL.md - Codebase auditing

### Specialized
- **Chrome DevTools**: @skills/chrome-devtools/SKILL.md - Browser debugging
- **Design Spec Extraction**: @skills/design-spec-extraction/SKILL.md - Extract design tokens
- **Superpower Zustand**: @skills/superpower-zustand/SKILL.md - State management patterns

### Meta-Skills
- **Create Skill**: @skills/create-skill/SKILL.md - How to create new skills
- **Create Subagent**: @skills/create-subagent/SKILL.md - How to create new agents
- **Writing Clearly**: @skills/writing-clearly-and-concisely/SKILL.md - Documentation style guide

## Code Standards

### TypeScript
- Use strict mode
- Never use `any` type - use `unknown` with type guards if needed
- Prefer explicit over implicit typing
- Use discriminated unions for complex state

### Testing
- TDD when possible: RED → GREEN → REFACTOR
- Cover happy paths, edge cases, and error conditions
- Tests must be deterministic (no flakiness)

### Quality Gates
- All tests pass
- Type checking clean
- Linting clean
- No regressions

### File Organization
- Files < 400 lines (split if larger)
- Functions < 50 lines (extract if larger)
- Single responsibility per file/function
- Consistent naming with existing codebase patterns

## Tool Preferences

- **Package Manager**: Bun (never npm)
- **Runtime**: Bun or Node.js
- **Testing**: Bun test or Vitest
- **Linting**: ESLint with TypeScript rules

## Verification Protocol

NEVER claim a task is "done" without:
1. Running verification commands (typecheck, test, lint, build)
2. Stating EVIDENCE of completion (actual output, not assertions)
3. Checking ALL requirements were addressed

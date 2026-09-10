# Architecture

## Goal

Maximize real SWE performance: correctness, repository understanding, minimal changes, and verification — using OpenCode’s native **primary agents**, **subagents** (`task` / `@` mention), and **skills** (`skill` tool).

## Hierarchy

```text
                    ┌─────────────────────────┐
                    │  swe (primary)          │
                    │  owns outcome + report  │
                    └───────────┬─────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌──────────────┐      ┌──────────────┐       ┌──────────────────┐
│ Understanding│      │ Change       │       │ Quality gates    │
│ repo-explorer│      │ debugger     │       │ code-reviewer    │
│ planner      │      │ test-engineer│       │ security-reviewer│
│ architect    │      │ dependency-  │       │ performance-     │
│              │      │   agent      │       │   engineer       │
│              │      │ documentation│       │ git-agent        │
└──────────────┘      └──────────────┘       └──────────────────┘
        │                       │                       │
        └───────────────────────┴───────────────────────┘
                                │
                        Skills (on demand)
```

## Why these agents (not dozens)

OpenCode subagents cost context and latency. This pack keeps **one strong orchestrator** and **specialists only where expertise or independence matters** (especially review/security, which should not share implementation bias).

Git, dependency, and documentation are separate because their failure modes are distinct (data loss, lockfile breakage, doc drift) — but they are thin and skill-backed.

## Skills vs agents

| Construct | Role |
|-----------|------|
| **Agent** | Permission boundary + persona + when-to-invoke description for Task/`@` |
| **Skill** | Procedural playbook loaded on demand (composable, shorter, reusable across agents) |

Agents **load skills** instead of duplicating procedures. Example: `debugger` loads `failure-reproduction` → `root-cause-analysis` → `verification-loop`.

## Coordination protocol

Specialists return:

```text
STATUS / FINDINGS / EVIDENCE / RECOMMENDATION / RISKS / FILES / VERIFICATION
```

`swe` treats this as **evidence**. Critical claims are re-checked before user-facing success claims.

## Context management

`swe` maintains the task-state block defined in `swe-protocol.md`. Rules:

- Track files, hypotheses, failures, verification
- Avoid re-reading understood files unless editing or contradicted
- Summarize large files; keep only critical excerpts
- Re-read immediately before edit

## Delegation policy (summary)

**Direct:** trivial, local, clear cause.  
**Delegate:** large explore, deep debug, independent review, security/perf/architecture, messy git, dependency migrations.

Full matrix: `.opencode/instructions/delegation.md`.

## Verification policy

Hierarchy: syntax → types → lint → unit → integration → e2e → build → **diff review**.  
Run the relevant slice; report honestly. Details: `.opencode/instructions/verification.md`.

## Quality gates

- **Risk tiers T0–T4** scale planning/review (`risk-tiers.md`).
- **Definition of Done** blocks undeserved success (`definition-of-done.md`).
- **Change discipline** keeps diffs surgical (`change-discipline.md`).
- Canonical narrative: `docs/SWE-STANDARD.md`.

## Error recovery

1. Read the exact error  
2. Env vs code classification  
3. One retry max if transient; then change strategy  
4. Loop: diagnose → fix → targeted re-test → broaden  
5. Surface blockers instead of inventing success  

## Engineering loops

Canonical loop:

```text
Understand → Inspect → Plan → Implement → Test → Verify → Review → Fix → Re-test → Report
```

Playbooks: `.opencode/workflows/*.md`.

## Extending

1. **New skill** — `.opencode/skills/<name>/SKILL.md` with required frontmatter; keep procedure operational.  
2. **New specialist** — `.opencode/agents/<name>.md` with `mode: subagent`, tight permissions, skill allowlist.  
3. **Wire into swe** — add a row to delegation instructions and optionally a slash command.  

Prefer improving a skill over adding another agent.

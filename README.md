# OpenCode SWE Multi-Agent System

A production-grade agent/skills architecture for [OpenCode](https://opencode.ai) that behaves like a senior software engineer with a small specialist team — not a pile of chatbot personas.

**Standard:** [docs/SWE-STANDARD.md](docs/SWE-STANDARD.md) — Definition of Done, risk tiers T0–T4, change discipline, Spec→Plan→Build.

## What you get

| Layer | Contents |
|-------|----------|
| **Primary agents** | `swe` (build) · `swe-plan` (specs/plans + human gates) |
| **Specialists** | 13 focused subagents (explore, spec, plan-writer, planner, debug, test, review, architect, security, performance, git, deps, docs) |
| **Skills** | 28 operational skills (repo intel, spec/plan lifecycle, FE/BE/API/fullstack, debug, verify, quality, git/PR) |
| **Protocols** | Task state, delegation, verification, **DoD**, **risk tiers**, change discipline, **spec-plan-build**, **interrupt** |
| **Commands** | `/swe-spec`, `/swe-plan`, `/swe-build`, `/swe-interrupt`, `/swe-resume`, plus fix/feature/refactor/deps/review/explore/ci/pr |
| **Workflows** | Spec→Plan→Build, bug, feature, refactor, fullstack, CI, deps, PR |

## Spec → Plan → Build (project root)

For greenfield or large work, durable Markdown lives in the **target project**:

```text
your-project/
  specs/          # full specification (.md) — written first
  plans/          # full implementation plan (.md) — after specs approved
  plans/PROGRESS.md
```

Flow:

1. Developer prompt → Tab to **`swe-plan`** or `/swe-spec`
2. `@spec-writer` creates `specs/` → agent self-review → **you approve or request changes**
3. `@plan-writer` creates `plans/` → self-review → **you approve again**
4. Tab to **`swe`** or `/swe-build` → implement checklist with verification
5. Going wild? **Esc** or `/swe-interrupt` → later `/swe-resume`

Scoped bugs/features can still use `swe` directly without durable specs.

## Requirements

- [OpenCode](https://opencode.ai) **≥ 1.0** (tested against CLI `1.18.x` agent/skill formats)
- A model provider configured in OpenCode (`opencode providers`)

## Install

### Option A — Install the latest release into the current project

From the root of the project where OpenCode SWE should be installed:

```bash
curl -fsSL https://raw.githubusercontent.com/yourdudeken/opencodeSWE/main/install.sh | bash
```

To update an existing installation to the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/yourdudeken/opencodeSWE/main/update.sh | bash
```

The scripts download the latest GitHub release and copy only `opencode.jsonc`,
`AGENTS.md`, and `.opencode/` into the current directory. They do not remove or
modify any other project files. Existing copies of those three managed paths are
replaced on update.

### Option B — Use this repo as your project config

```bash
git clone <this-repo> my-swe-opencode
cd my-swe-opencode
# Copy the system onto an existing codebase:
cp -a opencode.jsonc AGENTS.md .opencode /path/to/your/project/
cd /path/to/your/project
opencode
```

Tab to `swe` or `swe-plan`, then work as usual. Mention specialists with `@debugger`, `@spec-writer`, etc.

### Option C — Global install (all projects)

```bash
cp -a .opencode/agents/* ~/.config/opencode/agents/
cp -a .opencode/skills/* ~/.config/opencode/skills/
cp -a .opencode/commands/* ~/.config/opencode/commands/
# Merge instructions into ~/.config/opencode/opencode.jsonc — see docs/INSTALL.md
```

### Option D — Drop-in `.opencode` only

If the target project already has `opencode.json`, copy `.opencode/` into the project root and set:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "swe",
  "instructions": [
    ".opencode/instructions/swe-protocol.md",
    ".opencode/instructions/delegation.md",
    ".opencode/instructions/verification.md",
    ".opencode/instructions/definition-of-done.md",
    ".opencode/instructions/risk-tiers.md",
    ".opencode/instructions/change-discipline.md",
    ".opencode/instructions/spec-plan-build.md",
    ".opencode/instructions/interrupt.md"
  ]
}
```

## Quick start

```bash
cd /path/to/your/codebase   # with this system installed
opencode

# Greenfield / large feature:
# Tab → swe-plan, or:
opencode run --agent swe-plan "Build a CLI todo app with SQLite — write specs first"

# After both approvals:
opencode run --agent swe "/swe-build implement the approved plans"
```

Useful slash commands inside the TUI:

- `/swe-spec <product prompt>` — specs → human gate → plans → human gate
- `/swe-plan <…>` — plans from approved specs
- `/swe-build` — implement from approvals
- `/swe-interrupt` / `/swe-resume` — stop and continue safely
- `/swe-fix`, `/swe-feature`, `/swe-refactor`, `/swe-deps`, `/swe-review`, `/swe-explore`, `/swe-ci`, `/swe-pr`

## Design principles

1. **Orchestrator owns the outcome** — specialists return evidence, not commandments.
2. **Do not over-delegate** — trivial tasks stay on `swe`.
3. **Risk-tiered ceremony** — T0 typo ≠ T4 migration; review depth scales with blast radius.
4. **Definition of Done blocks fake success** — no “done” without applicable gates.
5. **Human gates on durable specs/plans** — agents self-review; developers approve.
6. **Skills over prompt soup** — procedures are loadable, composable, and verification-oriented.
7. **Honest verification** — report commands actually run; never invent green builds.
8. **Minimal diffs** — match repo conventions; no speculative rewrites.
9. **Interruptible** — checkpoint PROGRESS; never fight a stop.

## Layout

```text
opencode.jsonc                 # default_agent, instructions, permissions, commands
AGENTS.md                      # ambient project rules for OpenCode
.opencode/
  agents/                      # swe, swe-plan + specialists
  skills/*/SKILL.md            # reusable operational skills
  instructions/                # protocols always loaded
  commands/                    # slash command templates
  workflows/                   # human-readable playbooks
docs/
  INSTALL.md
  ARCHITECTURE.md
  SWE-STANDARD.md
```

## Docs

- [SWE Standard (quality bar)](docs/SWE-STANDARD.md)
- [Installation details](docs/INSTALL.md)
- [Architecture & coordination](docs/ARCHITECTURE.md)

## License

MIT — adapt freely for your team.

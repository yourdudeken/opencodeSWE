# OpenCode SWE Multi-Agent System

A production-grade agent/skills architecture for [OpenCode](https://opencode.ai) that behaves like a senior software engineer with a small specialist team — not a pile of chatbot personas.

## What you get

| Layer | Contents |
|-------|----------|
| **Primary agent** | `swe` — orchestrates understand → inspect → plan → implement → verify → review |
| **Specialists** | 11 focused subagents (explore, plan, debug, test, review, architect, security, performance, git, deps, docs) |
| **Skills** | 14 operational skills with when/when-not, procedure, failure modes, verification |
| **Protocols** | Task state, delegation rules, verification hierarchy, specialist I/O contract |
| **Commands** | `/swe-fix`, `/swe-feature`, `/swe-review`, `/swe-explore`, `/swe-ci` |
| **Workflows** | Bug fix, feature, refactor, CI failure |

## Requirements

- [OpenCode](https://opencode.ai) **≥ 1.0** (tested against CLI `1.18.x` agent/skill formats)
- A model provider configured in OpenCode (`opencode providers`)

## Install

### Option A — Use this repo as your project config

```bash
git clone <this-repo> my-swe-opencode
cd my-swe-opencode
# Copy the system onto an existing codebase:
cp -a opencode.jsonc AGENTS.md .opencode /path/to/your/project/
cd /path/to/your/project
opencode
```

Tab to the `swe` agent (or rely on `default_agent`), then work as usual. Mention specialists with `@debugger`, `@code-reviewer`, etc.

### Option B — Global install (all projects)

```bash
cp -a .opencode/agents/* ~/.config/opencode/agents/
cp -a .opencode/skills/* ~/.config/opencode/skills/
cp -a .opencode/commands/* ~/.config/opencode/commands/
# Merge instructions into ~/.config/opencode/opencode.jsonc — see docs/INSTALL.md
```

### Option C — Drop-in `.opencode` only

If the target project already has `opencode.json`, copy `.opencode/` into the project root and set:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "swe",
  "instructions": [
    ".opencode/instructions/swe-protocol.md",
    ".opencode/instructions/delegation.md",
    ".opencode/instructions/verification.md"
  ]
}
```

## Quick start

```bash
cd /path/to/your/codebase   # with this system installed
opencode

# or one-shot:
opencode run --agent swe "Fix the failing auth unit tests and verify"
```

Useful slash commands inside the TUI:

- `/swe-fix <error or symptom>`
- `/swe-feature <request>`
- `/swe-review`
- `/swe-explore <area>`
- `/swe-ci <log excerpt>`

## Design principles

1. **Orchestrator owns the outcome** — specialists return evidence, not commandments.
2. **Do not over-delegate** — trivial tasks stay on `swe`.
3. **Skills over prompt soup** — procedures are loadable, composable, and verification-oriented.
4. **Honest verification** — report commands actually run; never invent green builds.
5. **Minimal diffs** — match repo conventions; no speculative rewrites.

## Layout

```text
opencode.jsonc                 # default_agent, instructions, permissions, commands
AGENTS.md                      # ambient project rules for OpenCode
.opencode/
  agents/                      # swe + specialists (markdown agents)
  skills/*/SKILL.md            # reusable operational skills
  instructions/                # protocols always loaded
  commands/                    # slash command templates
  workflows/                   # human-readable playbooks
docs/
  INSTALL.md
  ARCHITECTURE.md
```

## Docs

- [Installation details](docs/INSTALL.md)
- [Architecture & coordination](docs/ARCHITECTURE.md)

## License

MIT — adapt freely for your team.

# Installation

## Prerequisites

1. Install OpenCode: https://opencode.ai/docs/
2. Configure a provider: `opencode providers`
3. Confirm CLI works: `opencode --version` (this pack targets the markdown agent + `SKILL.md` format used by current OpenCode releases)

## Project install (recommended)

From this repository:

```bash
TARGET=/path/to/your/application

cp opencode.jsonc "$TARGET/"
cp AGENTS.md "$TARGET/"
cp -a .opencode "$TARGET/"
```

If `$TARGET` already has `opencode.json` / `opencode.jsonc`, **merge** rather than overwrite:

- Set `"default_agent": "swe"`
- Append all `.opencode/instructions/*.md` paths to `instructions` (protocol, delegation, verification, definition-of-done, risk-tiers, change-discipline)
- Keep any existing provider/model settings

Then:

```bash
cd "$TARGET"
opencode agent list    # should show swe + specialists
opencode
```

## Global install

```bash
mkdir -p ~/.config/opencode/{agents,skills,commands}

cp .opencode/agents/*.md ~/.config/opencode/agents/
cp -a .opencode/skills/* ~/.config/opencode/skills/
cp .opencode/commands/*.md ~/.config/opencode/commands/
```

Add to `~/.config/opencode/opencode.jsonc`:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "swe",
  "instructions": [
    // Use absolute paths or copy instructions into ~/.config/opencode/instructions/
    "/absolute/path/to/opencodeSWE/.opencode/instructions/swe-protocol.md",
    "/absolute/path/to/opencodeSWE/.opencode/instructions/delegation.md",
    "/absolute/path/to/opencodeSWE/.opencode/instructions/verification.md"
  ]
}
```

Prefer copying `instructions/` into `~/.config/opencode/instructions/` so paths stay stable.

## Verify discovery

```bash
opencode agent list
```

You should see primary `swe` and subagents such as `debugger`, `code-reviewer`, `repo-explorer`, etc.

In a session, skills appear via the `skill` tool (`repository-mapping`, `verification-loop`, …). Slash commands appear as `/swe-fix`, `/swe-feature`, …

## Using alongside built-in agents

| Goal | Agent |
|------|-------|
| SWE delivery (default) | `swe` |
| Stock OpenCode builder | `build` (Tab to switch) |
| Stock read-only plan | `plan` |
| Quick stock explore | built-in `explore` or `@repo-explorer` |

## Model tips

Pin stronger models on `swe`, `debugger`, and `code-reviewer` if desired — in each agent markdown frontmatter:

```yaml
model: anthropic/claude-sonnet-4-20250514
```

Or override in `opencode.jsonc` under `agent.<name>.model`.

## Uninstall

Remove the copied `.opencode/agents/swe.md` (and other agents you added), skills, commands, and revert `default_agent`.

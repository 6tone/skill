# 🏛️ Universal AI Skill Pack — Claude Code + Antigravity

> **Design Principle**: Project-agnostic. The pack is never edited inside a project; each project declares its own facts in its root `AGENTS.md`.
> **Format**: Every skill is a folder with a `SKILL.md` (YAML frontmatter `name` + `description`), following the [Agent Skills](https://agentskills.io) standard. Both Claude Code and Antigravity load skills on demand from their descriptions.

---

## 📐 How It Fits Together

| Layer | Lives in | Loaded | Owner |
|:---|:---|:---|:---|
| Always-on rules (project context, trust boundary, hard rules) | Project root `AGENTS.md` | Every turn | Project (from `templates/AGENTS.md`) |
| Claude Code entry | Project root `CLAUDE.md` = `@AGENTS.md` | Every turn | Project |
| Skills (workflows, standards) | `.claude/skills/<name>/` and `.agents/skills/<name>/` | On demand | **Pack** (copied by install) |
| Glossary | `docs/glossary.md` | When an agent meets an unknown term | Project |
| Hard enforcement (Claude Code) | `.claude/settings.json` permissions | Always | Project (from `templates/claude-settings.json`) |

### What each tool reads

| | Claude Code | Antigravity |
|:---|:---|:---|
| Entry file | `CLAUDE.md` (imports `AGENTS.md`) | `AGENTS.md` |
| Skills | `.claude/skills/<name>/SKILL.md` | `.agents/skills/<name>/SKILL.md` |
| Hard enforcement | `.claude/settings.json` deny/ask rules | Terminal command allow/deny settings in the IDE |

- Claude Code reads `AGENTS.md` directly only when **no** `CLAUDE.md` / `CLAUDE.local.md` exists in the working directory or above it. The one-line `CLAUDE.md` makes loading reliable either way.
- Claude Code never reads anything under `.agents/`, and Antigravity never reads `.claude/`. That is why skills are installed twice.
- Antigravity truncates any rule file over **24KB**, and Claude Code adherence drops past ~200 lines. Keep `AGENTS.md` short; move task-specific material into skills.
- Rules written in Markdown are requests, not guarantees. Put anything that must never happen into `.claude/settings.json` (Claude Code) and the Antigravity terminal policy.

---

## 🚀 Install / Upgrade

Keep this pack anywhere (e.g. `~/ai-skill-pack`), then run from the project root:

```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File C:\path\to\ai-skill-pack\install.ps1 -Target .
```

```bash
# macOS / Linux / Git Bash
bash ~/ai-skill-pack/install.sh .
```

- **Skills** are replaced on every run → re-run to upgrade after changing the pack.
- **Project files** (`AGENTS.md`, `CLAUDE.md`, `docs/glossary.md`, `.claude/settings.json`) are created only if missing and never overwritten.
- A skill deleted from the pack is **not** removed from projects; delete it there by hand.
- Changes to skills are made and committed **in this pack's repo only**, never in a project.

### Keeping the pack out of the project's version control

Add this to the project's `.gitignore` so skill history stays in the pack's own repo:

```gitignore
.ai/              # the pack itself, if cloned inside the project
.claude/skills/   # installed copies
.agents/
```

Each clone of the project then needs one install run to get the skills back.
`AGENTS.md`, `CLAUDE.md`, `docs/glossary.md` and `.claude/settings.json` hold project-specific content: commit them with the project, or ignore them too if the project should carry no agent files at all.

After the first install, fill in every `[...]` placeholder in `AGENTS.md` and `docs/glossary.md`.

---

## 📑 Skill Index

### 🔴 Governance

| Skill | Core Responsibility |
|:---|:---|
| `architecture` | Directory Rules, SoC, DB/No-DB Branches |
| `coding-standards` | Layered Architecture, SRP, Naming, Error Handling |
| `security-guidelines` | Data Masking, Secrets Management, CORS, Rate Limiting |
| `danger-zone` | Prohibited Terminal / Git / DB Operations |
| `logging` | Log Levels, Structured JSON, PII Masking, Error Code Design |

The trust boundary, approval keywords and working style (formerly `sop.md`) are always-on and live in `templates/AGENTS.md`.

### 🟡 Workflows

| Skill | Core Responsibility |
|:---|:---|
| `git-commit` | Commitizen Format, Confirmation Flow, Anti-automation |
| `create-pull-request` | Branch Push, PR Title/Body Generation, Confirmation Flow |
| `testing` | Decision Tree, Test Execution, Debug Workflows, Coverage |
| `ci-fix` | CI Log Diagnosis, Test/Lint/Build/Env Fixes |
| `web-performance-audit` | Lighthouse / CWV Audit, Bundle Analysis, Fix Patterns |

There is no routing index anymore: both tools show agents each skill's `description` and load the full `SKILL.md` when a task matches. A skill's `description` is therefore its trigger — keep it specific.

---

## 🗂️ Pack Layout

```
ai-skill-pack/
├── README.md
├── install.ps1 / install.sh
├── skills/
│   └── <skill-name>/SKILL.md     ← name in frontmatter must match the folder name
└── templates/
    ├── AGENTS.md                 ← always-on rules + Project Context placeholders
    ├── CLAUDE.md                 ← "@AGENTS.md"
    ├── glossary.md               ← installed to docs/glossary.md
    └── claude-settings.json      ← installed to .claude/settings.json
```

---

## 🔁 Version History

| Version | Date | Description |
|:---|:---|:---|
| v1.0 | [YYYY-MM-DD] | Initial release |
| v1.1 | [YYYY-MM-DD] | Added YAML frontmatter to all skills; upgraded testing.md; added create-pull-request, ci-fix, web-performance-audit |
| v1.2 | [YYYY-MM-DD] | Bug fixes across skill files; added React Hooks rules to coding.md; added logging.md |
| v1.3 | [YYYY-MM-DD] | Optimization & Cleanup: removed cross-file duplication; consolidated DRY rules; stateless compatibility improvements |
| v1.4 | [YYYY-MM-DD] | Quality fixes: generic examples throughout; glossary.template.md added; routing table synced |
| v2.0 | 2026-10-16 | Restructured for Claude Code + Antigravity: skills moved to `skills/<name>/SKILL.md`; `sop.md` and `.cursorrules` merged into `templates/AGENTS.md`; INDEX routing replaced by native skill discovery; project placeholders moved to `AGENTS.md`; added install scripts and Claude Code permission template |

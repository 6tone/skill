# [PROJECT_NAME] — Agent Instructions

> Loaded on every turn by Antigravity (natively) and Claude Code (through `CLAUDE.md` → `@AGENTS.md`).
> Keep this file short (target < 150 lines, hard limit 24KB): anything needed only for some tasks belongs in a skill.
> This file is owned by the project. Re-running the skill pack's install never overwrites it.

---

## 1. Project Context

| Key | Value |
|:---|:---|
| Project | [PROJECT_NAME] |
| Role | [e.g., Fullstack App / BFF Proxy / Game Provider] |
| Frontend | [e.g., Vue 3 SPA / React / None] |
| Backend | [e.g., Node.js + Express 5 + TypeScript] |
| `HAS_DATABASE` | [true / false] |
| `DB_TYPE` | [PostgreSQL / MongoDB / Redis / None] |
| ORM / Driver | [e.g., Drizzle / Mongoose / None] |
| Util directory | [e.g., `src/lib/helpers`] |
| Test runner | [e.g., Vitest / Jest] |
| Logger | [e.g., Pino / Winston] |
| Package manager | [npm / pnpm] |
| Glossary | `docs/glossary.md` |

### Commands

```bash
[install]     # e.g. npm install
[dev]         # e.g. npm run dev
[test]        # e.g. npm test
[typecheck]   # e.g. npm run typecheck
[lint]        # e.g. npm run lint
```

### Directory Map

```
[Replace with the project's actual tree. Reference layout: the `architecture` skill, Section 7.]
```

---

## 2. Project-Specific Rules

[Domain rules every task must respect, e.g. time zone, money representation, invariants. Delete this placeholder when filled.]

---

## 3. Trust Boundary (Always On)

| Zone | Covers | Obligation |
|:---|:---|:---|
| 🔴 Red | Architecture changes (new top-level dirs, framework changes), DB schema changes, package install/remove, destructive commands, `.env` / docker / CI config changes | Propose the plan, then **wait for explicit approval** before acting |
| 🟡 Yellow | Business logic (`services/`, `routes/`), API endpoints, DB query logic | Proceed, then present a change summary with key diffs before moving on |
| 🟢 Green | UI/CSS, typos, non-side-effect logs, docs and comments | Proceed, report in one sentence |

- **Approval keywords** — Chinese: 同意, 施作, 開始, 動工, 好, 確認, 執行, 可以, 照做, 去做. English: OK, Approved, Yes, go, go ahead, proceed, do it, run it, execute, let's do it.
- Vague replies ("sounds good", "maybe", "let me think", "in discussion") are **not** approval.
- Approval is task-scoped; it never carries over to the next task.
- **Where to put a plan**: Antigravity → an Implementation Plan artifact; Claude Code → plan mode, or a short plan in chat. Small tasks the user already specified need only a brief plan in chat.

---

## 4. Hard Rules (No Exceptions)

1. **No autonomous git writes**: never `git add`, `git commit`, `git push` without an explicit user instruction. Never `git add .` / `git add -A`, `git push --force`, `git reset --hard`, `git branch -D`.
2. **No autonomous package management**: never `npm install` / `uninstall` / `update` without approval.
3. **No secrets in code**: keys, passwords and secret URLs come from `.env`; keep `.env.example` with blank values.
4. **Never modify or delete** `.git/`, `.env`, `.vscode/`. No `rm -rf` / `Remove-Item -Recurse -Force` outside `node_modules` without listing targets and getting confirmation.
5. **No production access** from the terminal: no direct production DB writes, no requests to production APIs, no `curl | bash`.
6. **No new top-level directories** without approval.

Details and command tables: the `danger-zone` skill.

---

## 5. Working Style

- **Language**: match the user's language (Traditional Chinese if the user writes in Chinese).
- **Conciseness**: no pleasantries, flattery or unnecessary apologies. Conclusions and actions first.
- **Do not guess**: for vague instructions, offer 2–3 implementation paths and let the user choose. Point out contradictions in a requirement instead of implementing them.
- **Workspace cleanliness**: delete temporary scripts, dumps and scratch files as soon as they are no longer needed.
- **Context management**: after finishing an independent feature module, suggest starting a new chat. On major completion, record changed files and key decisions (Antigravity → Walkthrough artifact; Claude Code → a summary in chat, or `docs/` when the decision should persist).

---

## 6. Skills (Load on Demand)

Installed into `.claude/skills/` (Claude Code) and `.agents/skills/` (Antigravity) from the shared skill pack.
**Do not edit them in this project**: change the pack and re-run its install script.

| Skill | Use when |
|:---|:---|
| `architecture` | Adding files/directories, designing layers, `lib/` vs `services/`, DB vs stateless branches |
| `coding-standards` | Writing or refactoring code, naming, error handling, async patterns |
| `security-guidelines` | Auth, tokens, CORS, sensitive data, rate limiting, new third-party packages |
| `logging` | Adding logs, error codes, PII masking, logger setup |
| `danger-zone` | About to run package, file-deletion, git or database commands |
| `testing` | Writing, running or debugging tests; coverage |
| `git-commit` | The user asks to commit / save progress |
| `create-pull-request` | The user asks to push or open a PR |
| `ci-fix` | A CI pipeline is failing |
| `web-performance-audit` | Page speed, Lighthouse, bundle size |

Unfamiliar domain term or naming a new concept → read `docs/glossary.md` first.

# 🏛️ Universal AI Skill Set — Common Guidelines Template

> **Design Principle**: Project-Agnostic, using `[PLACEHOLDER]` tags for project-specific customization.
> **Usage**:
> 1. Copy the entire skill directory into your new project's `.ai/` directory.
> 2. Copy `.cursorrules-template` to your project root as `.cursorrules`.
> 3. Search for all `[...]` placeholders across all files and fill in your project's actual details.
> **Format**: All skills follow the [Agent Skills](https://agentskills.io) open standard with YAML frontmatter for auto-discovery.

---

## 📑 Skill Index

### 🔴 Behavior Governance Skills (AI What-Not-To-Do)

| No. | File | Name | Core Responsibility |
|:---:|:---|:---|:---|
| 1 | `sop.md` | `ai-sop` | Trust Boundary, Authorization Flow, AI Persona |
| 2 | `architecture.md` | `architecture` | Directory Rules, SoC, DB/No-DB Branches |
| 3 | `coding.md` | `coding-standards` | Layered Architecture, SRP, Naming, Error Handling |
| 4 | `security.md` | `security-guidelines` | Data Masking, Secrets Management, CORS, Rate Limiting |
| 5 | `danger-zone.md` | `danger-zone` | Prohibited Terminal / Git / DB Operations |
| 6 | `logging.md` | `logging` | Log Levels, Structured JSON, PII Masking, Error Code Design |
| 7 | `glossary.template.md` | `glossary` | Domain Terms, Status Codes, Abbreviations, Disambiguation |

### 🟡 Workflow Skills (AI How-To Execution Handbooks)

| No. | File | Name | Core Responsibility |
|:---:|:---|:---|:---|
| 8  | `git-commit.md` | `git-commit` | Commitizen Format, Confirmation Flow, Anti-automation |
| 9  | `create-pull-request.md` | `create-pull-request` | Branch Push, PR Title/Body Generation, Confirmation Flow |
| 10 | `testing.md` | `testing` | Decision Tree, Test Execution, Debug Workflows, Coverage |
| 11 | `ci-fix.md` | `ci-fix` | CI Log Diagnosis, Test/Lint/Build/Env Fixes |
| 12 | `web-performance-audit.md` | `web-performance-audit` | Lighthouse / CWV Audit, Bundle Analysis, Fix Patterns |

---

## 🔀 Task Routing Table

| Task Type | Required Skill Files |
|:---|:---|
| Add / Modify API or Service | `sop.md` + `coding.md` + `architecture.md` |
| Refactor / Modify Directory Structure | `sop.md` + `architecture.md` |
| Security / Auth / CORS Related | `security.md` + `architecture.md` |
| Write or Modify Tests | `testing.md` + `coding.md` |
| Frontend UI / Component Modification | `coding.md` + `architecture.md` |
| Package Installation / Environment Settings | `sop.md` + `danger-zone.md` (Red Zone) |
| Adding Logs / Error Codes / PII Handling | `logging.md` + `security.md` |
| Git Commit / Version Control | `git-commit.md` |
| Push to Remote + Open PR / MR | `create-pull-request.md` + `git-commit.md` |
| CI Pipeline Failure | `ci-fix.md` |
| Page Load Performance | `web-performance-audit.md` |

---

## 📌 Required Project Placeholders

| Placeholder | Description |
|:---|:---|
| `[PROJECT_NAME]` | Project name (e.g., `MyApp`) |
| `[TECH_STACK]` | Core technology stack (e.g., `Node.js + PostgreSQL + React`) |
| `[PROJECT_UTIL_DIR]` | Directory for utility functions (e.g., `lib/helpers`) |
| `[HAS_DATABASE]` | `true` / `false`, determines the database rules in `architecture.md` |
| `[DB_TYPE]` | Type of database (e.g., `MongoDB` / `PostgreSQL` / `Redis` / `None`) |
| `[GLOSSARY]` | Project terminology glossary (recommended to create a `glossary.md`) |

---

## 🔁 Version History

| Version | Date | Description |
|:---|:---|:---|
| v1.0 | [YYYY-MM-DD] | Initial release |
| v1.1 | [YYYY-MM-DD] | Added YAML frontmatter to all skills; upgraded testing.md; added create-pull-request, ci-fix, web-performance-audit |
| v1.2 | [YYYY-MM-DD] | Bug fixes across skill files; added React Hooks rules to coding.md; added logging.md |
| v1.3 | [YYYY-MM-DD] | Optimization & Cleanup: removed cross-file duplication; consolidated DRY rules; stateless compatibility improvements |
| v1.4 | [YYYY-MM-DD] | Quality fixes: generic examples throughout; glossary.template.md added; routing table synced |

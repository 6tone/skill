---
name: architecture
description: Enforce directory structure discipline, Separation of Concerns, and layered architecture rules. Use when adding new files or directories, designing service layers, evaluating whether a utility belongs in lib/ vs services/, or branching logic for DB-enabled vs stateless proxy projects.
---

# Architecture — Directory & Architecture Discipline

This document enforces Separation of Concerns (SoC) and directory discipline for all projects.

---

## 1. System Architecture Declaration (Required for Each Project)

Each project declares its architecture parameters in the **Project Context** section of its root `AGENTS.md` (Frontend, Backend, `HAS_DATABASE`, `DB_TYPE`, Role, util directory). Read them there to determine which rules and branches below are active.

If `AGENTS.md` has no Project Context or it still contains `[...]` placeholders, ask the user to fill it in before applying the branch-specific rules.

---

## 2. General Layered Architecture

Please refer to the `coding-standards` skill, Section 1, for the detailed layered architecture responsibilities and strict prohibitions.
All projects must strictly follow the `Request → Controller/Route → Service → [Repository/Model → DB]` flow.

---

## 3. 🔀 Database Architecture Branches

Different rules apply based on the project's `HAS_DATABASE` value (declared in `AGENTS.md`):

---

### 3-A. Database-Enabled (HAS_DATABASE = true)

#### 3-A-1. Purity of the `lib/` Directory
- Files inside the `lib/` directory MUST BE 100% generic utility functions or drivers (e.g., Redis client, AES encryptor).
- **Strictly Prohibited**: Importing any `models/` or `services/` inside `lib/`.
- **Strictly Prohibited**: Writing any domain-specific business logic in `lib/`.

#### 3-A-2. Schema Design Discipline
- When creating a new schema/model by copying an existing one, review every constraint (e.g., `required: true`) individually.
- **Do not blindly copy-paste** schemas to prevent missing required fields that cause database write crashes.

#### 3-A-3. Schema Error Handling (Development Phase)
If a schema configuration error causes subsequent write failures during development or testing:
- The AI **must prioritize proposing "Drop the collection/table and recreate it"**.
- **Strictly Prohibited**: Autonomously writing complex migration scripts or data-patching loops to fix schema errors during the development phase. Keep the database clean.

---

### 3-B. Database-Free (HAS_DATABASE = false) — Stateless Proxy Mode

Applicable to BFF (Backend For Frontend) or API Proxy projects.

#### 3-B-1. Core Constraints

| Prohibited Operation | Description |
|:---|:---|
| Importing SQL/NoSQL DB clients | The system must not persist data locally. |
| Generating JWTs (on backend) | Tokens come from the target API and must be passed through. |
| Creating Server-Side Sessions | Fully stateless; no server session storage (e.g., Redis). |

- **Allowed**: Limited in-memory caching for high-frequency, non-sensitive read APIs. Do not store user-sensitive data across requests.

#### 3-B-2. Token & State Management
- Authentication tokens should preferably be stored in **HttpOnly cookies** (resistant to XSS attacks). Use **`localStorage`** only when cookie-based auth is not feasible (e.g., strict cross-domain scenarios with no cookie support).
- The frontend Axios interceptor injects the `Authorization: Bearer <token>` header.
- The backend proxy **forwards requests verbatim** without modifying token payloads.

#### 3-B-3. Backend Restart Detection (Session Exclusivity)
- The backend generates a unique `X-Server-Id` (UUID) upon startup and attaches it to all HTTP responses.
- The frontend Axios interceptor monitors the `X-Server-Id` header.
- On `X-Server-Id` mismatch or `401 Unauthorized`:
  1. Clear the frontend `localStorage` tokens and user data.
  2. Force a `window.location.reload()` to redirect to the login page.

---

## 4. DRY Principle (General)

**Before writing any utility function**, the AI **must check the util directory declared in `AGENTS.md`** and existing helpers in `lib/` first:
- If a matching utility exists: Reuse it via import. Duplication is strictly prohibited.
- If it does not exist: You may create it in the appropriate utilities directory.

Common helpers that must not be duplicated:
- Time formatting (`getISOTime`, `getMidNight`)
- Async flow control (`asyncForEach`, `sleep`)
- Encryption (`aesEncrypt`)
- Database type check (`typeCheck`)

---

## 5. Directory Structure Soft Freeze

- AI **must not autonomously create new top-level directories**.
- If a new folder is necessary, propose it in the implementation plan and **wait for user approval** before creation.

---

## 6. Path Conventions

- Use relative paths (`../`, `./`).
- **Strictly Prohibited**: Hardcoding absolute system paths.
- Frontend and backend codebases must be strictly isolated. Frontend must not import backend modules, and vice versa.

---

## 7. Directory Map

> 📌 The project's **actual** directory tree lives in the **Directory Map** section of its root `AGENTS.md`. That map is authoritative for all AI file operations and SoC enforcement. The tree below is only the reference layout it is derived from.

```
project-root/
├── src/                         ← (or remove if flat structure)
│   ├── routes/                  ← Controllers / HTTP entry points
│   ├── services/                ← Business logic layer
│   ├── models/                  ← DB schemas / ODM models  (HAS_DATABASE = true only)
│   ├── repositories/            ← DB query encapsulation   (HAS_DATABASE = true only)
│   └── middleware/              ← Auth, error handler, rate limit
├── lib/                         ← Generic utilities & drivers (no domain logic)
│   └── helpers/                 ← Util directory (name declared in AGENTS.md)
├── tests/
│   └── integration/             ← Supertest-based API tests
├── .env                         ← Local only; never commit
├── .env.example                 ← Committed template with blank values
└── package.json
```

**Instructions** (apply to the map in `AGENTS.md`, not to this skill):
1. Delete unused layers (e.g., remove `models/` and `repositories/` if `HAS_DATABASE = false`).
2. Add project-specific folders that don't fit the reference layout.
3. Keep the map updated whenever a new top-level directory is approved and created.

# ACCESS.md — Requesting access to the private core

The private repository (`ajdhoward-xaas-ecosystem-core`) holds the research compendium, decision matrices, architecture maps, simulations and deployment payloads. **Access is granted case-by-case by the owner, [@ajdhoward](https://github.com/ajdhoward).** There is no open enrollment — this file exists so requests are fast and consistent.

## Who can request

- **Humans** collaborating on the ecosystem (developers, designers, accessibility reviewers, community partners).
- **AI agents** acting on behalf of a collaborator. An agent's access is always sponsored by a human: the sponsor is accountable for the agent's work.

## How to request (pick one)

1. **Issue (preferred):** open an issue in this repository using the **"Access Request"** template. Fill in who you are, your sponsor (if you're an agent), and what you intend to work on.
2. **GitHub:** mention `@ajdhoward` in any public discussion with the same details.

## What happens next

1. The owner reviews the request (expect a personal decision — allow/deny/scope-limited).
2. If approved, you receive **exactly one** of:
   - a **GitHub collaborator/team invite** to the private core (humans), or
   - an **issued deployment credential** (`XAAS_ACCESS_TOKEN`) for `bootstrap.sh` (agents/automation) — scoped, revocable, and never to be committed anywhere.
3. Approved collaborators read the core's `PROGRESS.md` and `CONVENTIONS.md` first — they define the checkpoint & approve workflow everyone (human or AI) must follow.

## Ground rules for everyone with access

- Secrets never appear in the public repo, in issues, or in chat logs. If a credential is ever exposed, it is treated as burned and rotated immediately.
- The public repo stays strategy-free: simple description, access flow, bootstrap entry point.
- All substantive changes go through the checkpoint & approve loop recorded in the core's `PROGRESS.md`.
- Authorization is revocable at any time, for any reason, by the owner.

## Security note on `bootstrap.sh`

The bootstrap **fails closed**: without a valid credential it exits without touching anything. It never embeds secrets, never escalates privileges, and only ever pulls the private core over authenticated HTTPS/SSH after your credential is verified. Full threat model and gate design are documented in the private core (`docs/decisions/`).

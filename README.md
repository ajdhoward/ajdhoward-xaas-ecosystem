# XaaS Ecosystem

**Simple version:** we knit popular, trusted open-source software together into ready-to-deploy micro-SaaS solutions ("Ideas as a Service"). Each piece works on its own; together they form one platform. Everything is designed to be cheap to run, light to maintain, and — by design — usable by people with cognitive disabilities (ADHD, dyslexia, processing differences) and the communities most tools forget.

## How this repository works (the conduit model)

This **public** repo is the front door. It contains:

| What | Where |
|------|-------|
| This simple description | `README.md` |
| How to request access to the private build repo | [`ACCESS.md`](ACCESS.md) |
| One-command deployment entry point | [`bootstrap.sh`](bootstrap.sh) |

The actual research, architecture, configurations and deployment payloads live in a **private** companion repository (`…-core`). Access to it is granted personally by the project owner — **@ajdhoward controls who is authorized** (humans and AI agents alike).

Once you are authorized, deployment is a single command:

```bash
./bootstrap.sh
```

The bootstrap verifies your authorization, pulls the private core, and executes the full deployment. No authorization → it safely does nothing and points you to [ACCESS.md](ACCESS.md).

## For AI agents working with us

Handed this repo by @ajdhoward? Good — you have everything you need to *start*:
1. Read [`ACCESS.md`](ACCESS.md) and request authorization (the owner issues agent credentials).
2. Never commit secrets here; this repo is public by design and stays strategy-free.
3. All working conventions (checkpoint & approve loop, progress logging) live in the private core once you're in.

## Status

🟢 **Active build** — the private core now contains the completed research compendium (15 vertical OSS audits against a 158-repo evidence snapshot), the adopted architecture (Optimum Journey + 3 pivot paths), end-to-end simulations, and a working deployment payload v1 (platform spine + first tenant bundle). Authorized holders can deploy via `bootstrap.sh`. This public repo is licensed MIT (see `LICENSE`).

## Contact / access

→ **[ACCESS.md](ACCESS.md)** — or open an **Access Request** issue using the template in this repo.

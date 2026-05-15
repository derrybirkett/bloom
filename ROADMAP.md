# Bloom Roadmap

The Bloom framework is designed as a zero-friction, agent-first product incubator. Our mission is to compress the time between "I have an idea" and a fully deployed, high-quality product, while forcing structural and architectural discipline from day one.

This roadmap outlines the strategic priorities for the next iterations of the Bloom framework.

---

## Phase 1: Zero-to-Deployed Infrastructure Automation

Currently, `bloom-init` rapidly scaffolds local code, but the developer must manually provision cloud infrastructure. Our immediate priority is closing this loop to achieve true one-command deployment.

**Goals:**
- Eliminate manual cloud provisioning for new products.
- Ensure environments are secure, predictable, and instantly available to AI agents.

**Key Features:**
- **`bloom-infra` script:** A new CLI addition that leverages the Vercel CLI and Supabase CLI.
- **Automated Provisioning:** Automatically create a Supabase database and Vercel project upon initialization.
- **Environment Injection:** Securely extract the generated API keys and inject them directly into the product's `.env` and Vercel environment variables.

---

## Phase 2: Continuous Agentic Enforcement (CI/CD)

Bloom relies heavily on the `shulkerbox` to provide AI agents with a "soul" and design guidelines locally. We need to enforce these standards automatically in the cloud to prevent human drift or unauthorized deviations from the design system.

**Goals:**
- Protect the codebase and design system automatically during code review.
- Embed AI agents natively into the continuous integration pipeline.

**Key Features:**
- **Agentic GitHub Actions:** A pre-configured GitHub Action workflow included in both the `lite` and `full` templates.
- **Automated PR Reviews:** Upon any Pull Request, an AI Agent is spun up to review the incoming code against the product's specific `soul.yaml` and the organizational `DESIGN.md`.
- **Merge Blocking:** The agent acts as a gatekeeper, automatically blocking the merge of any code that violates the minimalist, high-contrast ethos of the framework.

---

## Phase 3: Data Migration Standards & Tooling

While `stack.yaml` clearly mandates Supabase and Postgres, the framework currently lacks a strict standard on how data schemas should be modeled, versioned, and migrated over time. Leaving this undefined leads to database chaos as products scale.

**Goals:**
- Formalize a strict ORM and migration strategy across all Bloom products.
- Prevent schema drift and ensure safe, repeatable deployments.

**Key Features:**
- **ORM Standardization:** Update `stack.yaml` to define a single standard ORM (e.g., Drizzle or Prisma) for type-safe database interactions.
- **Migration Workflows:** Bake standardized migration scripts (`pnpm db:generate`, `pnpm db:push`) directly into the templates.
- **Automated Seed Data:** Provide an out-of-the-box seeding strategy for fast local agent testing.

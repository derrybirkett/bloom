# Bloom

A composable system for discovering, defining, designing, and delivering digital products.

Bloom is not a framework or a monorepo. It is an umbrella over five independent repos, each consumable on its own. Pull in only what you need; compound value over time.

## The Five Repos

| Repo | Role | Verb |
|---|---|---|
| [soul](https://github.com/derrybirkett/soul) | Philosophy, values, design ethos, voice, methodology, accumulated wisdom | Believe |
| [idea](https://github.com/derrybirkett/idea) | Per-product discovery and definition templates | Define |
| [stack](https://github.com/derrybirkett/stack) | Tech defaults, configs, working starters | Build |
| [shulkerbox](https://github.com/derrybirkett/shulkerbox) | Skills, hooks, scripts, operator agents, subagents | Do |
| [council](https://github.com/derrybirkett/council) | Business advisors, governance, escalation | Judge |

## How They Compose Into a Product

```
target-product/
  .bloom/
    soul/         (submodule)
    idea/         (submodule, often used once at start)
    stack/        (submodule)
    shulkerbox/   (submodule)
    council/      (submodule)
  notes/          (per-product, scaffolded from shulkerbox templates)
  src/
  ...
```

Standard mount point: `.bloom/`. Each repo is a git submodule. None is required — pull in only what you need. A product can consume a single piece (e.g. `shulkerbox` only) and still benefit.

## The Loop

```
                       soul
                  why we build,
                 how we work, who
                we have learned to be
                        |
        +---------------+----------------+
        |               |                |
      idea          shulkerbox        council
   define what       do the work    judge the work
        |               |                |
        +---------------+----------------+
                        |
                      stack
                  build with these
                     defaults
```

Read soul first. Use idea to define. Use stack and shulkerbox to deliver. Use council to review and escalate. Insights from council loop back into soul.

## Role Boundaries

Single source of truth per concern. If content cannot be placed in exactly one row of this table, the design is wrong and needs sharpening before adding the content.

| Concern | Lives in |
|---|---|
| Values, ethos, voice, methodology | soul |
| Per-product discovery and definition (mission, IA, spec) | idea |
| Tech defaults, configs, working starters | stack |
| Skills, hooks, operator agents, subagents | shulkerbox |
| Business advisors, governance, escalation | council |
| Cross-product insights and decisions | soul |
| Per-product notes, friction, weekly reviews | target product `notes/` |

## Quick Start

```bash
# Clone the hub
git clone https://github.com/derrybirkett/bloom ~/Projects/bloom
cd ~/Projects/bloom

# Initialise a new product
./bloom-init my-new-product

# Or pull a single piece into an existing repo
cd existing-product
git submodule add https://github.com/derrybirkett/shulkerbox .bloom/shulkerbox
```

## Versioning

Each repo tags `vX.Y.Z` semver. The hub's [versions.yaml](versions.yaml) declares known-good combinations. A target product can pin its `.bloom/` submodules to a published bloom version for reproducibility.

## Principles

- Content over CLIs. The compounding asset is markdown and yaml. Tools age, content does not.
- Single source of truth per concern.
- No cross-repo runtime coupling. Each repo runs standalone.
- Working starter from day one — never aspirational.
- Prune by default. Anything unused in 30 days is a candidate for removal.
- No metaphors in repo names. Direct words: soul, idea, stack, shulkerbox, council.
- No commits on `main`. Branch, PR, squash-merge. Enforced via git hook (see stack/configs).

## What Bloom Replaces

Bloom supersedes an earlier set of overlapping repos: `pip`, `hatch`, `seed`, `prefs`. Their useful content has been redistributed; their containers retired. See each retired repo's `TOMBSTONE.md` for the redirect map.

## License

MIT

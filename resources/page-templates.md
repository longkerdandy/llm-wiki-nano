# Page templates

Templates are starting points, not straitjackets. Every page begins with YAML
frontmatter and ends with a provenance section. Wikilinks use the
`[[page-name]]` convention (Obsidian-compatible).

---

## Source page — `pages/sources/<slug>.md`

One per ingested source. Faithful compression, no commentary.

```markdown
---
kind: source
title: <original title>
origin: <raw/ path or URL>
ingested: YYYY-MM-DD
---

# <title>

## Summary
<5–10 lines: what this source says, in its own terms>

## Key claims
- <claim 1> — <section/anchor in raw>
- <claim 2> — <section/anchor in raw>

## Concepts and entities
- [[concept-a]] — <how this source relates to it>
- [[entity-b]] — <how this source relates to it>

## Open questions
- <anything the source leaves unresolved>
```

---

## Concept page — `pages/concepts/<slug>.md`

The heart of the wiki. Tracks how a concept is defined and used
**across sources**, including divergent definitions.

```markdown
---
kind: concept
updated: YYYY-MM-DD
sources: N
---

# <concept>

## Definition(s)
- As used by [[source-x]]: <definition> — <anchor>
- As used by [[source-y]]: <definition> — <anchor>
<If definitions diverge, keep both. Divergence is signal, not noise.>

## Where it appears
| Source | Role | Anchor |
|--------|------|--------|
| [[source-x]] | <e.g. core mechanism> | <anchor> |

## Related concepts
- [[concept-c]] — <relationship>

## Tensions
<Contradictions or open disagreements touching this concept, each with
anchors to both sides. Empty section = none known.>
```

---

## Entity page — `pages/entities/<slug>.md`

For people, systems, products, standards, organizations.

```markdown
---
kind: entity
updated: YYYY-MM-DD
---

# <entity>

## What it is
<2–5 lines, anchored>

## Facts
- <fact> — [[source-x]], <anchor>

## Related
- [[concept-a]], [[entity-c]]
```

---

## Synthesis page — `pages/syntheses/<slug>.md`

Comparisons, contradiction registers, evolving theses. Filed from Query
answers or human requests. This is where the wiki compounds.

```markdown
---
kind: synthesis
updated: YYYY-MM-DD
status: draft | stable
---

# <question or thesis>

## Synthesis
<the current best answer, woven from multiple sources>

## Evidence
| Claim | Supporting | Conflicting |
|-------|-----------|-------------|
| <claim> | [[source-x]] <anchor> | [[source-y]] <anchor> |

## Unresolved
<what cannot yet be decided, and what source would settle it>
```

---
name: llm-wiki-nano
description: Build and maintain a persistent, LLM-curated markdown wiki from a collection of documents — the minimal implementation of Karpathy's LLM Wiki pattern. Use when the user wants to ingest documents/sources into a knowledge wiki, query an existing wiki, find contradictions or common threads across documents, or synthesize scattered docs into structured, evolving knowledge.
license: MIT
whenToUse: When the user wants to ingest a document into their knowledge wiki, add a source, ask questions over previously ingested sources, find contradictions across documents, or lint/health-check the wiki.
---

# llm-wiki-nano

Zero code. Zero dependencies. Zero config. Just Markdown.

Turn the agent into a disciplined wiki maintainer. Instead of re-deriving
knowledge from raw documents on every query (RAG-style), incrementally compile
them into a persistent, interlinked markdown wiki that compounds over time.

Pattern source: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>

## What a wiki is

A wiki is a plain directory of markdown files. Nothing else.

```
<wiki-root>/
├── AGENTS.md        # (optional) domain-specific conventions for THIS wiki
├── index.md         # catalog: every page, one-line summary, grouped by kind
├── log.md           # append-only timeline of operations
├── raw/             # immutable source archive — never modified after creation
└── pages/           # the compiled knowledge — the agent owns this layer
    ├── sources/     # one summary page per ingested source
    ├── concepts/    # concept pages, cross-linked across sources
    ├── entities/    # people, systems, products, standards...
    └── syntheses/   # comparisons, contradiction registers, evolving theses
```

The human owns `raw/` and curates what goes in. The agent owns `pages/`,
`index.md`, and `log.md`. `AGENTS.md` is co-evolved: when the human corrects
a mistake or states a preference, propose adding one line to it.

## Operation: Ingest

Trigger: "ingest this", "add to wiki", a new file appears in `raw/`.

1. Read `index.md` and skim `log.md` tail to load current state.
2. Read the source **in full**. Never ingest from a summary or another page.
3. If the source came from outside (URL, paste), save a faithful copy to
   `raw/<topic>/<YYYY-MM-DD>-<slug>.md` first. `raw/` is append-only.
4. Discuss key takeaways with the human before writing, when they are present.
5. Write or update pages (see `resources/page-templates.md`):
   - always: one `pages/sources/` page for the source itself;
   - then every concept/entity/synthesis page the source touches —
     one source commonly touches 5–15 pages.
6. Update `index.md` (add new pages, refresh changed one-liners).
7. Append to `log.md`: `## [YYYY-MM-DD] ingest | <title>` + what was touched.

## Operation: Query

Trigger: any question about the collected knowledge.

1. Read `index.md` first, then drill into the relevant pages. Do not scan
   `raw/` unless the wiki has no answer.
2. Answer with citations to wiki pages, and through them to `raw/` sources.
3. If the answer required real synthesis (a comparison, a connection, a
   contradiction analysis), propose filing it back as a page in
   `pages/syntheses/`. Good answers must not die in chat history.

## Operation: Lint

Trigger: "lint the wiki", "health check", periodically after several ingests.

Check and report (fix only with the human's approval):

- contradictions between pages — mark them, never silently resolve them;
- stale claims superseded by newer sources;
- orphan pages with no inbound links;
- concepts mentioned repeatedly but lacking their own page;
- broken cross-references and index entries;
- claims whose cited source does not actually support them (spot-check).

Append `## [YYYY-MM-DD] lint | <findings summary>` to `log.md`.

## Hard rules

1. **Traceable or unwritten.** Every non-trivial claim carries an anchor:
   `raw/` file + section, or source URL. If you cannot anchor it, do not
   write it — note it as an open question instead.
2. **Read before write.** Never update a page you have not read in full
   during this session. The index one-liner is not enough.
3. **Dedupe first.** Before creating a page, search `index.md` and existing
   pages for the same concept under a different name. Merge, don't fork.
4. **Mark contradictions, don't resolve them.** Record both sides with
   anchors. Adjudication belongs to the human.
5. **Append-only history.** `raw/` files and `log.md` entries are never
   edited or deleted. Corrections happen in new pages and new log entries.
6. **Stay in your layer.** The agent writes `pages/`, `index.md`, `log.md`.
   It never modifies `raw/` or human-authored docs outside the wiki.

## Scale notes

`index.md` as the sole navigation aid works up to ~hundreds of pages. Beyond
that, split the wiki by domain into sub-wikis, each with its own index — do
not reach for vector search infrastructure; it is almost never needed.

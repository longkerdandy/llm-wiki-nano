# llm-wiki-nano

**Zero code. Zero dependencies. Zero config. Just Markdown.**

The smallest possible implementation of Andrej Karpathy's
[LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
pattern, packaged as a portable agent skill.

## Why this exists

Ask an LLM a question over your documents today and it retrieves fragments
and improvises an answer — every single time, from scratch. Nothing
accumulates. Karpathy's alternative: let the LLM **incrementally maintain a
wiki** — a persistent, interlinked set of Markdown files where the synthesis
is already done. Cross-references built, contradictions flagged, conclusions
kept current. You curate sources and ask questions; the LLM does the
bookkeeping that made humans abandon every wiki they ever started.

That gist is 75 lines and deliberately ships no code. The implementations
that appeared since tend to miss the point: setup scripts, YAML configs,
vector databases, MCP servers — machinery the original pattern was designed
to avoid. At real-world scale (tens of sources, hundreds of pages) a text
index file beats all of it.

llm-wiki-nano is the pattern with nothing added:

```
SKILL.md                        # the entire skill: layout, 3 operations, 6 hard rules
resources/
├── page-templates.md           # source / concept / entity / synthesis page formats
└── agents-template.md          # optional per-wiki domain conventions
```

## What you get

- **A wiki that compounds.** Each ingested document updates 5–15 interlinked
  pages. Queries read the compiled result instead of re-searching raw text.
- **Contradictions as first-class citizens.** Divergent definitions and
  conflicting claims are recorded side by side, with anchors to both
  sources — never silently averaged away.
- **Full traceability.** Every claim in the wiki carries an anchor back to
  the raw source. If the agent can't anchor it, it doesn't write it.
- **Freedom from infrastructure.** No database, no server, no build. Your
  wiki is a directory of Markdown — browse it in Obsidian, version it with
  git, take it anywhere.

## Install

Works with any agent that supports SKILL.md skills (Claude Code, Kimi Code,
Codex, ...). One command, nothing to clone first:

```bash
curl -fsSL https://raw.githubusercontent.com/longkerdandy/llm-wiki-nano/master/install.sh | bash
```

The installer auto-detects Kimi Code, Claude Code, and the shared
`~/.agents/skills` directory. To pick a target explicitly:

```bash
curl -fsSL https://raw.githubusercontent.com/longkerdandy/llm-wiki-nano/master/install.sh | bash -s -- kimi   # kimi | claude | agents | all
```

Or install by hand:

```bash
# Claude Code
mkdir -p ~/.claude/skills/llm-wiki-nano
cp -r SKILL.md resources ~/.claude/skills/llm-wiki-nano/

# Kimi Code
mkdir -p ~/.kimi-code/skills/llm-wiki-nano
cp -r SKILL.md resources ~/.kimi-code/skills/llm-wiki-nano/
```

Note for Kimi Code users: the `SKILL.md` frontmatter carries one
Kimi-specific extension field, `whenToUse`, to improve automatic
triggering. Other agents ignore unknown frontmatter fields, so runtime
portability is unaffected — but be aware `skills-ref validate` flags
`whenToUse` as a non-standard field; that failure is expected and
deliberate.

## Quick start

```bash
mkdir -p ~/my-wiki/{raw,pages/{sources,concepts,entities,syntheses}}
cd ~/my-wiki
echo "# Index" > index.md && echo "# Log" > log.md
```

Then just talk to your agent:

- *"Ingest this document into the wiki: report.pdf"* — it reads the full
  text, archives it to `raw/`, writes a source page, updates every concept
  and entity page it touches, and logs the operation.
- *"What do my sources say about X?"* — answered from the compiled wiki,
  with citations. Good answers get filed back as synthesis pages, so your
  questions compound too.
- *"Lint the wiki."* — finds contradictions, stale claims, orphan pages,
  and claims whose sources don't actually support them.

Optional but recommended: copy `resources/agents-template.md` to your wiki's
`AGENTS.md` and fill in your domain vocabulary and local conventions. That
file grows one line at a time, each line earned from a real mistake.

## Who it's for

- **Architects and researchers** synthesizing dozens of documents — finding
  the common threads, the contradictions, and the evolution path.
- **Teams** whose knowledge is scattered across docs and meeting notes.
- **Readers** going deep on a topic over weeks, building a companion wiki
  as they go.

## Principles

1. **The schema is the product.** The pattern's value is in its
   conventions, so this repo contains only conventions.
2. **Co-evolve, don't over-specify.** Rules are added in response to real
   failures, not in anticipation of imaginary ones.
3. **The human adjudicates.** The agent marks contradictions; it never
   resolves them. Sourcing, direction, and judgment stay with you.

## Credits

- [Andrej Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f):
  the entire pattern — three layers, three operations, index + log.
- Vannevar Bush, *As We May Think* (1945): the Memex, the pattern's
  intellectual ancestor.

## License

MIT

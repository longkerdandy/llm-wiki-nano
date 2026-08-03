# AGENTS.md — working on llm-wiki-nano

Guidance for AI agents contributing to this repository. (For the template
used *inside a wiki instance*, see `resources/agents-template.md` — that is
a different file with a different audience.)

## What this repository is

llm-wiki-nano is a zero-code agent skill implementing Karpathy's LLM Wiki
pattern. **The artifacts of this repo are prose, not programs.** `SKILL.md`
is loaded into an agent's context at runtime; everything in `resources/` is
referenced from it. There is no build, no test suite, no CI.

## The prime directive

**Do not add code.** No scripts, no config files, no package manifests, no
CI workflows, no vector-search anything. The project's entire value
proposition is that the pattern needs none of that. If a problem seems to
call for tooling, solve it with better instructions first; if that is truly
impossible, open an issue instead of committing code.

Exception: `install.sh` was added at the repo owner's explicit request
(one-command install). It is the only permitted script: POSIX sh, cp/mkdir
only, no logic beyond copying the skill into agent skill directories. Do
not add further scripts without an equally explicit exemption.

## File inventory

| File | Audience | Role |
|------|----------|------|
| `SKILL.md` | agents at runtime | The skill. Trigger conditions, wiki layout, 3 operations, 6 hard rules |
| `resources/page-templates.md` | agents at runtime | Page formats, loaded on demand from SKILL.md |
| `resources/agents-template.md` | wiki owners | Optional per-wiki domain conventions template |
| `install.sh` | humans | One-command installer (exception to the prime directive) |
| `README.md` | humans | Pitch, install, quickstart, philosophy |
| `AGENTS.md` | agents editing this repo | This file |

## Editing rules

1. **Keep `SKILL.md` small.** Target ≤ ~120 lines / ~2k tokens. It is loaded
   whole into the agent's context on every trigger. Detail belongs in
   `resources/` and must be reachable in one hop from `SKILL.md`.
2. **Rules must be mechanically executable.** "Every claim carries an
   anchor" is a rule; "maintain high quality" is not. If a rule cannot be
   checked by an agent, rewrite or delete it.
3. **Co-evolution over speculation.** Add a rule only in response to an
   observed failure (in testing or user reports). Note the triggering
   failure in the commit message. Do not add rules "just in case".
4. **Agent-agnostic.** No Claude-/Kimi-/Codex-specific features in
   `SKILL.md` or templates. Agent-specific notes belong in `README.md`
   install sections.
5. **Sync the README.** If a change alters user-visible behavior (layout,
   operations, rules, install steps), update `README.md` in the same commit.
6. **English everywhere.** This repo's artifacts are English; keep it
   consistent regardless of the conversation language.

## How to test a change

There is no automation. The test loop is manual:

1. Create a scratch wiki: `mkdir -p /tmp/wikitest/{raw,pages/{sources,concepts,entities,syntheses}}`
   plus stub `index.md` and `log.md`.
2. Drop 2–3 real documents into `raw/` (any technical docs will do;
   contradicting sources are ideal).
3. In a fresh agent session with the modified skill installed, run:
   ingest both docs → ask a cross-document question → run lint.
4. Judge: did the agent follow the modified rule? Did pages cite anchors?
   Were contradictions marked rather than resolved?
5. A change that cannot be verified this way is not ready.

## Commit conventions

- Imperative subject, ≤ 72 chars, e.g. `Tighten dedupe rule after merge
  failure on wiki-x test`.
- One logical change per commit. Template changes and SKILL.md changes are
  separate commits unless coupled.

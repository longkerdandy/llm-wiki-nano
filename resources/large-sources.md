# Large and non-text sources

Referenced from `SKILL.md` when a source is too long to read in one
context or is not plain text. All hard rules still apply.

## Archiving non-text sources

For PDFs, slide decks, scans, and other binary sources:

1. Save the binary to `raw/<topic>/<YYYY-MM-DD>-<slug>.<ext>`. If the
   binary already lives stably inside the project, you may record its
   path in `log.md` instead of duplicating it.
2. Extract the text with the best available tool and save the transcript
   next to it: `raw/<topic>/<YYYY-MM-DD>-<slug>.txt`. Record the exact
   extraction command (tool + flags) in the `log.md` ingest entry, so the
   transcript is reproducible.
3. Anchors cite the document's own structure — `(<alias> §3.2)` or
   `(<alias> p.42)` — never transcript line numbers: those are extraction
   artifacts and change with the tool.
4. Content that survives only as images (screenshots, figures, formulas
   embedded in diagrams) is unextractable: record it in the page's "Open
   questions" with its figure number; never reconstruct it by guessing.
   If the agent can read images, a second pass over exported figure
   images is allowed — note it in `log.md`.

## Delegated ingest (large sources)

When the source text exceeds what you can read in one context (rule of
thumb: > ~50 KB, or book-length), split the reading, not the standard.
"Read in full" becomes **read in full, collectively**: every part of the
source is read completely by at least one reader.

1. **Coordinate, don't abdicate.** The coordinating agent reads the front
   matter and table of contents itself and builds a structural map
   (chapters/sections with locations).
2. **Partition along structure.** Assign readers ranges that follow
   chapter boundaries and tile the source with slight overlaps — never
   arbitrary byte ranges.
3. **Freeze a page registry first.** Before dispatching, fix the complete
   list of pages to be written (kind + slug + one-line intent) and enter
   them in `index.md` marked `*ingesting*`. Readers may only wikilink to
   registry slugs; discoveries outside the registry go into a page's
   "Open questions" and are reported back — readers never create
   unregistered pages.
4. **Dispatch readers** — sub-agents if the runtime supports them,
   otherwise sequential chunked reading by the coordinator. Each reader
   gets: its range, its assigned pages, the registry, and the hard rules.
5. **The coordinator writes the whole-source view itself**: the source
   hub page and any synthesis pages. Never delegate understanding of the
   whole.
6. **Sampling audit.** Before finalizing, verify 2–3 anchored claims per
   page against the source text.
7. Finish with the standard Ingest verify step (see `SKILL.md`), then
   replace the `*ingesting*` markers in `index.md` with final one-liners.

## Long sources: hub and part pages

One source page compresses one source — but a book-length source (~10+
chapters or major parts) does not compress into a single page. In that
case `pages/sources/<slug>.md` becomes a **hub**: whole-source summary,
part map, key claims, open questions — plus one part page per major part
at `pages/sources/<slug>--<part>.md`, in the usual source format.

## Borrowed content

Appendices, glossaries, and reference tables that fit no concept or
entity page may lodge inside the semantically nearest page under a
clearly labeled section — but the source page must register where each
such block went. Content may lodge elsewhere; it must be registered.

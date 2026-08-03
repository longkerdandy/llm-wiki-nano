#!/bin/sh
# install.sh — remote one-command installer for the llm-wiki-nano skill.
#
# NOTE: deliberate exception to the repo's "no code" prime directive,
# granted by the repo owner. POSIX sh + curl/wget + tar only.
#
# Usage (nothing to clone first):
#   curl -fsSL https://raw.githubusercontent.com/<owner>/llm-wiki-nano/HEAD/install.sh | bash
#   curl -fsSL ... | bash -s -- TARGET
#
# TARGET: kimi (~/.kimi-code/skills/), claude (~/.claude/skills/),
# agents (~/.agents/skills/), all; default is every detected agent dir.
set -eu

NAME=llm-wiki-nano
# TODO: replace <owner> with the GitHub owner once the repo is published.
REPO="${LLM_WIKI_NANO_REPO:-<owner>/llm-wiki-nano}"
TARBALL="${LLM_WIKI_NANO_TARBALL:-https://codeload.github.com/$REPO/tar.gz/HEAD}"

usage() {
    cat <<'EOF'
usage: curl -fsSL https://raw.githubusercontent.com/<owner>/llm-wiki-nano/HEAD/install.sh | bash [-s -- TARGET]
TARGET: kimi (~/.kimi-code/skills/), claude (~/.claude/skills/),
agents (~/.agents/skills/), all; default is every detected agent dir.
EOF
}

case "${1:-auto}" in
    auto)
        targets=""
        [ -d "$HOME/.kimi-code" ] && targets="$targets kimi"
        [ -d "$HOME/.claude" ] && targets="$targets claude"
        [ -d "$HOME/.agents/skills" ] && targets="$targets agents"
        if [ -z "$targets" ]; then
            echo "no agent directory detected; run one of:" >&2
            echo "  $0 kimi|claude|agents|all" >&2
            exit 1
        fi
        ;;
    all)
        targets="kimi claude agents"
        ;;
    kimi|claude|agents)
        targets="$1"
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 1
        ;;
esac

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
echo "fetching $TARBALL"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$TARBALL" -o "$TMP/repo.tar.gz"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$TARBALL" -O "$TMP/repo.tar.gz"
else
    echo "error: curl or wget is required" >&2
    exit 1
fi
mkdir -p "$TMP/repo"
tar -xzf "$TMP/repo.tar.gz" -C "$TMP/repo" --strip-components=1
[ -f "$TMP/repo/SKILL.md" ] || { echo "error: tarball did not contain SKILL.md" >&2; exit 1; }

for t in $targets; do
    case "$t" in
        kimi)   dest="$HOME/.kimi-code/skills/$NAME" ;;
        claude) dest="$HOME/.claude/skills/$NAME" ;;
        agents) dest="$HOME/.agents/skills/$NAME" ;;
    esac
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -R "$TMP/repo/SKILL.md" "$TMP/repo/resources" "$dest/"
    echo "installed: $dest"
done

echo "done. Start a new agent session to pick up the skill."

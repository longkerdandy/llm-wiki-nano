#!/bin/sh
# install.sh — one-command installer for the llm-wiki-nano skill.
#
# NOTE: this script is a deliberate exception to the repository's
# "no code" prime directive, granted by the repo owner. Keep it
# dependency-free (POSIX sh; curl/wget + tar only in remote mode).
#
# Local usage (repo already cloned):
#   ./install.sh            install into every detected agent's skill dir
#   ./install.sh kimi       Kimi Code only    (~/.kimi-code/skills/)
#   ./install.sh claude     Claude Code only  (~/.claude/skills/)
#   ./install.sh agents     shared dir only   (~/.agents/skills/)
#   ./install.sh all        all three, whether detected or not
#
# Remote usage (nothing cloned — downloads the repo tarball first):
#   curl -fsSL https://raw.githubusercontent.com/<owner>/llm-wiki-nano/HEAD/install.sh | bash
#   curl -fsSL ... | bash -s -- kimi        # same target arguments work
set -eu

NAME=llm-wiki-nano
# TODO: replace <owner> with the GitHub owner once the repo is published.
REPO="${LLM_WIKI_NANO_REPO:-<owner>/llm-wiki-nano}"
TARBALL="${LLM_WIKI_NANO_TARBALL:-https://codeload.github.com/$REPO/tar.gz/HEAD}"

usage() {
    sed -n '2,19p' "$0"
}

install_to() {
    dest="$1/$NAME"
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -R "$SRC/SKILL.md" "$SRC/resources" "$dest/"
    echo "installed: $dest"
}

# Resolve the skill source. When piped through curl there is no repo
# checkout next to the script, so fetch and unpack the tarball instead.
SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ ! -f "$SRC/SKILL.md" ]; then
    TMP=$(mktemp -d)
    trap 'rm -rf "$TMP"' EXIT
    echo "fetching $TARBALL"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$TARBALL" -o "$TMP/repo.tar.gz"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$TARBALL" -O "$TMP/repo.tar.gz"
    else
        echo "error: curl or wget is required for remote install" >&2
        exit 1
    fi
    mkdir -p "$TMP/repo"
    tar -xzf "$TMP/repo.tar.gz" -C "$TMP/repo" --strip-components=1
    SRC="$TMP/repo"
    [ -f "$SRC/SKILL.md" ] || { echo "error: tarball did not contain SKILL.md" >&2; exit 1; }
fi

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

for t in $targets; do
    case "$t" in
        kimi)   install_to "$HOME/.kimi-code/skills" ;;
        claude) install_to "$HOME/.claude/skills" ;;
        agents) install_to "$HOME/.agents/skills" ;;
    esac
done

echo "done. Start a new agent session to pick up the skill."

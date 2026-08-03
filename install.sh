#!/bin/sh
# install.sh — one-command installer for the llm-wiki-nano skill.
#
# NOTE: this script is a deliberate exception to the repository's
# "no code" prime directive, granted by the repo owner. Keep it
# dependency-free (POSIX sh + cp/mkdir only).
#
# Usage:
#   ./install.sh            install into every detected agent's skill dir
#   ./install.sh kimi       Kimi Code only    (~/.kimi-code/skills/)
#   ./install.sh claude     Claude Code only  (~/.claude/skills/)
#   ./install.sh agents     shared dir only   (~/.agents/skills/)
#   ./install.sh all        all three, whether detected or not
set -eu

NAME=llm-wiki-nano
SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

usage() {
    sed -n '2,13p' "$0"
}

install_to() {
    dest="$1/$NAME"
    rm -rf "$dest"
    mkdir -p "$dest"
    cp -R "$SRC/SKILL.md" "$SRC/resources" "$dest/"
    echo "installed: $dest"
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

for t in $targets; do
    case "$t" in
        kimi)   install_to "$HOME/.kimi-code/skills" ;;
        claude) install_to "$HOME/.claude/skills" ;;
        agents) install_to "$HOME/.agents/skills" ;;
    esac
done

echo "done. Start a new agent session to pick up the skill."

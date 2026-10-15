#!/usr/bin/env bash
# Re-takes docs/media/hero.png: renders hero-transcript.txt in a terminal with vhs.
# Needs vhs, ttyd and ffmpeg. Runs under a temporary HOME with a neutral prompt.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/hero.XXXXXX")
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/home" "$work/fixture"
cp "$here/hero-transcript.txt" "$work/fixture/"

cat > "$work/hero.tape" <<TAPE
Output "$work/hero.gif"
Set Shell "bash"
Set FontSize 15
Set Width 1180
Set Height 700
Set Padding 24
Set Theme "Dracula"
Hide
Type "export PS1='$ ' && cd '$work/fixture' && clear"
Enter
Type "clear; cat hero-transcript.txt; sleep 60"
Enter
Sleep 1s
Show
Wait+Screen@10s /status ready/
Sleep 1500ms
Screenshot "$here/hero.png"
Sleep 1s
TAPE

env -i PATH="$PATH" HOME="$work/home" TERM=xterm-256color vhs "$work/hero.tape"

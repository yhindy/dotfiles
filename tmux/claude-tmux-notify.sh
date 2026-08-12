#!/bin/sh
# Record what the Claude Code session in THIS pane is doing, as a per-pane tmux
# option the status bar renders as a coloured dot. Driven by Claude Code's own
# hook events - never by watching terminal output.
#
#   running   UserPromptSubmit - you gave it work, it is going
#   waiting   Notification (permission_prompt / idle_prompt) - blocked on you
#   done      Stop - finished responding, awaiting your next instruction
#   exit      SessionEnd - the session is over, this is a plain shell again
#
# Output-sniffing produces both failure modes: false positives from a spinner
# redraw, false negatives when the completion line scrolls past unmatched. These
# events come from the agent's own lifecycle, so there is nothing to infer.
#
# State is per PANE, not per window, so a window running Claude in one pane and
# a shell in another shows which is which. The window-level styling (red entry,
# waiting badge) is derived from the panes in .tmux.conf, so there is no second
# copy of the state to keep in sync.
#
# Registered in ~/.claude/settings.json. Reads the hook payload on stdin and
# ignores it - the event identity arrives as $1.

state=$1

# Not inside tmux (plain ssh, an editor terminal, a cron): nothing to record.
[ -n "$TMUX_PANE" ] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

if [ "$state" = exit ]; then
  tmux set-option -p -t "$TMUX_PANE" -u @claude_pane 2>/dev/null
  exit 0
fi

tmux set-option -p -t "$TMUX_PANE" @claude_pane "$state" 2>/dev/null
exit 0

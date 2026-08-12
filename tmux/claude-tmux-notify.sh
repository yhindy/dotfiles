#!/bin/sh
# Mark the tmux window a Claude Code session lives in, driven by Claude Code's
# own hook events - NOT by watching terminal output.
#
#   waiting  Notification hook (permission_prompt / idle_prompt) - Claude is
#            blocked on you and will sit there until you answer
#   done     Stop hook - Claude finished responding
#   clear    UserPromptSubmit hook - you just gave it work, nothing is pending
#
# Output-sniffing approaches produce both failure modes: false positives from a
# spinner redraw, false negatives when the "done" text scrolls past unmatched.
# These events come from the agent's own lifecycle, so there is nothing to infer.
#
# Registered in ~/.claude/settings.json. Reads the hook payload on stdin and
# ignores it - the event identity is passed as $1.

state=$1

# Not inside tmux (plain ssh, an editor terminal, a cron): nothing to mark.
[ -n "$TMUX_PANE" ] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

if [ "$state" = clear ]; then
  tmux set-option -w -t "$TMUX_PANE" -u @claude 2>/dev/null
  exit 0
fi

# If you are looking at this pane right now, the event is already on your
# screen - flagging it would just leave a marker you have to clear by hand.
# Detached (session_attached = 0) always marks: that is exactly the case where
# you walked away and need to know on return.
watching=$(tmux display-message -p -t "$TMUX_PANE" \
  '#{&&:#{session_attached},#{&&:#{window_active},#{pane_active}}}' 2>/dev/null)
[ "$watching" = "1" ] && exit 0

tmux set-option -w -t "$TMUX_PANE" @claude "$state" 2>/dev/null
exit 0

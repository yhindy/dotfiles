import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

// Report what the pi session in this tmux pane is doing, so it shows up as a
// coloured dot in the status bar exactly like a Claude Code session does. Same
// script, same per-pane @claude_pane option - see tmux/claude-tmux-notify.sh.
//
// pi's events map cleanly onto three of our four states:
//
//   agent_start       running   the agent is working
//   agent_settled     done      documented as the event for status integrations:
//                               pi will not continue on its own from here
//   session_shutdown  exit      session over, the pane is a plain shell again
//
// There is deliberately no `waiting`. Claude Code raises a permission prompt and
// fires a Notification we can catch; pi runs its tools without gating them, so
// nothing is ever blocked on you. A red dot would be a state pi cannot enter.
// If you later add an extension that gates tools with ctx.ui.confirm(), hook
// `waiting` around that confirm and the dot turns red for pi too.
//
// agent_end is NOT used: pi may auto-retry or auto-compact and keep going after
// it, which would flash "done" mid-run. agent_settled is the honest one.

const NOTIFY = join(homedir(), ".dotfiles", "tmux", "claude-tmux-notify.sh");

function report(state: "running" | "done" | "exit") {
  if (!process.env.TMUX_PANE) return; // not inside tmux, nothing to report to
  execFile(NOTIFY, [state], { timeout: 5000 }, () => {
    // fire and forget: a status dot must never take a session down with it
  });
}

export default function (pi: ExtensionAPI) {
  pi.on("agent_start", async () => report("running"));
  pi.on("agent_settled", async () => report("done"));
  pi.on("session_shutdown", async () => report("exit"));
}

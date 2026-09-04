// Reports pi's state to the tmux status bar through tmux-agents (dotfiles bin).
// pi has no built-in permission prompt, so there is no "blocked" state here.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  if (!process.env.TMUX_PANE) return;
  const pane = process.env.TMUX_PANE;
  const mark = (state: string) =>
    pi.exec("tmux-agents", state === "clear" ? ["clear"] : ["set", state]).catch(() => {});
  const name = () =>
    pi.exec("tmux", ["set", "-p", "-t", pane, "@agent_name", "pi"]).catch(() => {});

  pi.on("session_start", async () => { await mark("idle"); await name(); });
  pi.on("agent_start", async () => { await mark("working"); });
  pi.on("agent_end", async () => { await mark("done"); });
  pi.on("session_shutdown", async () => { await mark("clear"); });
}

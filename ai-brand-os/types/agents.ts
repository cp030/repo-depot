export type AgentStatus = "idle" | "running" | "complete" | "error";

export interface AgentResult {
  agentId: string;
  status: AgentStatus;
  output: unknown;
  error?: string;
}

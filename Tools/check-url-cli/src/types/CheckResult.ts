export interface CheckResult {
  url: string;
  status?: number;
  latency?: number;
  error?: string;
  success: boolean;
}

import http from "http";
import https from "https";
import { URL } from "url";
import { CheckResult } from "../../types/CheckResult";

/**
 * Checks a URL for reachability and status code.
 *
 * @param url - The URL to check
 * @param timeout - Timeout in milliseconds
 * @returns A CheckResult object with details
 */
export async function checkUrl(url: string, timeout: number): Promise<CheckResult> {
  return new Promise((resolve) => {
    let parsed: URL;
    try {
      parsed = new URL(url);
    } catch {
      return resolve({ url, error: "Invalid URL", success: false });
    }

    const client = parsed.protocol === "https:" ? https : http;
    const start = Date.now();

    const req = client.get(parsed, (res) => {
      const latency = Date.now() - start;
      const status = res.statusCode;
      const success = status !== undefined && status < 400;

      resolve({
        url,
        status,
        latency,
        success
      });
    });

    req.setTimeout(timeout, () => {
      req.destroy();
      resolve({ url, error: `Timeout after ${timeout}ms`, success: false });
    });

    req.on("error", (err) => {
      resolve({ url, error: err.message, success: false });
    });
  });
}
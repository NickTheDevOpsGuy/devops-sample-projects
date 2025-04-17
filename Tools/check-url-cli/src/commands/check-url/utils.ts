import fs from "fs";

export function parseTimeout(value: string | undefined, fallback = 5000): number {
  const parsed = parseInt(value || "", 10);
  return isNaN(parsed) ? fallback : parsed;
}

export function parseRetries(value: string | undefined, fallback = 0): number {
  const parsed = parseInt(value || "", 10);
  return isNaN(parsed) ? fallback : parsed;
}

export function loadUrlsFromConfig(path: string): string[] {
  try {
    const data = fs.readFileSync(path, "utf-8");
    const parsed = JSON.parse(data);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}
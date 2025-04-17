#!/usr/bin/env ts-node

import minimist from "minimist";
import { checkUrl } from "./checker";
import { formatResult, writeResultsToFile, printSummary } from "./formatter";
import { parseTimeout, parseRetries, loadUrlsFromConfig } from "./utils";
import { OutputFormat } from "../../enums/OutputFormat";

const args = minimist(process.argv.slice(2), {
  string: ["timeout", "format", "log", "config", "retries", "concurrency"],
  default: {
    timeout: "5000",
    format: "text",
    retries: "0",
    concurrency: "5"
  }
});

let urls: string[] = args._;
if (args.config) {
  urls = loadUrlsFromConfig(args.config);
}

const timeout = parseTimeout(args.timeout);
const format = args.format.toLowerCase() === "json" ? OutputFormat.JSON : OutputFormat.TEXT;
const logPath = args.log;
const retries = parseRetries(args.retries);
const concurrency = parseInt(args.concurrency, 10) || 5;

if (urls.length === 0) {
  console.error("❌ No URLs provided.");
  process.exit(1);
}

const checkWithRetry = async (url: string): Promise<ReturnType<typeof checkUrl>> => {
  for (let attempt = 0; attempt <= retries; attempt++) {
    const result = await checkUrl(url, timeout);
    if (result.success || attempt === retries) return result;
  }
  return { url, success: false, error: "Max retries exceeded" };
};

const run = async () => {
  const start = Date.now();
  const results: any[] = [];

  const pool = [...urls];
  const workers: Promise<void>[] = [];

  const runNext = async () => {
    while (pool.length > 0) {
      const url = pool.shift();
      if (!url) break;
      const result = await checkWithRetry(url);
      results.push(result);
      console.log(formatResult(result, format));
    }
  };

  for (let i = 0; i < concurrency; i++) {
    workers.push(runNext());
  }

  await Promise.all(workers);

  if (logPath) {
    writeResultsToFile(results, logPath, format);
  }

  printSummary(results, start);

  const hasFailures = results.some(r => !r.success);
  process.exit(hasFailures ? 1 : 0);
};

run();
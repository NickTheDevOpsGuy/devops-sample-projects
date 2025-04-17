import chalk from "chalk";
import fs from "fs";
import { CheckResult } from "../../types/CheckResult";
import { OutputFormat } from "../../enums/OutputFormat";

export function formatResult(result: CheckResult, format: OutputFormat): string {
  if (format === OutputFormat.JSON) return JSON.stringify(result);

  if (result.success) {
    return chalk.green(`✅ ${result.url} (${result.status}) - ${result.latency}ms`);
  } else if (result.status) {
    return chalk.yellow(`⚠️ ${result.url} (${result.status}) - ${result.latency}ms`);
  } else {
    return chalk.red(`❌ ${result.url} - ${result.error}`);
  }
}

export function writeResultsToFile(results: CheckResult[], path: string, format: OutputFormat) {
  const output = format === OutputFormat.JSON
    ? JSON.stringify(results, null, 2)
    : results.map(r => formatResult(r, format)).join("\n");

  fs.writeFileSync(path, output);
}

export function printSummary(results: CheckResult[], startTime: number) {
  const passed = results.filter(r => r.success).length;
  const failed = results.length - passed;
  const duration = ((Date.now() - startTime) / 1000).toFixed(2);
  console.log(`\n📊 Summary: ✅ Passed: ${passed} | ❌ Failed: ${failed} | 🕐 Duration: ${duration}s`);
}
# 🔍 check-url CLI

**check-url** is a DevOps-ready CLI tool built with TypeScript that allows you to check the availability and response status of one or more URLs in parallel.

This tool is designed for reliability, observability, and clean scripting in CI pipelines or standalone health checks. It's modular, type-safe, and supports multiple output formats and logging.

---

## 🚀 Features

- 🔁 Check **multiple URLs** in parallel
- ⏱ Configurable **request timeout**
- 📄 Output in **text** or **JSON** format
- 🗂 Log results to a file
- 📦 Built with TypeScript + Chalk + Node.js
- 🧱 Modular structure for scaling and extension
- ✅ Clean exit codes (0 for success, 1 for any failure)

---

## 📦 Installation

```bash
npm install

## 🧪 Usage

- ✅ Basic URL Check

```bash
npx ts-node src/commands/check-url/check-url.ts https://example.com
```

- 🔁 Check Multiple URLs

```bash
npx ts-node src/commands/check-url/check-url.ts https://example.com https://google.com
```

- 🧪 Custom Timeout

```bash
npx ts-node src/commands/check-url/check-url.ts https://example.com --timeout 3000
```

- 🗂 Log to File

```bash
npx ts-node src/commands/check-url/check-url.ts https://example.com --log results.json
```

- 📄 JSON Output

```bash
npx ts-node src/commands/check-url/check-url.ts https://example.com --format json
```

## 🧰 Options

| Flag          | Description                                                   | Default     |
|---------------|---------------------------------------------------------------|-------------|
| `<urls>`      | One or more URLs to check                                     | required    |
| `--timeout`   | Request timeout in milliseconds                               | `5000`      |
| `--format`    | Output format: `text` or `json`                               | `text`      |
| `--log`       | Write results to this file (based on selected format)         | _(none)_    |
| `--retries`   | Number of retries on failure per URL                          | `0`         |
| `--config`    | Load URLs from a JSON file (overrides inline args if present) | _(none)_    |

## 🎯 Exit Codes

## 📁 Project Structure

src/
├── commands/check-url/   # CLI command implementation
├── types/                # Type definitions
├── enums/                # Enums like OutputFormat

## 🛠 Built With

* [TypeScript] (https://www.typescriptlang.org/)
* [Node.js] (https://nodejs.org/en)
* [Chalk] (https://www.npmjs.com/package/chalk)
* [minimist] (https://www.npmjs.com/package/minimist)
* [ts-node] (https://www.npmjs.com/package/ts-node)

## 🧱 Example Output

```text
✅ https://example.com (200) - 180ms
❌ https://badurl.dev - Request error: ENOTFOUND
```

```json
[
  {
    "url": "https://example.com",
    "status": 200,
    "latency": 180,
    "success": true
  },
  {
    "url": "https://badurl.dev",
    "error": "ENOTFOUND",
    "success": false
  }
]
```

## 🧪 Want to Package as a Binary?

```bash
npm install -g pkg
pkg .
```

## 🔧 Dev Notes

This CLI tool is structured for maintainability and future enhancements:

* Add support for Slack notifications
* Export Prometheus metrics
* Add retry logic and alert thresholds

## Author

Created by Nick Clark as part of his World Domination DevOps series.
import fs from "fs";
import { sendMetric } from "./sendMetric";

export default async () => {
  const raw = fs.readFileSync("playwright-report/.last-run.json", "utf8");
  const report = JSON.parse(raw);

  let total = 0;
  let failed = 0;

  for (const suite of report.suites || []) {
    for (const spec of suite.specs || []) {
      total += spec.tests.length;
      failed += spec.tests.filter((t: any) =>
        t.results.some((r: any) => r.status === "failed")
      ).length;
    }
  }

  console.log(`✅ Total tests: ${total}, ❌ Failed tests: ${failed}`);

  await sendMetric({ name: "TotalTests", value: total });
  await sendMetric({ name: "FailedTests", value: failed });
};

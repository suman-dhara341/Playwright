import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  reporter: [["json", { outputFile: "playwright-report/.last-run.json" }]],
  globalTeardown: "./global-teardown.ts",
});

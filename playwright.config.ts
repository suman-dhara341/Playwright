import { defineConfig, devices } from "@playwright/test";
import dotenv from "dotenv";
import { EnvConfig } from "./src/config/config";

dotenv.config();

export default defineConfig({
  testDir: "./tests",
  timeout: 80000,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: process.env.CI
    ? [
        ["html"],
        ["json", { outputFile: "test-results/results.json" }],
        ["github"],
      ]
    : [["html"], ["list"]],
  use: {
    baseURL: EnvConfig.userUrl,
    headless: process.env.CI ? true : false,
    screenshot: "only-on-failure",
    video: "retain-on-failure",
    trace: "on-first-retry",
    actionTimeout: 30000,
    navigationTimeout: 60000,
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "firefox",
      use: { ...devices["Desktop Firefox"] },
    },
    {
      name: "webkit",
      use: { ...devices["Desktop Safari"] },
    },
    {
      name: "mobile-chrome",
      use: { ...devices["Pixel 5"] },
    },
    {
      name: "mobile-safari",
      use: { ...devices["iPhone 12"] },
    },
  ],
  outputDir: "test-results",
  webServer: process.env.CI
    ? undefined
    : {
        command: "npm run dev",
        port: 5173,
        reuseExistingServer: !process.env.CI,
      },
});

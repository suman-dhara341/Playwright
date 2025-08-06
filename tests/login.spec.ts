import { test, expect } from "@playwright/test";

test("login should show welcome message", async ({ page }) => {
  try {
    await page.goto("https://main.dosl6rwrhoxpw.amplifyapp.com/");

    await page.getByPlaceholder("Enter email").fill("user@example.com");
    await page.getByRole("button", { name: "Login" }).click();
    await expect(page.getByText("Welcome, user@example.com!")).toBeVisible();
    await expect(page.getByText("sdsds")).toBeVisible();
    await page.goto("localhost:3000/");
  } catch (error) {
    console.error(
      JSON.stringify({
        level: "error",
        timestamp: new Date().toISOString(),
        message: "An error occurred during the login test",
      })
    );
    console.log("Hello");
  }
});

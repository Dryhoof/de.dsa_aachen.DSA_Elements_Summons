import { test, expect } from '@playwright/test';

test.describe('Install Page', () => {
  test.beforeEach(async ({ page }) => {
    // Navigate to the install page
    await page.goto('/');
  });

  test('shows app name "DSA Elements Summons"', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('DSA Elements Summons');
  });

  test('shows app icon', async ({ page }) => {
    const icon = page.locator('img[alt="DSA Elements Summons"]');
    await expect(icon).toBeVisible();
  });

  test('"Continue in Browser" button is visible', async ({ page }) => {
    // The button uses i18n key 'continueInBrowser'
    // In English it renders as something like "Continue in Browser"
    const btn = page.getByRole('button').filter({ hasText: /continue|browser/i });
    await expect(btn).toBeVisible();
  });

  test('clicking "Continue in Browser" navigates to /home', async ({ page }) => {
    const btn = page.getByRole('button').filter({ hasText: /continue|browser/i });
    await btn.click();
    await expect(page).toHaveURL(/\/home/);
  });

  test('shows description text', async ({ page }) => {
    // The page renders a <p> with installDescription i18n key
    const desc = page.locator('p');
    await expect(desc).toBeVisible();
  });

  test('page loads without errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('pageerror', err => errors.push(err.message));
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    expect(errors).toHaveLength(0);
  });

  test('in standalone display mode, redirects to /home', async ({ browser }) => {
    // Simulate standalone mode by overriding matchMedia
    const context = await browser.newContext();
    const page = await context.newPage();

    // Override matchMedia before navigation
    await page.addInitScript(() => {
      Object.defineProperty(window, 'matchMedia', {
        writable: true,
        value: (query: string) => ({
          matches: query.includes('standalone'),
          media: query,
          onchange: null,
          addListener: () => {},
          removeListener: () => {},
          addEventListener: () => {},
          removeEventListener: () => {},
          dispatchEvent: () => false,
        }),
      });
    });

    await page.goto('/');
    await expect(page).toHaveURL(/\/home/);
    await context.close();
  });
});

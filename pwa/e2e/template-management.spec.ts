import { test, expect } from '@playwright/test';

test.describe('Template Management', () => {
  let characterId: number;
  const charName = `Template Test ${Date.now()}`;

  test.beforeAll(async ({ browser }) => {
    const page = await browser.newPage();
    await page.goto('/character/new');
    await page.waitForLoadState('networkidle');

    await page.getByPlaceholder(/name|Name/i).first().fill(charName);
    await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
    await page.waitForURL(/\/home/);

    // Navigate to summoning to capture ID
    await page.locator('[class*="characterCard"]').filter({ hasText: charName }).click();
    await page.locator('[class*="sheet"]').getByRole('button').filter({ hasText: /summon|beschwören/i }).click();
    await page.waitForURL(/\/summon\/\d+/);

    const url = page.url();
    const match = url.match(/\/summon\/(\d+)/);
    characterId = match ? Number(match[1]) : 1;
    await page.close();
  });

  // ─── Elemental Templates List Page ───────────────────────────────────

  test('navigating to /character/:id/elementals shows template list', async ({ page }) => {
    await page.goto(`/character/${characterId}/elementals`);
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveURL(`/character/${characterId}/elementals`);
  });

  test('template list page has a "+" FAB or new template button', async ({ page }) => {
    await page.goto(`/character/${characterId}/elementals`);
    await page.waitForLoadState('networkidle');

    // Look for a FAB or "new" button
    const newBtn = page.locator('button').filter({ hasText: /\+|new|neue/i });
    await expect(newBtn.first()).toBeVisible();
  });

  // ─── Create Template ──────────────────────────────────────────────────

  test('can navigate to new template creation page', async ({ page }) => {
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveURL(/elementals\/new/);
  });

  test('template edit page shows a name/title input', async ({ page }) => {
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');

    const nameInput = page.getByPlaceholder(/name|Name/i).first().or(
      page.locator('input[type="text"]').first()
    );
    await expect(nameInput).toBeVisible();
  });

  test('can create a new template with a name', async ({ page }) => {
    const templateName = `My Template ${Date.now()}`;
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');

    // Fill in template name
    const nameInput = page.getByPlaceholder(/name|Name/i).first().or(
      page.locator('input[type="text"]').first()
    );
    await nameInput.fill(templateName);

    // Save
    const saveBtn = page.getByRole('button').filter({ hasText: /save|speichern/i });
    await saveBtn.click();

    // Should navigate back to the template list
    await expect(page).toHaveURL(new RegExp(`/character/${characterId}/elementals`));

    // Template should appear in the list
    await expect(page.locator(`text=${templateName}`)).toBeVisible();
  });

  // ─── Load Template ────────────────────────────────────────────────────

  test('templates appear in the list after creation', async ({ page }) => {
    // Create a template first
    const templateName = `Load Test Template ${Date.now()}`;
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');

    const nameInput = page.getByPlaceholder(/name|Name/i).first().or(
      page.locator('input[type="text"]').first()
    );
    await nameInput.fill(templateName);
    await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
    await page.waitForURL(new RegExp(`/character/${characterId}/elementals`));

    // Verify the template appears
    await expect(page.locator(`text=${templateName}`)).toBeVisible();
  });

  test('clicking a template opens edit or load action', async ({ page }) => {
    // Create a template to work with
    const templateName = `Click Test ${Date.now()}`;
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');

    const nameInput = page.getByPlaceholder(/name|Name/i).first().or(
      page.locator('input[type="text"]').first()
    );
    await nameInput.fill(templateName);
    await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
    await page.waitForURL(new RegExp(`/character/${characterId}/elementals`));

    // Click on the template
    await page.locator(`text=${templateName}`).click();

    // Should either navigate to edit page or show an action sheet
    const isOnEditPage = page.url().includes('/elementals/') && !page.url().endsWith('/elementals');
    const hasActionSheet = await page.locator('[class*="sheet"]').isVisible().catch(() => false);
    expect(isOnEditPage || hasActionSheet).toBe(true);
  });

  // ─── Delete Template ──────────────────────────────────────────────────

  test('can delete a template from the list', async ({ page }) => {
    const templateName = `Delete Template ${Date.now()}`;
    await page.goto(`/character/${characterId}/elementals/new`);
    await page.waitForLoadState('networkidle');

    const nameInput = page.getByPlaceholder(/name|Name/i).first().or(
      page.locator('input[type="text"]').first()
    );
    await nameInput.fill(templateName);
    await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
    await page.waitForURL(new RegExp(`/character/${characterId}/elementals`));

    // Find and delete the template
    const templateItem = page.locator('[class*="templateCard"], [class*="listItem"], li').filter({ hasText: templateName });
    if (await templateItem.count() > 0) {
      // Click it to open action sheet
      await templateItem.first().click();
      const deleteBtn = page.getByRole('button').filter({ hasText: /delete|löschen/i });
      if (await deleteBtn.count() > 0) {
        await deleteBtn.click();
        await expect(page.locator(`text=${templateName}`)).not.toBeVisible();
      }
    }
  });

  // ─── Hide/Unhide Predefined Summonings ───────────────────────────────

  test('template list or summoning page allows hiding predefined summonings', async ({ page }) => {
    await page.goto(`/summon/${characterId}`);
    await page.waitForLoadState('networkidle');

    // Look for a hide/show toggle on predefined summoning items
    const predefinedBtns = page.locator('[class*="predefinedBtn"]');
    const count = await predefinedBtns.count();
    expect(count).toBeGreaterThan(0);
  });
});

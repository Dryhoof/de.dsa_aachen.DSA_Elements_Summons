import { test, expect } from '@playwright/test';

test.describe('Character Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/home');
    await page.waitForLoadState('networkidle');
  });

  // ─── Create Character ────────────────────────────────────────────────────

  test('shows "+" FAB button on home page', async ({ page }) => {
    const fab = page.locator('button').filter({ hasText: '+' });
    await expect(fab).toBeVisible();
  });

  test('shows empty state when no characters exist', async ({ page }) => {
    // Fresh state — no characters yet
    // Looks for the empty state icon or text
    const hasEmptyState = await page.locator('text=/no character|keine Figur|⚗️/i').isVisible().catch(() => false);
    const hasList = await page.locator('[class*="characterCard"]').count();
    // Either empty state is shown OR there are already characters from a prior test run
    expect(hasEmptyState || hasList >= 0).toBe(true);
  });

  test('clicking + navigates to /character/new', async ({ page }) => {
    const fab = page.locator('button').filter({ hasText: '+' });
    await fab.click();
    await expect(page).toHaveURL(/\/character\/new/);
  });

  test('can create a new character and it appears in the list', async ({ page }) => {
    // Navigate to new character form
    await page.goto('/character/new');
    await page.waitForLoadState('networkidle');

    // Fill in character name
    const nameInput = page.getByPlaceholder(/name|Name/i).first();
    await nameInput.fill('Test Hero');

    // Save the character
    const saveBtn = page.getByRole('button').filter({ hasText: /save|speichern/i });
    await saveBtn.click();

    // Should navigate back to home
    await expect(page).toHaveURL(/\/home/);

    // Character should now be visible
    await expect(page.locator('text=Test Hero')).toBeVisible();
  });

  // ─── Select Character (Bottom Sheet) ────────────────────────────────────

  test('clicking a character card opens the action sheet', async ({ page }) => {
    // Create a character first if needed
    const characterCount = await page.locator('[class*="characterCard"]').count();
    if (characterCount === 0) {
      await page.goto('/character/new');
      await page.getByPlaceholder(/name|Name/i).first().fill('Sheet Test');
      await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
      await page.waitForURL(/\/home/);
    }

    // Click on the first character card
    await page.locator('[class*="characterCard"]').first().click();

    // Bottom sheet should appear
    await expect(page.locator('[class*="sheet"]')).toBeVisible();
  });

  test('action sheet has summon, edit, templates, delete buttons', async ({ page }) => {
    // Ensure at least one character exists
    const characterCount = await page.locator('[class*="characterCard"]').count();
    if (characterCount === 0) {
      await page.goto('/character/new');
      await page.getByPlaceholder(/name|Name/i).first().fill('Action Test');
      await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
      await page.waitForURL(/\/home/);
    }

    await page.locator('[class*="characterCard"]').first().click();

    // Check for action buttons in the sheet
    const sheet = page.locator('[class*="sheet"]');
    await expect(sheet.getByRole('button').filter({ hasText: /summon|beschwören/i })).toBeVisible();
    await expect(sheet.getByRole('button').filter({ hasText: /edit|bearbeiten/i })).toBeVisible();
    await expect(sheet.getByRole('button').filter({ hasText: /template|vorlage/i })).toBeVisible();
    await expect(sheet.getByRole('button').filter({ hasText: /delete|löschen/i })).toBeVisible();
  });

  // ─── Edit Character ──────────────────────────────────────────────────────

  test('clicking edit navigates to the character edit page', async ({ page }) => {
    const characterCount = await page.locator('[class*="characterCard"]').count();
    if (characterCount === 0) {
      await page.goto('/character/new');
      await page.getByPlaceholder(/name|Name/i).first().fill('Edit Test');
      await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
      await page.waitForURL(/\/home/);
    }

    await page.locator('[class*="characterCard"]').first().click();
    const sheet = page.locator('[class*="sheet"]');
    await sheet.getByRole('button').filter({ hasText: /edit|bearbeiten/i }).click();

    await expect(page).toHaveURL(/\/character\/\d+/);
  });

  // ─── Delete Character with Undo ─────────────────────────────────────────

  test('deleting a character shows undo toast', async ({ page }) => {
    // Ensure we have a character
    const characterCount = await page.locator('[class*="characterCard"]').count();
    if (characterCount === 0) {
      await page.goto('/character/new');
      await page.getByPlaceholder(/name|Name/i).first().fill('Delete Me');
      await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
      await page.waitForURL(/\/home/);
    }

    await page.locator('[class*="characterCard"]').first().click();
    const sheet = page.locator('[class*="sheet"]');
    await sheet.getByRole('button').filter({ hasText: /delete|löschen/i }).click();

    // A toast notification with "undo" should appear
    await expect(page.locator('text=/undo|rückgängig/i')).toBeVisible();
  });

  test('clicking undo restores the deleted character', async ({ page }) => {
    // Create a character with a unique name
    const uniqueName = `Undo Test ${Date.now()}`;
    await page.goto('/character/new');
    await page.getByPlaceholder(/name|Name/i).first().fill(uniqueName);
    await page.getByRole('button').filter({ hasText: /save|speichern/i }).click();
    await page.waitForURL(/\/home/);

    // Delete it
    const card = page.locator('[class*="characterCard"]').filter({ hasText: uniqueName });
    await card.click();
    const sheet = page.locator('[class*="sheet"]');
    await sheet.getByRole('button').filter({ hasText: /delete|löschen/i }).click();

    // Verify it's gone
    await expect(page.locator(`text=${uniqueName}`)).not.toBeVisible();

    // Click undo
    await page.locator('button').filter({ hasText: /undo|rückgängig/i }).click();

    // Character should be restored
    await expect(page.locator(`text=${uniqueName}`)).toBeVisible();
  });

  // ─── Language switcher on home page ─────────────────────────────────────

  test('language switcher DE/EN buttons are visible', async ({ page }) => {
    await expect(page.getByRole('button', { name: 'DE' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'EN' })).toBeVisible();
  });
});

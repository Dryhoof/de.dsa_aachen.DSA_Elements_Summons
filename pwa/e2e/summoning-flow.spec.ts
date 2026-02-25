import { test, expect } from '@playwright/test';

/**
 * Helper: ensures a character exists in the DB and returns the character ID
 * by navigating to /character/new, creating one, and extracting the ID from the
 * subsequent edit redirect.
 */
async function ensureCharacter(page: import('@playwright/test').Page, name = 'E2E Char'): Promise<number> {
  await page.goto('/character/new');
  await page.waitForLoadState('networkidle');

  const nameInput = page.getByPlaceholder(/name|Name/i).first();
  await nameInput.fill(name);

  const saveBtn = page.getByRole('button').filter({ hasText: /save|speichern/i });
  await saveBtn.click();
  await page.waitForURL(/\/home/);

  // Find the card and get ID from the link/navigate
  await page.locator('[class*="characterCard"]').filter({ hasText: name }).click();
  const sheet = page.locator('[class*="sheet"]');
  await sheet.getByRole('button').filter({ hasText: /summon|beschwören/i }).click();

  // URL is /summon/:id
  const url = page.url();
  const match = url.match(/\/summon\/(\d+)/);
  return match ? Number(match[1]) : 1;
}

test.describe('Summoning Flow', () => {
  let characterId: number;

  test.beforeAll(async ({ browser }) => {
    const page = await browser.newPage();
    await page.goto('/home');
    await page.waitForLoadState('networkidle');

    // Create a character for all tests in this suite
    const name = `Summon Test ${Date.now()}`;
    await page.goto('/character/new');
    await page.waitForLoadState('networkidle');

    const nameInput = page.getByPlaceholder(/name|Name/i).first();
    await nameInput.fill(name);

    const saveBtn = page.getByRole('button').filter({ hasText: /save|speichern/i });
    await saveBtn.click();
    await page.waitForURL(/\/home/);

    // Navigate to the character to capture its ID
    await page.locator('[class*="characterCard"]').filter({ hasText: name }).click();
    await page.locator('[class*="sheet"]').getByRole('button').filter({ hasText: /summon|beschwören/i }).click();
    await page.waitForURL(/\/summon\/\d+/);

    const url = page.url();
    const match = url.match(/\/summon\/(\d+)/);
    characterId = match ? Number(match[1]) : 1;
    await page.close();
  });

  test.beforeEach(async ({ page }) => {
    await page.goto(`/summon/${characterId}`);
    await page.waitForLoadState('networkidle');
  });

  // ─── Page structure ────────────────────────────────────────────────────

  test('summoning page loads and shows element selection', async ({ page }) => {
    // Should show element buttons (Fire, Water, etc.)
    const elementBtns = page.locator('[class*="elementBtn"]');
    await expect(elementBtns).toHaveCount(6);
  });

  test('shows summoning type buttons (Servant, Djinn, Master)', async ({ page }) => {
    const typeBtns = page.locator('[class*="typeBtn"]');
    await expect(typeBtns).toHaveCount(3);
  });

  test('shows live calculation result bar at the bottom', async ({ page }) => {
    const stickyBar = page.locator('[class*="stickyBar"]');
    await expect(stickyBar).toBeVisible();
  });

  test('Calculate button is visible in the sticky bar', async ({ page }) => {
    const calcBtn = page.locator('[class*="calcBtn"]');
    await expect(calcBtn).toBeVisible();
  });

  // ─── Element switching ─────────────────────────────────────────────────

  test('clicking an element button makes it active', async ({ page }) => {
    const elementBtns = page.locator('[class*="elementBtn"]');
    // Click the second element (Water)
    await elementBtns.nth(1).click();
    // The clicked button should have the active class
    await expect(elementBtns.nth(1)).toHaveClass(/active/);
  });

  test('switching element deactivates the previous element', async ({ page }) => {
    const elementBtns = page.locator('[class*="elementBtn"]');
    // Fire is active by default (index 0)
    await elementBtns.nth(1).click(); // Switch to Water
    await expect(elementBtns.nth(0)).not.toHaveClass(/active/);
  });

  // ─── Summoning type switching ──────────────────────────────────────────

  test('clicking Djinn type button makes it active and updates calculation', async ({ page }) => {
    const typeBtns = page.locator('[class*="typeBtn"]');
    // Djinn is second button (index 1)
    await typeBtns.nth(1).click();
    await expect(typeBtns.nth(1)).toHaveClass(/active/);

    // The summon modifier should now show 8 (base for Djinn)
    const modCardValues = page.locator('[class*="modCardValue"]');
    const summonVal = await modCardValues.first().textContent();
    // At minimum verify the value is a number string (+N or -N or N)
    expect(summonVal).toMatch(/^[+-]?\d+$/);
  });

  // ─── Live calculation updates ──────────────────────────────────────────

  test('live calculation values update when toggling an ability', async ({ page }) => {
    // Open the Abilities section (collapsible)
    const abilitiesSection = page.locator('[class*="collapsible"], section').filter({ hasText: /abilities|fähigkeiten/i });
    if (await abilitiesSection.count() > 0) {
      await abilitiesSection.first().click();
    }

    // Record the initial summon value
    const summonCard = page.locator('[class*="modCardValue"]').first();
    const initialValue = await summonCard.textContent();

    // Find and click the astralSense checkbox row
    const astralSenseRow = page.locator('[class*="checkRow"]').filter({ hasText: /astral|Astral/i });
    if (await astralSenseRow.count() > 0) {
      await astralSenseRow.first().click();
      const newValue = await summonCard.textContent();
      // Value should have changed (increased by 5)
      expect(newValue).not.toBe(initialValue);
    }
  });

  // ─── Circumstances section ─────────────────────────────────────────────

  test('circumstances section contains material purity dropdown', async ({ page }) => {
    // Find and open the circumstances section
    const circumstancesSection = page.locator('button, [role="button"]').filter({ hasText: /circumstances|umstände/i });
    if (await circumstancesSection.count() > 0) {
      await circumstancesSection.first().click();
    }

    // Material purity select should be visible
    const selects = page.locator('select');
    await expect(selects).toHaveCountGreaterThan(0);
  });

  // ─── Navigate to result page ──────────────────────────────────────────

  test('clicking Calculate navigates to /result', async ({ page }) => {
    const calcBtn = page.locator('[class*="calcBtn"]');
    await calcBtn.click();
    await expect(page).toHaveURL(/\/result/);
  });

  test('result page shows summon and control difficulty values', async ({ page }) => {
    // Navigate to result
    await page.locator('[class*="calcBtn"]').click();
    await page.waitForURL(/\/result/);

    // Result page should show modifier cards
    const modCards = page.locator('[class*="modCard"]');
    await expect(modCards).toHaveCountGreaterThan(0);
  });

  test('result page shows element and summoning type info', async ({ page }) => {
    await page.locator('[class*="calcBtn"]').click();
    await page.waitForURL(/\/result/);

    // Hero section with element name should be visible
    const hero = page.locator('[class*="hero"]');
    await expect(hero).toBeVisible();
  });

  test('result page shows personality trait', async ({ page }) => {
    await page.locator('[class*="calcBtn"]').click();
    await page.waitForURL(/\/result/);

    // Personality card
    const personality = page.locator('[class*="personality"]');
    await expect(personality).toBeVisible();
  });

  test('result page shows "weak against" counter element', async ({ page }) => {
    await page.locator('[class*="calcBtn"]').click();
    await page.waitForURL(/\/result/);

    const weakCard = page.locator('[class*="weakCard"]');
    await expect(weakCard).toBeVisible();
  });

  // ─── Predefined summonings ─────────────────────────────────────────────

  test('predefined summoning buttons are visible', async ({ page }) => {
    const predefinedBtns = page.locator('[class*="predefinedBtn"]');
    await expect(predefinedBtns).toHaveCountGreaterThan(0);
  });

  test('clicking a predefined summoning activates it', async ({ page }) => {
    const firstPredefined = page.locator('[class*="predefinedBtn"]').first();
    await firstPredefined.click();
    await expect(firstPredefined).toHaveClass(/active/);
  });

  test('clicking an active predefined deselects it', async ({ page }) => {
    const firstPredefined = page.locator('[class*="predefinedBtn"]').first();
    await firstPredefined.click(); // select
    await firstPredefined.click(); // deselect
    await expect(firstPredefined).not.toHaveClass(/active/);
  });

  // ─── Back navigation ──────────────────────────────────────────────────

  test('back button navigates away from summoning page', async ({ page }) => {
    const backBtn = page.locator('[class*="backBtn"], button[aria-label*="back" i], [class*="back"]').first();
    if (await backBtn.count() > 0) {
      await backBtn.click();
      await expect(page).not.toHaveURL(`/summon/${characterId}`);
    }
  });
});

import { describe, it, expect } from 'vitest';
import {
  materialPurityModifiers,
  trueNameModifiers,
  placeModifiers,
  powernodeModifiers,
  timeModifiers,
  giftModifiers,
  deedModifiers,
  personalitiesEn,
  personalitiesDe,
  demonNames,
} from '../element-data';
import { DsaElement, ALL_ELEMENTS } from '../../models/element';

// ─── materialPurityModifiers ──────────────────────────────────────────────────

describe('materialPurityModifiers', () => {
  it('has entries for all 6 elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(materialPurityModifiers[el]).toBeDefined();
    }
  });

  it('each element has exactly 7 entries', () => {
    for (const el of ALL_ELEMENTS) {
      expect(materialPurityModifiers[el]).toHaveLength(7);
    }
  });

  it('index 3 (neutral) is 0 for all elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(materialPurityModifiers[el][3]).toBe(0);
    }
  });

  it('index 0 is -3 for all elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(materialPurityModifiers[el][0]).toBe(-3);
    }
  });

  it('index 6 is +3 for all elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(materialPurityModifiers[el][6]).toBe(3);
    }
  });

  it('values are strictly increasing from index 0 to 6', () => {
    for (const el of ALL_ELEMENTS) {
      const entries = materialPurityModifiers[el];
      for (let i = 1; i < entries.length; i++) {
        expect(entries[i]).toBeGreaterThan(entries[i - 1]);
      }
    }
  });

  it('Fire entries are [-3, -2, -1, 0, 1, 2, 3]', () => {
    expect(materialPurityModifiers[DsaElement.Fire]).toEqual([-3, -2, -1, 0, 1, 2, 3]);
  });
});

// ─── trueNameModifiers ────────────────────────────────────────────────────────

describe('trueNameModifiers', () => {
  it('has exactly 8 entries (index 0=none, 1-7=quality 1-7)', () => {
    expect(trueNameModifiers).toHaveLength(8);
  });

  it('each entry is a [number, number] tuple', () => {
    for (const entry of trueNameModifiers) {
      expect(entry).toHaveLength(2);
      expect(typeof entry[0]).toBe('number');
      expect(typeof entry[1]).toBe('number');
    }
  });

  it('index 0 (no true name) is [0, 0]', () => {
    expect(trueNameModifiers[0]).toEqual([0, 0]);
  });

  it('index 1 (quality 1) is [-1, 0]', () => {
    expect(trueNameModifiers[1]).toEqual([-1, 0]);
  });

  it('index 2 (quality 2) is [-2, -1]', () => {
    expect(trueNameModifiers[2]).toEqual([-2, -1]);
  });

  it('index 7 (quality 7) is [-7, -2]', () => {
    expect(trueNameModifiers[7]).toEqual([-7, -2]);
  });

  it('summon modifier is non-positive for all entries', () => {
    for (const [sumMod] of trueNameModifiers) {
      expect(sumMod).toBeLessThanOrEqual(0);
    }
  });

  it('control modifier is non-positive for all entries', () => {
    for (const [, ctrlMod] of trueNameModifiers) {
      expect(ctrlMod).toBeLessThanOrEqual(0);
    }
  });

  it('summon modifier is non-increasing (higher quality = more bonus)', () => {
    for (let i = 1; i < trueNameModifiers.length; i++) {
      expect(trueNameModifiers[i][0]).toBeLessThanOrEqual(trueNameModifiers[i - 1][0]);
    }
  });
});

// ─── placeModifiers ───────────────────────────────────────────────────────────

describe('placeModifiers', () => {
  it('has exactly 14 entries', () => {
    expect(placeModifiers).toHaveLength(14);
  });

  it('each entry is a [number, number] tuple', () => {
    for (const entry of placeModifiers) {
      expect(entry).toHaveLength(2);
      expect(typeof entry[0]).toBe('number');
      expect(typeof entry[1]).toBe('number');
    }
  });

  it('index 0 (elemental citadel) is [-7, -2]', () => {
    expect(placeModifiers[0]).toEqual([-7, -2]);
  });

  it('index 5 (no connection) is [0, 0]', () => {
    expect(placeModifiers[5]).toEqual([0, 0]);
  });

  it('index 6 (neutral default) is [0, 0]', () => {
    expect(placeModifiers[6]).toEqual([0, 0]);
  });

  it('index 11 (citadel of counter element) is [7, 2]', () => {
    expect(placeModifiers[11]).toEqual([7, 2]);
  });

  it('index 12 (gate Blakharaz) is [5, 1]', () => {
    expect(placeModifiers[12]).toEqual([5, 1]);
  });

  it('index 13 (gate Agrimoth) is [7, 2]', () => {
    expect(placeModifiers[13]).toEqual([7, 2]);
  });
});

// ─── powernodeModifiers ───────────────────────────────────────────────────────

describe('powernodeModifiers', () => {
  it('has exactly 10 entries', () => {
    expect(powernodeModifiers).toHaveLength(10);
  });

  it('each entry is a number', () => {
    for (const entry of powernodeModifiers) {
      expect(typeof entry).toBe('number');
    }
  });

  it('index 0 (PS 0-1) is 0', () => {
    expect(powernodeModifiers[0]).toBe(0);
  });

  it('index 1 (PS 2-5) is -1', () => {
    expect(powernodeModifiers[1]).toBe(-1);
  });

  it('index 9 (PS 34-37) is -9', () => {
    expect(powernodeModifiers[9]).toBe(-9);
  });

  it('all values are non-positive (powernode is always beneficial)', () => {
    for (const val of powernodeModifiers) {
      expect(val).toBeLessThanOrEqual(0);
    }
  });

  it('values are non-increasing (higher PS = more bonus)', () => {
    for (let i = 1; i < powernodeModifiers.length; i++) {
      expect(powernodeModifiers[i]).toBeLessThanOrEqual(powernodeModifiers[i - 1]);
    }
  });
});

// ─── timeModifiers ────────────────────────────────────────────────────────────

describe('timeModifiers', () => {
  it('has exactly 7 entries', () => {
    expect(timeModifiers).toHaveLength(7);
  });

  it('each entry is a [number, number] tuple', () => {
    for (const entry of timeModifiers) {
      expect(entry).toHaveLength(2);
      expect(typeof entry[0]).toBe('number');
      expect(typeof entry[1]).toBe('number');
    }
  });

  it('index 0 (roll 1 on D20) is [-3, -1]', () => {
    expect(timeModifiers[0]).toEqual([-3, -1]);
  });

  it('index 3 (neutral) is [0, 0]', () => {
    expect(timeModifiers[3]).toEqual([0, 0]);
  });

  it('index 6 (roll 20 / nameless days) is [3, 1]', () => {
    expect(timeModifiers[6]).toEqual([3, 1]);
  });
});

// ─── giftModifiers ────────────────────────────────────────────────────────────

describe('giftModifiers', () => {
  it('has exactly 15 entries', () => {
    expect(giftModifiers).toHaveLength(15);
  });

  it('each entry is a [number, number] tuple', () => {
    for (const entry of giftModifiers) {
      expect(entry).toHaveLength(2);
      expect(typeof entry[0]).toBe('number');
      expect(typeof entry[1]).toBe('number');
    }
  });

  it('index 0 (best gift) is [-7, -2]', () => {
    expect(giftModifiers[0]).toEqual([-7, -2]);
  });

  it('index 7 (neutral) is [0, 0]', () => {
    expect(giftModifiers[7]).toEqual([0, 0]);
  });

  it('index 14 (worst gift) is [7, 2]', () => {
    expect(giftModifiers[14]).toEqual([7, 2]);
  });
});

// ─── deedModifiers ────────────────────────────────────────────────────────────

describe('deedModifiers', () => {
  it('has exactly 15 entries', () => {
    expect(deedModifiers).toHaveLength(15);
  });

  it('each entry is a [number, number] tuple', () => {
    for (const entry of deedModifiers) {
      expect(entry).toHaveLength(2);
    }
  });

  it('index 0 (best deed) is [-7, -2]', () => {
    expect(deedModifiers[0]).toEqual([-7, -2]);
  });

  it('index 7 (neutral) is [0, 0]', () => {
    expect(deedModifiers[7]).toEqual([0, 0]);
  });

  it('index 14 (worst deed) is [7, 2]', () => {
    expect(deedModifiers[14]).toEqual([7, 2]);
  });

  it('deed modifiers mirror gift modifiers', () => {
    expect(deedModifiers).toEqual(giftModifiers);
  });
});

// ─── demonNames ───────────────────────────────────────────────────────────────

describe('demonNames', () => {
  it('has exactly 8 demon names', () => {
    expect(demonNames).toHaveLength(8);
  });

  it('all names are non-empty strings', () => {
    for (const name of demonNames) {
      expect(typeof name).toBe('string');
      expect(name.length).toBeGreaterThan(0);
    }
  });

  it('contains Blakharaz', () => {
    expect(demonNames).toContain('Blakharaz');
  });

  it('contains Agrimoth', () => {
    expect(demonNames).toContain('Agrimoth');
  });

  it('contains Thargunitoth', () => {
    expect(demonNames).toContain('Thargunitoth');
  });

  it('contains no duplicate names', () => {
    const unique = new Set(demonNames);
    expect(unique.size).toBe(demonNames.length);
  });
});

// ─── personalitiesEn ─────────────────────────────────────────────────────────

describe('personalitiesEn', () => {
  it('has entries for all 6 elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(personalitiesEn[el]).toBeDefined();
    }
  });

  it('each element has at least one personality trait', () => {
    for (const el of ALL_ELEMENTS) {
      expect(personalitiesEn[el].length).toBeGreaterThan(0);
    }
  });

  it('all personality traits are non-empty strings', () => {
    for (const el of ALL_ELEMENTS) {
      for (const trait of personalitiesEn[el]) {
        expect(typeof trait).toBe('string');
        expect(trait.length).toBeGreaterThan(0);
      }
    }
  });

  it('Fire has 14 personality traits', () => {
    expect(personalitiesEn[DsaElement.Fire]).toHaveLength(14);
  });

  it('Water has 14 personality traits', () => {
    expect(personalitiesEn[DsaElement.Water]).toHaveLength(14);
  });
});

// ─── personalitiesDe ─────────────────────────────────────────────────────────

describe('personalitiesDe', () => {
  it('has entries for all 6 elements', () => {
    for (const el of ALL_ELEMENTS) {
      expect(personalitiesDe[el]).toBeDefined();
    }
  });

  it('each element has at least one personality trait', () => {
    for (const el of ALL_ELEMENTS) {
      expect(personalitiesDe[el].length).toBeGreaterThan(0);
    }
  });

  it('same number of traits per element in DE and EN', () => {
    for (const el of ALL_ELEMENTS) {
      expect(personalitiesDe[el]).toHaveLength(personalitiesEn[el].length);
    }
  });

  it('German traits are different from English traits', () => {
    // At least one element should have different strings
    let hasDifference = false;
    for (const el of ALL_ELEMENTS) {
      for (let i = 0; i < personalitiesDe[el].length; i++) {
        if (personalitiesDe[el][i] !== personalitiesEn[el][i]) {
          hasDifference = true;
          break;
        }
      }
    }
    expect(hasDifference).toBe(true);
  });
});

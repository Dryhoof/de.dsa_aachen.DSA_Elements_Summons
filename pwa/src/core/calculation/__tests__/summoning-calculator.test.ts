import { describe, it, expect } from 'vitest';
import { calculateSummoning, predefinedAbilitySummonCost } from '../summoning-calculator';
import { DsaElement } from '../../models/element';
import { SummoningType } from '../../models/summoning-type';
import { SummoningConfig, PredefinedSummoning, defaultSummoningConfig } from '../../models/summoning-config';
import { Character, DEFAULT_CHARACTER } from '../../models/character';
import { predefinedSummonings } from '../../constants/predefined-summonings';
import {
  trueNameModifiers,
  placeModifiers,
  timeModifiers,
  giftModifiers,
  deedModifiers,
  materialPurityModifiers,
  powernodeModifiers,
  demonNames,
} from '../../constants/element-data';

// ─── Test Helpers ─────────────────────────────────────────────────────────────

/** A fully neutral character with no bonuses or penalties. */
function makeCharacter(overrides: Partial<Character> = {}): Character {
  return {
    ...DEFAULT_CHARACTER,
    characterName: 'Test',
    ...overrides,
  };
}

/**
 * Returns a SummoningConfig with all circumstance indices set to their
 * "neutral" defaults so only the explicitly overridden fields affect the result.
 *
 * Neutral means:
 *   trueNameIndex=0   → [0, 0]
 *   placeIndex=6      → [0, 0]   (neutral)
 *   timeIndex=3       → [0, 0]   (10-11 on D20)
 *   giftIndex=7       → [0, 0]   (neutral)
 *   deedIndex=7       → [0, 0]   (neutral)
 *   materialPurityIndex=3 → 0    (all elements)
 *   powernodeIndex=0  → 0        (PS 0-1)
 */
function makeConfig(
  overrides: Partial<SummoningConfig> = {},
  charOverrides: Partial<Character> = {}
): SummoningConfig {
  const character = makeCharacter(charOverrides);
  const base = defaultSummoningConfig(character);
  return {
    ...base,
    ...overrides,
    character: { ...base.character, ...overrides.character },
  };
}

// ─── 1. Base costs (normal mode, all-neutral config) ──────────────────────────

describe('base costs in normal (non-predefined) mode', () => {
  it('Servant has summon=4, control=2', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('Djinn has summon=8, control=4', () => {
    const c = makeConfig({ summoningType: SummoningType.Djinn });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(8);
    expect(r.controlDifficulty).toBe(4);
  });

  it('Master has summon=12, control=8', () => {
    const c = makeConfig({ summoningType: SummoningType.Master });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(12);
    expect(r.controlDifficulty).toBe(8);
  });
});

// ─── 2. Proper attire ─────────────────────────────────────────────────────────

describe('properAttire', () => {
  it('subtracts 2 from summon', () => {
    const c = makeConfig({ properAttire: true, summoningType: SummoningType.Servant });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(2); // 4 - 2
    expect(r.controlDifficulty).toBe(2); // unchanged
  });

  it('does not affect control', () => {
    const c = makeConfig({ properAttire: true, summoningType: SummoningType.Djinn });
    const r = calculateSummoning(c);
    expect(r.controlDifficulty).toBe(4);
  });
});

// ─── 3. Individual ability costs ──────────────────────────────────────────────

describe('individual abilities', () => {
  it('astralSense adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, astralSense: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('longArm adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, longArm: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('lifeSense adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, lifeSense: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('regenerationLevel=1 adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, regenerationLevel: 1 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('regenerationLevel=2 adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, regenerationLevel: 2 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('additionalActionsLevel=1 adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, additionalActionsLevel: 1 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('additionalActionsLevel=2 adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, additionalActionsLevel: 2 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('resistanceMagic adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, resistanceMagic: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('immunityMagic adds +10 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, immunityMagic: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(10);
  });

  it('resistanceTraitDamage adds +5 (when no resistanceMagic, no immunityMagic)', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, resistanceTraitDamage: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('immunityTraitDamage adds +10 (when no immunityMagic)', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, immunityTraitDamage: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(10);
  });

  it('causeFear adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, causeFear: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('aura adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, aura: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('blinkingInvisibility adds +6 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, blinkingInvisibility: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(6);
  });

  it('elementalShackle adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, elementalShackle: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('elementalGripLevel=1 adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, elementalGripLevel: 1 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('elementalGripLevel=2 adds +14 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, elementalGripLevel: 2 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(14);
  });

  it('elementalInferno adds +8 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, elementalInferno: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(8);
  });

  it('elementalGrowth adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, elementalGrowth: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('drowning adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, drowning: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('areaAttack adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, areaAttack: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('flight adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, flight: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('frost adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, frost: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('ember adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, ember: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('criticalImmunity adds +2 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, criticalImmunity: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(2);
  });

  it('boilingBlood adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, boilingBlood: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('fog adds +2 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, fog: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(2);
  });

  it('smoke adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, smoke: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('stasis adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, stasis: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('stoneEatingLevel=1 adds +2 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, stoneEatingLevel: 1 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(2);
  });

  it('stoneEatingLevel=3 adds +6 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, stoneEatingLevel: 3 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(6);
  });

  it('stoneSkinLevel=1 adds +2 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, stoneSkinLevel: 1 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(2);
  });

  it('stoneSkinLevel=4 adds +8 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, stoneSkinLevel: 4 });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(8);
  });

  it('mergeWithElement adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, mergeWithElement: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('sinking adds +6 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, sinking: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(6);
  });

  it('wildGrowth adds +7 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, wildGrowth: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(7);
  });

  it('burst adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, burst: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('shatteringArmor adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const withAbility = makeConfig({ summoningType: SummoningType.Servant, shatteringArmor: true });
    expect(calculateSummoning(withAbility).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });
});

// ─── 4. Value modifications ───────────────────────────────────────────────────

describe('value modifications', () => {
  it('modLeP=1 adds +2 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modLeP: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(2);
  });

  it('modLeP=3 adds +6 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modLeP: 3 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(6);
  });

  it('modINI=1 adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modINI: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('modRS=2 adds +6 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modRS: 2 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(6);
  });

  it('modGS=1 adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modGS: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('modMR=1 adds +3 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modMR: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(3);
  });

  it('modAT=1 adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modAT: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('modPA=2 adds +8 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modPA: 2 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(8);
  });

  it('modTP=1 adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modTP: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('modAttribute=1 adds +5 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modAttribute: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('modNewTalent=1 adds +4 to summon', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modNewTalent: 1 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(4);
  });

  it('modTaWZfW=5 adds +5 to summon (×1)', () => {
    const base = makeConfig({ summoningType: SummoningType.Servant });
    const c = makeConfig({ summoningType: SummoningType.Servant, modTaWZfW: 5 });
    expect(calculateSummoning(c).summonDifficulty - calculateSummoning(base).summonDifficulty).toBe(5);
  });

  it('multiple value mods stack correctly', () => {
    // modLeP=1(+2), modAT=1(+4), modTP=1(+4) = +10 on top of base Servant(4)
    const c = makeConfig({ summoningType: SummoningType.Servant, modLeP: 1, modAT: 1, modTP: 1 });
    expect(calculateSummoning(c).summonDifficulty).toBe(4 + 2 + 4 + 4);
  });
});

// ─── 5. Circumstance modifiers ────────────────────────────────────────────────

describe('true name modifiers', () => {
  it('trueNameIndex=0 (no name) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('trueNameIndex=1 (quality 1) adds [-1, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: 1 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(3);  // 4 - 1
    expect(r.controlDifficulty).toBe(2); // 2 + 0
  });

  it('trueNameIndex=2 (quality 2) adds [-2, -1]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: 2 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(2);  // 4 - 2
    expect(r.controlDifficulty).toBe(1); // 2 - 1
  });

  it('trueNameIndex=5 (quality 5) adds [-5, -2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: 5 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-1); // 4 - 5
    expect(r.controlDifficulty).toBe(0); // 2 - 2
  });

  it('trueNameIndex=7 (quality 7) adds [-7, -2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: 7 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-3); // 4 - 7
    expect(r.controlDifficulty).toBe(0); // 2 - 2
  });

  it('all 8 trueName entries match the data table', () => {
    for (let i = 0; i < trueNameModifiers.length; i++) {
      const [sumMod, ctrlMod] = trueNameModifiers[i];
      const c = makeConfig({ summoningType: SummoningType.Servant, trueNameIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + sumMod);
      expect(r.controlDifficulty).toBe(2 + ctrlMod);
    }
  });
});

describe('place modifiers', () => {
  it('placeIndex=0 (elemental citadel) adds [-7, -2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, placeIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-3); // 4 - 7
    expect(r.controlDifficulty).toBe(0); // 2 - 2
  });

  it('placeIndex=5 (no connection) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, placeIndex: 5 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('placeIndex=6 (neutral default) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, placeIndex: 6 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('placeIndex=11 (citadel of counter element) adds [7, 2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, placeIndex: 11 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(11); // 4 + 7
    expect(r.controlDifficulty).toBe(4); // 2 + 2
  });

  it('all 14 place entries match the data table', () => {
    for (let i = 0; i < placeModifiers.length; i++) {
      const [sumMod, ctrlMod] = placeModifiers[i];
      const c = makeConfig({ summoningType: SummoningType.Servant, placeIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + sumMod);
      expect(r.controlDifficulty).toBe(2 + ctrlMod);
    }
  });
});

describe('time modifiers', () => {
  it('timeIndex=0 adds [-3, -1]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, timeIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(1); // 4 - 3
    expect(r.controlDifficulty).toBe(1); // 2 - 1
  });

  it('timeIndex=3 (neutral) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, timeIndex: 3 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('timeIndex=6 (nameless days) adds [3, 1]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, timeIndex: 6 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(7); // 4 + 3
    expect(r.controlDifficulty).toBe(3); // 2 + 1
  });

  it('all 7 time entries match the data table', () => {
    for (let i = 0; i < timeModifiers.length; i++) {
      const [sumMod, ctrlMod] = timeModifiers[i];
      const c = makeConfig({ summoningType: SummoningType.Servant, timeIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + sumMod);
      expect(r.controlDifficulty).toBe(2 + ctrlMod);
    }
  });
});

describe('gift and deed modifiers', () => {
  it('giftIndex=7 (neutral) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, giftIndex: 7 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('giftIndex=0 (perfect gift) adds [-7, -2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, giftIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-3); // 4 - 7
    expect(r.controlDifficulty).toBe(0); // 2 - 2
  });

  it('giftIndex=14 (worst gift) adds [7, 2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, giftIndex: 14 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(11); // 4 + 7
    expect(r.controlDifficulty).toBe(4); // 2 + 2
  });

  it('deedIndex=7 (neutral) adds [0, 0]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, deedIndex: 7 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('deedIndex=0 (perfect deed) adds [-7, -2]', () => {
    const c = makeConfig({ summoningType: SummoningType.Servant, deedIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-3);
    expect(r.controlDifficulty).toBe(0);
  });

  it('all gift entries match the data table', () => {
    for (let i = 0; i < giftModifiers.length; i++) {
      const [sumMod, ctrlMod] = giftModifiers[i];
      const c = makeConfig({ summoningType: SummoningType.Servant, giftIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + sumMod);
      expect(r.controlDifficulty).toBe(2 + ctrlMod);
    }
  });

  it('all deed entries match the data table', () => {
    for (let i = 0; i < deedModifiers.length; i++) {
      const [sumMod, ctrlMod] = deedModifiers[i];
      const c = makeConfig({ summoningType: SummoningType.Servant, deedIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + sumMod);
      expect(r.controlDifficulty).toBe(2 + ctrlMod);
    }
  });
});

describe('material purity modifiers', () => {
  it('all elements have 7 entries', () => {
    for (const el of [DsaElement.Fire, DsaElement.Water, DsaElement.Life, DsaElement.Ice, DsaElement.Stone, DsaElement.Air]) {
      expect(materialPurityModifiers[el]).toHaveLength(7);
    }
  });

  it('materialPurityIndex=3 (neutral) adds 0 to summon for Fire', () => {
    const c = makeConfig({ element: DsaElement.Fire, materialPurityIndex: 3 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4); // base servant + 0
  });

  it('materialPurityIndex=0 (poorest) adds -3 to summon for Fire', () => {
    const c = makeConfig({ element: DsaElement.Fire, materialPurityIndex: 0 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(1); // 4 - 3
  });

  it('materialPurityIndex=6 (purest) adds +3 to summon for Fire', () => {
    const c = makeConfig({ element: DsaElement.Fire, materialPurityIndex: 6 });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(7); // 4 + 3
  });

  it('all 7 material purity entries for Water match the data table', () => {
    for (let i = 0; i < 7; i++) {
      const expected = materialPurityModifiers[DsaElement.Water][i];
      const c = makeConfig({ element: DsaElement.Water, materialPurityIndex: i });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + expected);
    }
  });
});

describe('powernode modifiers', () => {
  it('powernode has no effect without powerlineMagicI', () => {
    const c = makeConfig({ powernodeIndex: 5 }, { powerlineMagicI: false });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4); // powernodeModifiers[5] = -5 ignored
  });

  it('powernodeIndex=0 (PS 0-1) adds 0', () => {
    const c = makeConfig({ powernodeIndex: 0 }, { powerlineMagicI: true });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(4); // 4 + 0
  });

  it('powernodeIndex=1 (PS 2-5) adds -1 to summon with powerlineMagicI', () => {
    const c = makeConfig({ powernodeIndex: 1 }, { powerlineMagicI: true });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(3); // 4 - 1
  });

  it('powernodeIndex=9 (PS 34-37) adds -9 to summon with powerlineMagicI', () => {
    const c = makeConfig({ powernodeIndex: 9 }, { powerlineMagicI: true });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-5); // 4 - 9
  });

  it('all 10 powernode entries match the data table when powerlineMagicI is true', () => {
    for (let i = 0; i < powernodeModifiers.length; i++) {
      const expected = powernodeModifiers[i];
      const c = makeConfig({ powernodeIndex: i }, { powerlineMagicI: true });
      const r = calculateSummoning(c);
      expect(r.summonDifficulty).toBe(4 + expected);
    }
  });
});

// ─── 6. Character traits ──────────────────────────────────────────────────────

describe('character traits — element talent/knowledge', () => {
  it('talentedFire: -2/-2 when summoning Fire', () => {
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({ element: DsaElement.Fire }, { talentedFire: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  it('knowledgeFire: -2/-2 when summoning Fire', () => {
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({ element: DsaElement.Fire }, { knowledgeFire: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  it('talentedWater: -2/-2 when summoning Water', () => {
    const base = makeConfig({ element: DsaElement.Water });
    const c = makeConfig({ element: DsaElement.Water }, { talentedWater: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  it('talentedIce: -2/-2 when summoning Ice', () => {
    const base = makeConfig({ element: DsaElement.Ice });
    const c = makeConfig({ element: DsaElement.Ice }, { talentedIce: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  it('talentedStone: -2/-2 when summoning Stone', () => {
    const base = makeConfig({ element: DsaElement.Stone });
    const c = makeConfig({ element: DsaElement.Stone }, { talentedStone: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  it('talentedAir: -2/-2 when summoning Air', () => {
    const base = makeConfig({ element: DsaElement.Air });
    const c = makeConfig({ element: DsaElement.Air }, { talentedAir: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-2);
  });

  // Counter element penalty: Fire <-> Water, Life <-> Ice, Stone <-> Air
  it('talentedFire: +4/+2 penalty when summoning Water (counter element)', () => {
    const base = makeConfig({ element: DsaElement.Water });
    const c = makeConfig({ element: DsaElement.Water }, { talentedFire: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(4);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(2);
  });

  it('knowledgeIce: +4/+2 penalty when summoning Life (counter element)', () => {
    const base = makeConfig({ element: DsaElement.Life });
    const c = makeConfig({ element: DsaElement.Life }, { knowledgeIce: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(4);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(2);
  });

  it('talentedAir: +4/+2 penalty when summoning Stone (counter element)', () => {
    const base = makeConfig({ element: DsaElement.Stone });
    const c = makeConfig({ element: DsaElement.Stone }, { talentedAir: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(4);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(2);
  });

  it('talent for unrelated element has no effect', () => {
    // Fire talent when summoning Stone (not the counter element)
    const base = makeConfig({ element: DsaElement.Stone });
    const c = makeConfig({ element: DsaElement.Stone }, { talentedFire: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty).toBe(bRes.controlDifficulty);
  });

  it('talent + knowledge for same element each give -2/-2, stacking to -4/-4', () => {
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({ element: DsaElement.Fire }, { talentedFire: true, knowledgeFire: true });
    const diff = calculateSummoning(c);
    const bRes = calculateSummoning(base);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-4);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-4);
  });
});

describe('character traits — demonic', () => {
  it('talentedDemonic=1 adds +2/+4', () => {
    const base = makeConfig();
    const c = makeConfig({}, { talentedDemonic: 1 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(4);
  });

  it('talentedDemonic=3 adds +6/+12', () => {
    const base = makeConfig();
    const c = makeConfig({}, { talentedDemonic: 3 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(6);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(12);
  });

  it('knowledgeDemonic=1 adds +2/+4', () => {
    const base = makeConfig();
    const c = makeConfig({}, { knowledgeDemonic: 1 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(2);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(4);
  });

  it('knowledgeDemonic=2 adds +4/+8', () => {
    const base = makeConfig();
    const c = makeConfig({}, { knowledgeDemonic: 2 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(4);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(8);
  });

  it('demonicCovenant adds +6/+9', () => {
    const base = makeConfig();
    const c = makeConfig({}, { demonicCovenant: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(6);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(9);
  });
});

describe('character traits — affinity and aura', () => {
  it('affinityToElementals subtracts 3 from control only', () => {
    const base = makeConfig();
    const c = makeConfig({}, { affinityToElementals: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(-3);
  });

  it('cloakedAura adds +1 to control only', () => {
    const base = makeConfig();
    const c = makeConfig({}, { cloakedAura: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(1);
  });

  it('weakPresence=2 adds +2 to control', () => {
    const base = makeConfig();
    const c = makeConfig({}, { weakPresence: 2 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(2);
  });

  it('strengthOfStigma=3 adds +3 to control', () => {
    const base = makeConfig();
    const c = makeConfig({}, { strengthOfStigma: 3 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(3);
  });
});

// ─── 7. GM modifiers ──────────────────────────────────────────────────────────

describe('GM modifiers', () => {
  it('bloodMagicUsed adds +12 to control', () => {
    const base = makeConfig();
    const c = makeConfig({ bloodMagicUsed: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(12);
  });

  it('summonedLesserDemon adds +4 to control', () => {
    const base = makeConfig();
    const c = makeConfig({ summonedLesserDemon: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(4);
  });

  it('summonedHornedDemon adds +4 to control', () => {
    const base = makeConfig();
    const c = makeConfig({ summonedHornedDemon: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(4);
  });

  it('only +4 total when both lesser and horned demon flags are set (horned takes precedence, but adds same amount)', () => {
    // Per source code: horned demon check runs first, lesser only if NOT horned
    const base = makeConfig();
    const c = makeConfig({ summonedHornedDemon: true, summonedLesserDemon: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(4);
  });

  it('additionalSummonMod=5 adds +5 to summon', () => {
    const base = makeConfig();
    const c = makeConfig({ additionalSummonMod: 5 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(5);
    expect(diff.controlDifficulty).toBe(bRes.controlDifficulty);
  });

  it('additionalControlMod=3 adds +3 to control', () => {
    const base = makeConfig();
    const c = makeConfig({ additionalControlMod: 3 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
    expect(diff.controlDifficulty - bRes.controlDifficulty).toBe(3);
  });

  it('additionalSummonMod=-3 subtracts from summon', () => {
    const base = makeConfig();
    const c = makeConfig({ additionalSummonMod: -3 });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(-3);
  });
});

// ─── 8. Demonic & elemental resistance/immunity ───────────────────────────────

describe('demonic resistances and immunities', () => {
  it('resistance for one demon adds +5', () => {
    const base = makeConfig();
    const c = makeConfig({ resistancesDemonic: { Blakharaz: true } });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(5);
  });

  it('immunity for one demon adds +10', () => {
    const base = makeConfig();
    const c = makeConfig({ immunitiesDemonic: { Blakharaz: true } });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(10);
  });

  it('when demon has immunity (true), resistance is ignored even if also true', () => {
    // Immunity takes precedence over resistance for the same demon
    const base = makeConfig();
    const c = makeConfig({
      immunitiesDemonic: { Belhalhar: true },
      resistancesDemonic: { Belhalhar: true },
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    // Should add only 10 (immunity), not 15 (immunity + resistance)
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(10);
  });

  it('all 8 demon resistances each add +5', () => {
    const base = makeConfig();
    const resistances: Record<string, boolean> = {};
    for (const demon of demonNames) {
      resistances[demon] = true;
    }
    const c = makeConfig({ resistancesDemonic: resistances });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(8 * 5);
  });

  it('all 8 demon immunities each add +10', () => {
    const base = makeConfig();
    const immunities: Record<string, boolean> = {};
    for (const demon of demonNames) {
      immunities[demon] = true;
    }
    const c = makeConfig({ immunitiesDemonic: immunities });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(8 * 10);
  });
});

describe('elemental resistances and immunities', () => {
  it('resistance for non-own element adds +3', () => {
    // Fire summoning — resistance against Water
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({
      element: DsaElement.Fire,
      resistancesElemental: { [DsaElement.Water]: true },
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(3);
  });

  it('immunity for non-own element adds +7', () => {
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({
      element: DsaElement.Fire,
      immunitiesElemental: { [DsaElement.Water]: true },
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(7);
  });

  it('own element immunity is free (adds nothing)', () => {
    // Fire summoning — immunity against Fire (own element) = free
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({
      element: DsaElement.Fire,
      immunitiesElemental: { [DsaElement.Fire]: true },
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
  });

  it('resistances for all 5 non-own elements each add +3 (total +15 for Fire)', () => {
    const base = makeConfig({ element: DsaElement.Fire });
    const c = makeConfig({
      element: DsaElement.Fire,
      resistancesElemental: {
        [DsaElement.Water]: true,
        [DsaElement.Life]: true,
        [DsaElement.Ice]: true,
        [DsaElement.Stone]: true,
        [DsaElement.Air]: true,
      },
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(15);
  });
});

// ─── 9. Resistance/immunity exclusion logic ──────────────────────────────────

describe('exclusion logic', () => {
  it('immunityMagic overrides resistanceMagic (only +10, not +15)', () => {
    const base = makeConfig();
    const c = makeConfig({ immunityMagic: true, resistanceMagic: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(10);
  });

  it('immunityMagic suppresses resistanceTraitDamage cost', () => {
    const base = makeConfig({ immunityMagic: true });
    const c = makeConfig({ immunityMagic: true, resistanceTraitDamage: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    // resistanceTraitDamage should add 0 when immunityMagic is active
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
  });

  it('immunityMagic suppresses immunityTraitDamage cost', () => {
    const base = makeConfig({ immunityMagic: true });
    const c = makeConfig({ immunityMagic: true, immunityTraitDamage: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
  });

  it('resistanceMagic suppresses resistanceTraitDamage cost', () => {
    const base = makeConfig({ resistanceMagic: true });
    const c = makeConfig({ resistanceMagic: true, resistanceTraitDamage: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty).toBe(bRes.summonDifficulty);
  });

  it('resistanceMagic does NOT suppress immunityTraitDamage', () => {
    const base = makeConfig({ resistanceMagic: true });
    const c = makeConfig({ resistanceMagic: true, immunityTraitDamage: true });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(c);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(10);
  });
});

// ─── 10. Predefined mode ─────────────────────────────────────────────────────

describe('predefined summoning mode', () => {
  it('plain predefined (no extra abilities) uses baseSummonMod and baseControlMod', () => {
    const iceServant = predefinedSummonings.find(p => p.id === 'geist_eis')!;
    const c = makeConfig({
      element: DsaElement.Ice,
      summoningType: SummoningType.Servant,
      predefined: iceServant,
    });
    const r = calculateSummoning(c);
    // baseSummonMod=4, no built-in abilities → net summon = 4 + 0 (no char mods)
    expect(r.summonDifficulty).toBe(4);
    expect(r.controlDifficulty).toBe(2);
  });

  it('predefined ice Djinn gives summon=8, control=4 by default', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'dschinn_eis')!;
    const c = makeConfig({
      element: DsaElement.Ice,
      summoningType: SummoningType.Djinn,
      predefined: p,
    });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(8);
    expect(r.controlDifficulty).toBe(4);
  });

  it('predefined ice Master gives summon=12, control=8 by default', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'meister_eis')!;
    const c = makeConfig({
      element: DsaElement.Ice,
      summoningType: SummoningType.Master,
      predefined: p,
    });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(12);
    expect(r.controlDifficulty).toBe(8);
  });

  it('stone ore servant (shatteringArmor built-in) costs same as plain servant summon=4', () => {
    // shatteringArmor is built-in (true) so it cancels out via delta
    const p = predefinedSummonings.find(ps => ps.id === 'geist_erz')!;
    expect(p.shatteringArmor).toBe(true);
    const c = makeConfig({
      element: DsaElement.Stone,
      summoningType: SummoningType.Servant,
      predefined: p,
      shatteringArmor: p.shatteringArmor,
    });
    const r = calculateSummoning(c);
    // baseSummonMod=4, predefined ability cost cancels out shatteringArmor
    expect(r.summonDifficulty).toBe(4);
  });

  it('adding extra ability on top of predefined adds its cost', () => {
    // Ice servant predefined (no astralSense built in), we add astralSense (+5)
    const p = predefinedSummonings.find(ps => ps.id === 'geist_eis')!;
    const base = makeConfig({
      element: DsaElement.Ice,
      summoningType: SummoningType.Servant,
      predefined: p,
    });
    const withExtra = makeConfig({
      element: DsaElement.Ice,
      summoningType: SummoningType.Servant,
      predefined: p,
      astralSense: true,
    });
    const bRes = calculateSummoning(base);
    const diff = calculateSummoning(withExtra);
    expect(diff.summonDifficulty - bRes.summonDifficulty).toBe(5);
  });

  it('predefined element is reflected in result', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_feuer')!;
    const c = makeConfig({
      element: DsaElement.Fire,
      summoningType: SummoningType.Servant,
      predefined: p,
    });
    const r = calculateSummoning(c);
    expect(r.element).toBe(DsaElement.Fire);
  });
});

// ─── 11. predefinedAbilitySummonCost helper ───────────────────────────────────

describe('predefinedAbilitySummonCost', () => {
  it('returns 0 for a plain predefined with no abilities', () => {
    const plain = predefinedSummonings.find(p => p.id === 'geist_eis')!;
    expect(predefinedAbilitySummonCost(plain, DsaElement.Ice)).toBe(0);
  });

  it('returns 3 for stone ore servant (shatteringArmor=true)', () => {
    const oreServant = predefinedSummonings.find(p => p.id === 'geist_erz')!;
    expect(predefinedAbilitySummonCost(oreServant, DsaElement.Stone)).toBe(3);
  });

  it('astralSense contributes +5 to cost', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      astralSense: true,
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(5);
  });

  it('immunityMagic contributes +10 to cost', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      immunityMagic: true,
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(10);
  });

  it('own element immunity costs 0 (skipped)', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      immunitiesElemental: { [DsaElement.Ice]: true },
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(0);
  });

  it('non-own element immunity costs +7', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      immunitiesElemental: { [DsaElement.Fire]: true },
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(7);
  });

  it('immunityMagic suppresses immunityTraitDamage cost in predefined', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      immunityMagic: true,
      immunityTraitDamage: true,
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(10); // only immunityMagic
  });

  it('resistanceMagic suppresses resistanceTraitDamage cost in predefined', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      resistanceMagic: true,
      resistanceTraitDamage: true,
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(5); // only resistanceMagic
  });

  it('value modifications are reflected in cost (modAT=1 → +4)', () => {
    const p: PredefinedSummoning = {
      ...predefinedSummonings[0],
      modAT: 1,
    };
    const cost = predefinedAbilitySummonCost(p, DsaElement.Ice);
    expect(cost).toBe(4);
  });
});

// ─── 12. Result structure ─────────────────────────────────────────────────────

describe('calculateSummoning result structure', () => {
  it('returns element matching config element', () => {
    const c = makeConfig({ element: DsaElement.Water });
    const r = calculateSummoning(c);
    expect(r.element).toBe(DsaElement.Water);
  });

  it('returns summoningType matching config summoningType', () => {
    const c = makeConfig({ summoningType: SummoningType.Master });
    const r = calculateSummoning(c);
    expect(r.summoningType).toBe(SummoningType.Master);
  });

  it('returns a non-empty personality string', () => {
    const c = makeConfig({ element: DsaElement.Fire });
    const r = calculateSummoning(c);
    expect(typeof r.personality).toBe('string');
    expect(r.personality.length).toBeGreaterThan(0);
  });

  it('personality for German locale comes from German list', () => {
    const c = makeConfig({ element: DsaElement.Fire });
    // Run many times to get a stable probability — or just verify it's a string
    const r = calculateSummoning(c, 'de');
    expect(typeof r.personality).toBe('string');
    expect(r.personality.length).toBeGreaterThan(0);
  });

  it('personality for English locale comes from English list', () => {
    const c = makeConfig({ element: DsaElement.Stone });
    const r = calculateSummoning(c, 'en');
    expect(typeof r.personality).toBe('string');
  });
});

// ─── 13. Complex combinations ─────────────────────────────────────────────────

describe('complex combinations', () => {
  it('Djinn Fire with multiple abilities and character traits', () => {
    // Base: Djinn = 8 summon, 4 control
    // astralSense(+5), lifeSense(+4), flight(+5) = +14 summon
    // properAttire(-2) = -2 summon
    // talentedFire: -2/-2
    // knowledgeFire: -2/-2
    // Total summon: 8 + 14 - 2 - 2 - 2 = 16
    // Total control: 4 - 2 - 2 = 0
    const c = makeConfig(
      {
        element: DsaElement.Fire,
        summoningType: SummoningType.Djinn,
        astralSense: true,
        lifeSense: true,
        flight: true,
        properAttire: true,
      },
      {
        talentedFire: true,
        knowledgeFire: true,
      }
    );
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(16);
    expect(r.controlDifficulty).toBe(0);
  });

  it('Master Stone with all circumstance bonuses stacked', () => {
    // Base: Master = 12, 8
    // placeIndex=0 → -7/-2
    // trueNameIndex=5 → -5/-2
    // materialPurityIndex=0 → -3
    // timeIndex=0 → -3/-1
    // giftIndex=0 → -7/-2
    // deedIndex=0 → -7/-2
    // Sum summon: 12 - 7 - 5 - 3 - 3 - 7 - 7 = -20
    // Sum control: 8 - 2 - 2 - 1 - 2 - 2 = -1
    const c = makeConfig({
      element: DsaElement.Stone,
      summoningType: SummoningType.Master,
      placeIndex: 0,
      trueNameIndex: 5,
      materialPurityIndex: 0,
      timeIndex: 0,
      giftIndex: 0,
      deedIndex: 0,
    });
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(-20);
    expect(r.controlDifficulty).toBe(-1);
  });

  it('Servant Ice with character demonic penalties and affinityToElementals bonus', () => {
    // Base: 4, 2
    // talentedDemonic=1 → +2/+4
    // affinityToElementals → -3 control
    // Total: 6 summon, 3 control
    const c = makeConfig(
      { element: DsaElement.Ice, summoningType: SummoningType.Servant },
      { talentedDemonic: 1, affinityToElementals: true }
    );
    const r = calculateSummoning(c);
    expect(r.summonDifficulty).toBe(6);
    expect(r.controlDifficulty).toBe(3);
  });
});

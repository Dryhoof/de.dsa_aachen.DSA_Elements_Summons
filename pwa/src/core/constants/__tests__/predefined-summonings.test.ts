import { describe, it, expect } from 'vitest';
import {
  predefinedSummonings,
  predefinedNamesDe,
  predefinedNamesEn,
  getPredefinedName,
} from '../predefined-summonings';
import { DsaElement } from '../../models/element';
import { SummoningType } from '../../models/summoning-type';

// ─── Count and uniqueness ─────────────────────────────────────────────────────

describe('predefinedSummonings array', () => {
  it('has 35 entries (18 standard + 17 named specials)', () => {
    expect(predefinedSummonings).toHaveLength(35);
  });

  it('all IDs are unique', () => {
    const ids = predefinedSummonings.map(p => p.id);
    const unique = new Set(ids);
    expect(unique.size).toBe(predefinedSummonings.length);
  });

  it('each element has at least 3 entries (standard Servant, Djinn, Master)', () => {
    const elements = [
      DsaElement.Fire, DsaElement.Water, DsaElement.Life,
      DsaElement.Ice, DsaElement.Stone, DsaElement.Air,
    ];
    for (const el of elements) {
      const count = predefinedSummonings.filter(p => p.element === el).length;
      expect(count).toBeGreaterThanOrEqual(3);
    }
  });

  it('each element has all 3 standard types', () => {
    const elements = [
      DsaElement.Fire, DsaElement.Water, DsaElement.Life,
      DsaElement.Ice, DsaElement.Stone, DsaElement.Air,
    ];
    for (const el of elements) {
      const byElement = predefinedSummonings.filter(p => p.element === el);
      expect(byElement.some(p => p.summoningType === SummoningType.Servant)).toBe(true);
      expect(byElement.some(p => p.summoningType === SummoningType.Djinn)).toBe(true);
      expect(byElement.some(p => p.summoningType === SummoningType.Master)).toBe(true);
    }
  });
});

// ─── Default base costs ───────────────────────────────────────────────────────

describe('predefined base costs', () => {
  it('standard Servant entries have baseSummonMod=4, baseControlMod=2', () => {
    const standardServants = ['geist_eis', 'geist_erz', 'geist_feuer', 'geist_humus', 'geist_luft', 'geist_wasser'];
    for (const id of standardServants) {
      const p = predefinedSummonings.find(ps => ps.id === id)!;
      expect(p.baseSummonMod).toBe(4);
      expect(p.baseControlMod).toBe(2);
    }
  });

  it('standard Djinn entries have baseSummonMod=8, baseControlMod=4', () => {
    const standardDjinns = ['dschinn_eis', 'dschinn_erz', 'dschinn_feuer', 'dschinn_humus', 'dschinn_luft', 'dschinn_wasser'];
    for (const id of standardDjinns) {
      const p = predefinedSummonings.find(ps => ps.id === id)!;
      expect(p.baseSummonMod).toBe(8);
      expect(p.baseControlMod).toBe(4);
    }
  });

  it('all Master entries have baseSummonMod=12, baseControlMod=8', () => {
    const masters = predefinedSummonings.filter(p => p.summoningType === SummoningType.Master);
    for (const p of masters) {
      expect(p.baseSummonMod).toBe(12);
      expect(p.baseControlMod).toBe(8);
    }
  });

  it('named specials have individual base costs from PDF', () => {
    const quecksilber = predefinedSummonings.find(p => p.id === 'quecksilbergeist')!;
    expect(quecksilber.baseSummonMod).toBe(5);
    expect(quecksilber.baseControlMod).toBe(3);

    const alJallahir = predefinedSummonings.find(p => p.id === 'al_jallahir')!;
    expect(alJallahir.baseSummonMod).toBe(9);
    expect(alJallahir.baseControlMod).toBe(3);

    const doryphoros = predefinedSummonings.find(p => p.id === 'doryphoros')!;
    expect(doryphoros.baseSummonMod).toBe(9);
    expect(doryphoros.baseControlMod).toBe(6);

    const dieros = predefinedSummonings.find(p => p.id === 'dieros_nehqal')!;
    expect(dieros.baseSummonMod).toBe(12);
    expect(dieros.baseControlMod).toBe(10);
  });
});

// ─── Specific predefined entries ──────────────────────────────────────────────

describe('specific predefined IDs', () => {
  it('geist_eis exists and has Ice element with Servant type', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_eis');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Ice);
    expect(p!.summoningType).toBe(SummoningType.Servant);
  });

  it('dschinn_eis exists and has Ice element with Djinn type', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'dschinn_eis');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Ice);
    expect(p!.summoningType).toBe(SummoningType.Djinn);
  });

  it('meister_eis exists and has Ice element with Master type', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'meister_eis');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Ice);
    expect(p!.summoningType).toBe(SummoningType.Master);
  });

  it('geist_feuer exists with Fire element', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_feuer');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Fire);
  });

  it('geist_wasser exists with Water element', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_wasser');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Water);
  });

  it('geist_luft exists with Air element', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_luft');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Air);
  });

  it('geist_humus exists with Life element', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_humus');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Life);
  });

  it('geist_erz exists with Stone element', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_erz');
    expect(p).toBeDefined();
    expect(p!.element).toBe(DsaElement.Stone);
  });
});

// ─── Stone/Ore has shatteringArmor ───────────────────────────────────────────

describe('stone ore special property', () => {
  it('geist_erz has shatteringArmor=true', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'geist_erz');
    expect(p!.shatteringArmor).toBe(true);
  });

  it('dschinn_erz has shatteringArmor=true', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'dschinn_erz');
    expect(p!.shatteringArmor).toBe(true);
  });

  it('meister_erz has shatteringArmor=true', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'meister_erz');
    expect(p!.shatteringArmor).toBe(true);
  });

  it('non-stone predefined does not have shatteringArmor', () => {
    const fireServant = predefinedSummonings.find(ps => ps.id === 'geist_feuer');
    expect(fireServant!.shatteringArmor).toBe(false);
  });

  it('non-ore predefined have shatteringArmor=false', () => {
    const nonOre = predefinedSummonings.filter(p => p.element !== DsaElement.Stone);
    for (const p of nonOre) {
      expect(p.shatteringArmor).toBe(false);
    }
  });

  it('quecksilbergeist does NOT have shatteringArmor (unlike standard ore)', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'quecksilbergeist')!;
    expect(p.shatteringArmor).toBe(false);
  });
});

// ─── Default boolean fields are false ────────────────────────────────────────

describe('default ability fields', () => {
  it('all predefined have astralSense=false', () => {
    for (const p of predefinedSummonings) {
      expect(p.astralSense).toBe(false);
    }
  });

  it('all predefined have longArm=false', () => {
    for (const p of predefinedSummonings) {
      expect(p.longArm).toBe(false);
    }
  });

  it('all predefined have lifeSense=false', () => {
    for (const p of predefinedSummonings) {
      expect(p.lifeSense).toBe(false);
    }
  });

  it('all predefined have additionalActionsLevel=0', () => {
    for (const p of predefinedSummonings) {
      expect(p.additionalActionsLevel).toBe(0);
    }
  });

  it('all predefined have immunityMagic=false', () => {
    for (const p of predefinedSummonings) {
      expect(p.immunityMagic).toBe(false);
    }
  });

  it('all predefined have resistanceMagic=false', () => {
    for (const p of predefinedSummonings) {
      expect(p.resistanceMagic).toBe(false);
    }
  });

  it('quecksilbergeist has regenerationLevel=1', () => {
    const p = predefinedSummonings.find(ps => ps.id === 'quecksilbergeist')!;
    expect(p.regenerationLevel).toBe(1);
  });
});

// ─── Default numeric fields are 0 ────────────────────────────────────────────

describe('default value modification fields', () => {
  const alwaysZeroFields: Array<keyof typeof predefinedSummonings[0]> = [
    'modLeP', 'modINI', 'modRS', 'modGS', 'modMR',
    'modAT', 'modPA', 'modTP', 'modAttribute', 'modNewTalent', 'modTaWZfW',
    'stoneEatingLevel',
  ];

  for (const field of alwaysZeroFields) {
    it(`all predefined have ${field}=0`, () => {
      for (const p of predefinedSummonings) {
        expect(p[field]).toBe(0);
      }
    });
  }

  it('named specials have correct non-zero ability levels', () => {
    const mepharasch = predefinedSummonings.find(p => p.id === 'mepharasch')!;
    expect(mepharasch.artifactAnimationLevel).toBe(2);

    const truncus = predefinedSummonings.find(p => p.id === 'truncus')!;
    expect(truncus.elementalGripLevel).toBe(1);

    const doryphoros = predefinedSummonings.find(p => p.id === 'doryphoros')!;
    expect(doryphoros.stoneSkinLevel).toBe(2);

    const alShafeif = predefinedSummonings.find(p => p.id === 'al_shafeif')!;
    expect(alShafeif.stoneSkinLevel).toBe(1);
  });
});

// ─── Name maps ────────────────────────────────────────────────────────────────

describe('predefinedNamesDe', () => {
  it('has entries for all predefined summonings', () => {
    expect(Object.keys(predefinedNamesDe)).toHaveLength(predefinedSummonings.length);
  });

  it('geist_eis maps to "Geist des Eises"', () => {
    expect(predefinedNamesDe['geist_eis']).toBe('Geist des Eises');
  });

  it('meister_feuer maps to "Elementarer Meister des Feuers"', () => {
    expect(predefinedNamesDe['meister_feuer']).toBe('Elementarer Meister des Feuers');
  });

  it('all IDs from predefinedSummonings have a German name', () => {
    for (const p of predefinedSummonings) {
      expect(predefinedNamesDe[p.id]).toBeDefined();
      expect(predefinedNamesDe[p.id].length).toBeGreaterThan(0);
    }
  });
});

describe('predefinedNamesEn', () => {
  it('has entries for all predefined summonings', () => {
    expect(Object.keys(predefinedNamesEn)).toHaveLength(predefinedSummonings.length);
  });

  it('geist_eis maps to "Spirit of Ice"', () => {
    expect(predefinedNamesEn['geist_eis']).toBe('Spirit of Ice');
  });

  it('meister_feuer maps to "Elemental Master of Fire"', () => {
    expect(predefinedNamesEn['meister_feuer']).toBe('Elemental Master of Fire');
  });

  it('all IDs from predefinedSummonings have an English name', () => {
    for (const p of predefinedSummonings) {
      expect(predefinedNamesEn[p.id]).toBeDefined();
      expect(predefinedNamesEn[p.id].length).toBeGreaterThan(0);
    }
  });
});

// ─── getPredefinedName ────────────────────────────────────────────────────────

describe('getPredefinedName', () => {
  it('returns German name for locale "de"', () => {
    expect(getPredefinedName('geist_eis', 'de')).toBe('Geist des Eises');
  });

  it('returns English name for locale "en"', () => {
    expect(getPredefinedName('geist_eis', 'en')).toBe('Spirit of Ice');
  });

  it('returns German name for locale "de-DE"', () => {
    expect(getPredefinedName('geist_feuer', 'de')).toBe('Geist des Feuers');
  });

  it('falls back to ID for unknown IDs in "en" locale', () => {
    expect(getPredefinedName('unknown_id', 'en')).toBe('unknown_id');
  });

  it('falls back to ID for unknown IDs in "de" locale', () => {
    expect(getPredefinedName('unknown_id', 'de')).toBe('unknown_id');
  });

  it('non-"de" locale returns English names', () => {
    expect(getPredefinedName('geist_eis', 'fr')).toBe('Spirit of Ice');
    expect(getPredefinedName('geist_eis', 'es')).toBe('Spirit of Ice');
  });

  it('returns different names for de vs en', () => {
    for (const p of predefinedSummonings) {
      const deName = getPredefinedName(p.id, 'de');
      const enName = getPredefinedName(p.id, 'en');
      expect(deName).not.toBe(enName);
    }
  });
});

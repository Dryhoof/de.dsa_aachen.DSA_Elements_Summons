import { DsaElement } from '../models/element';
import { SummoningType } from '../models/summoning-type';
import { PredefinedSummoning } from '../models/summoning-config';

function makePredefined(
  id: string,
  element: DsaElement,
  summoningType: SummoningType,
  baseSummonMod: number,
  baseControlMod: number,
  overrides: Partial<Omit<PredefinedSummoning, 'id' | 'element' | 'summoningType' | 'baseSummonMod' | 'baseControlMod'>> = {}
): PredefinedSummoning {
  return {
    id,
    element,
    summoningType,
    baseSummonMod,
    baseControlMod,
    astralSense: false,
    longArm: false,
    lifeSense: false,
    regenerationLevel: 0,
    additionalActionsLevel: 0,
    resistanceMagic: false,
    resistanceTraitDamage: false,
    immunityMagic: false,
    immunityTraitDamage: false,
    resistancesDemonic: {},
    resistancesElemental: {},
    immunitiesDemonic: {},
    immunitiesElemental: {},
    causeFear: false,
    artifactAnimationLevel: 0,
    aura: false,
    blinkingInvisibility: false,
    elementalShackle: false,
    elementalGripLevel: 0,
    elementalInferno: false,
    elementalGrowth: false,
    drowning: false,
    areaAttack: false,
    flight: false,
    frost: false,
    ember: false,
    criticalImmunity: false,
    boilingBlood: false,
    fog: false,
    smoke: false,
    stasis: false,
    stoneEatingLevel: 0,
    stoneSkinLevel: 0,
    mergeWithElement: false,
    sinking: false,
    wildGrowth: false,
    burst: false,
    shatteringArmor: false,
    modLeP: 0,
    modINI: 0,
    modRS: 0,
    modGS: 0,
    modMR: 0,
    modAT: 0,
    modPA: 0,
    modTP: 0,
    modAttribute: 0,
    modNewTalent: 0,
    modTaWZfW: 0,
    ...overrides,
  };
}

export const predefinedSummonings: PredefinedSummoning[] = [
  // ── Eis ──────────────────────────────────────────────────────────────────
  makePredefined('geist_eis',   DsaElement.Ice,   SummoningType.Servant, 4,  2),
  makePredefined('dschinn_eis', DsaElement.Ice,   SummoningType.Djinn,   8,  4),
  makePredefined('meister_eis', DsaElement.Ice,   SummoningType.Master,  12, 8),
  makePredefined('hagelfalke',  DsaElement.Ice,   SummoningType.Servant, 4,  2),

  // ── Erz ──────────────────────────────────────────────────────────────────
  makePredefined('geist_erz',   DsaElement.Stone, SummoningType.Servant, 4,  2,  { shatteringArmor: true }),
  makePredefined('dschinn_erz', DsaElement.Stone, SummoningType.Djinn,   8,  4,  { shatteringArmor: true }),
  makePredefined('meister_erz', DsaElement.Stone, SummoningType.Master,  12, 8,  { shatteringArmor: true }),
  makePredefined('quecksilbergeist', DsaElement.Stone, SummoningType.Servant, 5, 3, { regenerationLevel: 1 }),
  makePredefined('al_serak',    DsaElement.Stone, SummoningType.Djinn,   9,  4,  { shatteringArmor: true }),
  makePredefined('al_shafeif',  DsaElement.Stone, SummoningType.Djinn,   10, 3,  { stoneSkinLevel: 1, shatteringArmor: true }),
  makePredefined('doryphoros',  DsaElement.Stone, SummoningType.Djinn,   9,  6,  { stoneSkinLevel: 2, shatteringArmor: true }),

  // ── Feuer ────────────────────────────────────────────────────────────────
  makePredefined('geist_feuer',   DsaElement.Fire,  SummoningType.Servant, 4,  2),
  makePredefined('dschinn_feuer', DsaElement.Fire,  SummoningType.Djinn,   8,  4),
  makePredefined('meister_feuer', DsaElement.Fire,  SummoningType.Master,  12, 8),
  makePredefined('al_jallahir', DsaElement.Fire,  SummoningType.Djinn,   9,  3,  { areaAttack: true, elementalShackle: true, smoke: true }),
  makePredefined('mepharasch',  DsaElement.Fire,  SummoningType.Djinn,   7,  7,  { artifactAnimationLevel: 2 }),
  makePredefined('sholgothar',  DsaElement.Fire,  SummoningType.Djinn,   9,  6,  { aura: true, ember: true }),

  // ── Humus ────────────────────────────────────────────────────────────────
  makePredefined('geist_humus',   DsaElement.Life,  SummoningType.Servant, 4,  2),
  makePredefined('dschinn_humus', DsaElement.Life,  SummoningType.Djinn,   8,  4),
  makePredefined('meister_humus', DsaElement.Life,  SummoningType.Master,  12, 8),
  makePredefined('blaetterwirbel', DsaElement.Life, SummoningType.Djinn,  9,  5,  { elementalShackle: true, criticalImmunity: true }),
  makePredefined('rosendschinn', DsaElement.Life,  SummoningType.Djinn,   8,  6,  { elementalShackle: true }),
  makePredefined('truncus',     DsaElement.Life,   SummoningType.Djinn,   6,  4,  { elementalGripLevel: 1, criticalImmunity: true }),

  // ── Luft ─────────────────────────────────────────────────────────────────
  makePredefined('geist_luft',   DsaElement.Air,   SummoningType.Servant, 4,  2),
  makePredefined('dschinn_luft', DsaElement.Air,   SummoningType.Djinn,   8,  4),
  makePredefined('meister_luft', DsaElement.Air,   SummoningType.Master,  12, 8),
  makePredefined('saebelschwinge', DsaElement.Air,  SummoningType.Servant, 4,  1,  { artifactAnimationLevel: 1 }),
  makePredefined('windfeger',   DsaElement.Air,    SummoningType.Djinn,   9,  6),
  makePredefined('tornado',     DsaElement.Air,    SummoningType.Djinn,   10, 4,  { mergeWithElement: true }),
  makePredefined('dieros_nehqal', DsaElement.Air,  SummoningType.Djinn,   12, 10),

  // ── Wasser ───────────────────────────────────────────────────────────────
  makePredefined('geist_wasser',   DsaElement.Water, SummoningType.Servant, 4,  2),
  makePredefined('dschinn_wasser', DsaElement.Water, SummoningType.Djinn,   8,  4),
  makePredefined('meister_wasser', DsaElement.Water, SummoningType.Master,  12, 8),
  makePredefined('abu_al_hamam', DsaElement.Water, SummoningType.Djinn,   7,  4,  { drowning: true, mergeWithElement: true }),
  makePredefined('regenbringer', DsaElement.Water, SummoningType.Djinn,   10, 7,  { elementalShackle: true, areaAttack: true, sinking: true }),
];

export const predefinedNamesDe: Record<string, string> = {
  // Eis
  'geist_eis':      'Geist des Eises',
  'dschinn_eis':    'Dschinn des Eises',
  'meister_eis':    'Elementarer Meister des Eises',
  'hagelfalke':     'Hagelfalke',
  // Erz
  'geist_erz':      'Geist des Erzes',
  'dschinn_erz':    'Dschinn des Erzes',
  'meister_erz':    'Elementarer Meister des Erzes',
  'quecksilbergeist': 'Quecksilbergeist',
  'al_serak':       'Al\'Serak, der Baumeister',
  'al_shafeif':     'Al\'Shafeif, das eherne Antlitz',
  'doryphoros':     'Doryphoros, der unbezwingbare Titan',
  // Feuer
  'geist_feuer':    'Geist des Feuers',
  'dschinn_feuer':  'Dschinn des Feuers',
  'meister_feuer':  'Elementarer Meister des Feuers',
  'al_jallahir':    'Al\'Jallahir, der flammende Redner',
  'mepharasch':     'Mepharasch, der Feuerwirsch',
  'sholgothar':     'Sholgothar, die zähe Glut',
  // Humus
  'geist_humus':    'Geist des Humus',
  'dschinn_humus':  'Dschinn des Humus',
  'meister_humus':  'Elementarer Meister des Humus',
  'blaetterwirbel': 'Blätterwirbel',
  'rosendschinn':   'Rosendschinn',
  'truncus':        'Truncus, der Schratige',
  // Luft
  'geist_luft':     'Geist der Luft',
  'dschinn_luft':   'Dschinn der Luft',
  'meister_luft':   'Elementarer Meister der Luft',
  'saebelschwinge': 'Säbelschwinge',
  'windfeger':      'Windfeger',
  'tornado':        'Tornado, der Orkanpardel',
  'dieros_nehqal':  'Kapitän Dieros Nehqal',
  // Wasser
  'geist_wasser':   'Geist des Wassers',
  'dschinn_wasser': 'Dschinn des Wassers',
  'meister_wasser': 'Elementarer Meister des Wassers',
  'abu_al_hamam':   'Abu al\'Hamam, Herr des Bades',
  'regenbringer':   'Regenbringer',
};

export const predefinedNamesEn: Record<string, string> = {
  // Ice
  'geist_eis':      'Spirit of Ice',
  'dschinn_eis':    'Djinn of Ice',
  'meister_eis':    'Elemental Master of Ice',
  'hagelfalke':     'Hail Falcon',
  // Ore
  'geist_erz':      'Spirit of Ore',
  'dschinn_erz':    'Djinn of Ore',
  'meister_erz':    'Elemental Master of Ore',
  'quecksilbergeist': 'Quicksilver Spirit',
  'al_serak':       'Al\'Serak, the Master Builder',
  'al_shafeif':     'Al\'Shafeif, the Brazen Visage',
  'doryphoros':     'Doryphoros, the Invincible Titan',
  // Fire
  'geist_feuer':    'Spirit of Fire',
  'dschinn_feuer':  'Djinn of Fire',
  'meister_feuer':  'Elemental Master of Fire',
  'al_jallahir':    'Al\'Jallahir, the Blazing Orator',
  'mepharasch':     'Mepharasch, the Fire Imp',
  'sholgothar':     'Sholgothar, the Tenacious Ember',
  // Life
  'geist_humus':    'Spirit of Life',
  'dschinn_humus':  'Djinn of Life',
  'meister_humus':  'Elemental Master of Life',
  'blaetterwirbel': 'Leaf Whirl',
  'rosendschinn':   'Rose Djinn',
  'truncus':        'Truncus, the Gnarled One',
  // Air
  'geist_luft':     'Spirit of Air',
  'dschinn_luft':   'Djinn of Air',
  'meister_luft':   'Elemental Master of Air',
  'saebelschwinge': 'Saber Wing',
  'windfeger':      'Windsweeper',
  'tornado':        'Tornado, the Hurricane Leopard',
  'dieros_nehqal':  'Captain Dieros Nehqal',
  // Water
  'geist_wasser':   'Spirit of Water',
  'dschinn_wasser': 'Djinn of Water',
  'meister_wasser': 'Elemental Master of Water',
  'abu_al_hamam':   'Abu al\'Hamam, Lord of the Bath',
  'regenbringer':   'Rainbringer',
};

export function getPredefinedName(id: string, locale: string): string {
  const names = locale === 'de' ? predefinedNamesDe : predefinedNamesEn;
  return names[id] ?? id;
}

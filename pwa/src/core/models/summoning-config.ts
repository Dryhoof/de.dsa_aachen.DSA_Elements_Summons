import { Character } from './character';
import { DsaElement } from './element';
import { SummoningType } from './summoning-type';

export interface PredefinedSummoning {
  id: string;
  element: DsaElement;
  summoningType: SummoningType;
  baseSummonMod: number;
  baseControlMod: number;
  astralSense: boolean;
  longArm: boolean;
  lifeSense: boolean;
  regenerationLevel: number;
  additionalActionsLevel: number;
  resistanceMagic: boolean;
  resistanceTraitDamage: boolean;
  immunityMagic: boolean;
  immunityTraitDamage: boolean;
  resistancesDemonic: Record<string, boolean>;
  resistancesElemental: Partial<Record<DsaElement, boolean>>;
  immunitiesDemonic: Record<string, boolean>;
  immunitiesElemental: Partial<Record<DsaElement, boolean>>;
  causeFear: boolean;
  artifactAnimationLevel: number;
  aura: boolean;
  blinkingInvisibility: boolean;
  elementalShackle: boolean;
  elementalGripLevel: number;
  elementalInferno: boolean;
  elementalGrowth: boolean;
  drowning: boolean;
  areaAttack: boolean;
  flight: boolean;
  frost: boolean;
  ember: boolean;
  criticalImmunity: boolean;
  boilingBlood: boolean;
  fog: boolean;
  smoke: boolean;
  stasis: boolean;
  stoneEatingLevel: number;
  stoneSkinLevel: number;
  mergeWithElement: boolean;
  sinking: boolean;
  wildGrowth: boolean;
  burst: boolean;
  shatteringArmor: boolean;
  modLeP: number;
  modINI: number;
  modRS: number;
  modGS: number;
  modMR: number;
  modAT: number;
  modPA: number;
  modTP: number;
  modAttribute: number;
  modNewTalent: number;
  modTaWZfW: number;
}

export interface SummoningConfig {
  character: Character;
  element: DsaElement;
  summoningType: SummoningType;
  materialPurityIndex: number;
  trueNameIndex: number;
  placeIndex: number;
  powernodeIndex: number;
  timeIndex: number;
  giftIndex: number;
  deedIndex: number;
  properAttire: boolean;
  astralSense: boolean;
  longArm: boolean;
  lifeSense: boolean;
  resistanceMagic: boolean;
  immunityMagic: boolean;
  regenerationLevel: number;
  additionalActionsLevel: number;
  resistanceTraitDamage: boolean;
  immunityTraitDamage: boolean;
  resistancesDemonic: Record<string, boolean>;
  immunitiesDemonic: Record<string, boolean>;
  resistancesElemental: Partial<Record<DsaElement, boolean>>;
  immunitiesElemental: Partial<Record<DsaElement, boolean>>;
  bloodMagicUsed: boolean;
  summonedLesserDemon: boolean;
  summonedHornedDemon: boolean;
  additionalSummonMod: number;
  additionalControlMod: number;
  predefined: PredefinedSummoning | null;
  causeFear: boolean;
  artifactAnimationLevel: number;
  aura: boolean;
  blinkingInvisibility: boolean;
  elementalShackle: boolean;
  elementalGripLevel: number;
  elementalInferno: boolean;
  elementalGrowth: boolean;
  drowning: boolean;
  areaAttack: boolean;
  flight: boolean;
  frost: boolean;
  ember: boolean;
  criticalImmunity: boolean;
  boilingBlood: boolean;
  fog: boolean;
  smoke: boolean;
  stasis: boolean;
  stoneEatingLevel: number;
  stoneSkinLevel: number;
  mergeWithElement: boolean;
  sinking: boolean;
  wildGrowth: boolean;
  burst: boolean;
  shatteringArmor: boolean;
  modLeP: number;
  modINI: number;
  modRS: number;
  modGS: number;
  modMR: number;
  modAT: number;
  modPA: number;
  modTP: number;
  modAttribute: number;
  modNewTalent: number;
  modTaWZfW: number;
}

export function defaultSummoningConfig(character: Character): SummoningConfig {
  return {
    character,
    element: DsaElement.Fire,
    summoningType: SummoningType.Servant,
    materialPurityIndex: 3,
    trueNameIndex: 0,
    placeIndex: 6,
    powernodeIndex: 0,
    timeIndex: 3,
    giftIndex: 7,
    deedIndex: 7,
    properAttire: false,
    astralSense: false,
    longArm: false,
    lifeSense: false,
    resistanceMagic: false,
    immunityMagic: false,
    regenerationLevel: 0,
    additionalActionsLevel: 0,
    resistanceTraitDamage: false,
    immunityTraitDamage: false,
    resistancesDemonic: {},
    immunitiesDemonic: {},
    resistancesElemental: {},
    immunitiesElemental: {},
    bloodMagicUsed: false,
    summonedLesserDemon: false,
    summonedHornedDemon: false,
    additionalSummonMod: 0,
    additionalControlMod: 0,
    predefined: null,
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
  };
}

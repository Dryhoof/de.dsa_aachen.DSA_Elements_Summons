import {
  materialPurityModifiers,
  trueNameModifiers,
  placeModifiers,
  powernodeModifiers,
  timeModifiers,
  giftModifiers,
  deedModifiers,
  personalitiesDe,
  personalitiesEn,
  demonNames,
} from '../constants/element-data';
import { DsaElement, ALL_ELEMENTS, getCounterElement } from '../models/element';
import { SUMMONING_TYPE_COSTS } from '../models/summoning-type';
import { SummoningConfig, PredefinedSummoning } from '../models/summoning-config';
import { SummoningResult } from '../models/summoning-result';

export function calculateSummoning(c: SummoningConfig, locale = 'en'): SummoningResult {
  let summon = 0;
  let control = 0;

  // 1. Base cost: predefined adjusted base OR summoning type base
  if (c.predefined !== null) {
    const p = c.predefined!;
    // Predefined mode: use fixed base minus standard ability cost.
    summon += p.baseSummonMod - predefinedAbilitySummonCost(p, c.element);
    control += p.baseControlMod;
  } else {
    const costs = SUMMONING_TYPE_COSTS[c.summoningType];
    summon += costs.summon;
    control += costs.control;
  }

  // 3. Astral sense
  if (c.astralSense) summon += 5;

  // 4. Long arm
  if (c.longArm) summon += 3;

  // 5. Life sense (4 ZfP*)
  if (c.lifeSense) summon += 4;

  // 6. Immunity/Resistance against magic (mutually exclusive)
  if (c.immunityMagic) {
    summon += 10;
  } else if (c.resistanceMagic) {
    summon += 5;
  }

  // 7. Regeneration
  if (c.regenerationLevel === 2) {
    summon += 7;
  } else if (c.regenerationLevel === 1) {
    summon += 4;
  }

  // 8. Additional actions
  if (c.additionalActionsLevel === 2) {
    summon += 7;
  } else if (c.additionalActionsLevel === 1) {
    summon += 3;
  }

  // 9. Immunity/Resistance against trait damage (mutually exclusive)
  if (c.immunityMagic) {
    // Magic immunity covers everything, skip trait damage entirely
  } else if (c.immunityTraitDamage) {
    summon += 10;
  } else if (!c.resistanceMagic && c.resistanceTraitDamage) {
    summon += 5;
  }

  // 10. Demonic resistances/immunities (8 demons)
  for (const demon of demonNames) {
    if (c.immunitiesDemonic[demon] === true) {
      summon += 10;
    } else if (c.resistancesDemonic[demon] === true) {
      summon += 5;
    }
  }

  // 11. Elemental attack resistances/immunities (for non-selected elements)
  for (const el of ALL_ELEMENTS) {
    if (el === c.element) continue; // own element immunity is free/automatic
    if (c.immunitiesElemental[el] === true) {
      summon += 7;
    } else if (c.resistancesElemental[el] === true) {
      summon += 3;
    }
  }

  // 2. Proper Attire (Richtige Gewandung): -2 summon only
  if (c.properAttire) summon -= 2;

  // 12. Quality of true name
  const trueName = trueNameModifiers[c.trueNameIndex];
  summon += trueName[0];
  control += trueName[1];

  // 13. Talented for selected element
  if (isTalentedForElement(c, c.element)) {
    summon -= 2;
    control -= 2;
  }

  // 14. Knowledge of selected element
  if (hasKnowledgeOfElement(c, c.element)) {
    summon -= 2;
    control -= 2;
  }

  // 15. Talented for counter element (penalty)
  if (isTalentedForElement(c, getCounterElement(c.element))) {
    summon += 4;
    control += 2;
  }

  // 16. Knowledge of counter element (penalty)
  if (hasKnowledgeOfElement(c, getCounterElement(c.element))) {
    summon += 4;
    control += 2;
  }

  // 17. Demonic talents
  summon += c.character.talentedDemonic * 2;
  control += c.character.talentedDemonic * 4;

  // 18. Demonic knowledge
  summon += c.character.knowledgeDemonic * 2;
  control += c.character.knowledgeDemonic * 4;

  // 19. Demonic covenant
  if (c.character.demonicCovenant) {
    summon += 6;
    control += 9;
  }

  // 20. Affinity to elementals
  if (c.character.affinityToElementals) {
    control -= 3;
  }

  // 21. Cloaked aura
  if (c.character.cloakedAura) {
    control += 1;
  }

  // 22. Weak presence
  control += c.character.weakPresence;

  // 23. Strength of stigma
  control += c.character.strengthOfStigma;

  // 24. Circumstances of place
  const place = placeModifiers[c.placeIndex];
  summon += place[0];
  control += place[1];

  // 25. Powernode (only if powerline magic I)
  if (c.character.powerlineMagicI) {
    summon += powernodeModifiers[c.powernodeIndex];
  }

  // 26. Circumstances of time
  const time = timeModifiers[c.timeIndex];
  summon += time[0];
  control += time[1];

  // 27. Quality of material (element-specific purity)
  summon += materialPurityModifiers[c.element][c.materialPurityIndex];

  // 28. Quality of gift
  const gift = giftModifiers[c.giftIndex];
  summon += gift[0];
  control += gift[1];

  // 29. Quality of deed
  const deed = deedModifiers[c.deedIndex];
  summon += deed[0];
  control += deed[1];

  // 30. Blood magic
  if (c.bloodMagicUsed) control += 12;

  // 31/32. Summoned demon (horned takes precedence over lesser)
  if (c.summonedHornedDemon) {
    control += 4;
  } else if (c.summonedLesserDemon) {
    control += 4;
  }

  // 33. Special properties (ZfP* → summon)
  if (c.causeFear) summon += 5;
  summon += c.artifactAnimationLevel * 3;
  if (c.aura) summon += 5;
  if (c.blinkingInvisibility) summon += 6;
  if (c.elementalShackle) summon += 5;
  summon += c.elementalGripLevel * 7;
  if (c.elementalInferno) summon += 8;
  if (c.elementalGrowth) summon += 7;
  if (c.drowning) summon += 4;
  if (c.areaAttack) summon += 7;
  if (c.flight) summon += 5;
  if (c.frost) summon += 3;
  if (c.ember) summon += 3;
  if (c.criticalImmunity) summon += 2;
  if (c.boilingBlood) summon += 5;
  if (c.fog) summon += 2;
  if (c.smoke) summon += 4;
  if (c.stasis) summon += 5;
  summon += c.stoneEatingLevel * 2;
  summon += c.stoneSkinLevel * 2;
  if (c.mergeWithElement) summon += 7;
  if (c.sinking) summon += 6;
  if (c.wildGrowth) summon += 7;
  if (c.burst) summon += 4;
  if (c.shatteringArmor) summon += 3;

  // 34. Value modifications (ZfP* → summon)
  summon += c.modLeP * 2;
  summon += c.modINI * 3;
  summon += c.modRS * 3;
  summon += c.modGS * 3;
  summon += c.modMR * 3;
  summon += c.modAT * 4;
  summon += c.modPA * 4;
  summon += c.modTP * 4;
  summon += c.modAttribute * 5;
  summon += c.modNewTalent * 4;
  summon += c.modTaWZfW * 1;

  // 35. Additional manual modifiers
  summon += c.additionalSummonMod;
  control += c.additionalControlMod;

  // Random personality
  const personalities = locale === 'de' ? personalitiesDe[c.element] : personalitiesEn[c.element];
  const personality = personalities[Math.floor(Math.random() * personalities.length)];

  return {
    summonDifficulty: summon,
    controlDifficulty: control,
    personality,
    element: c.element,
    summoningType: c.summoningType,
  };
}

/**
 * Computes the standard ZfP* summon cost of a predefined creature's built-in abilities.
 * Used to calculate the adjusted base so that built-in abilities are effectively "free".
 */
export function predefinedAbilitySummonCost(p: PredefinedSummoning, element: DsaElement): number {
  let cost = 0;

  if (p.astralSense) cost += 5;
  if (p.longArm) cost += 3;
  if (p.lifeSense) cost += 4;

  if (p.immunityMagic) {
    cost += 10;
  } else if (p.resistanceMagic) {
    cost += 5;
  }

  if (p.regenerationLevel === 2) cost += 7;
  else if (p.regenerationLevel === 1) cost += 4;

  if (p.additionalActionsLevel === 2) cost += 7;
  else if (p.additionalActionsLevel === 1) cost += 3;

  if (!p.immunityMagic) {
    if (p.immunityTraitDamage) {
      cost += 10;
    } else if (!p.resistanceMagic && p.resistanceTraitDamage) {
      cost += 5;
    }
  }

  for (const demon of demonNames) {
    if (p.immunitiesDemonic[demon] === true) cost += 10;
    else if (p.resistancesDemonic[demon] === true) cost += 5;
  }

  for (const el of ALL_ELEMENTS) {
    if (el === element) continue;
    if (p.immunitiesElemental[el] === true) cost += 7;
    else if (p.resistancesElemental[el] === true) cost += 3;
  }

  // Special properties
  if (p.causeFear) cost += 5;
  cost += p.artifactAnimationLevel * 3;
  if (p.aura) cost += 5;
  if (p.blinkingInvisibility) cost += 6;
  if (p.elementalShackle) cost += 5;
  cost += p.elementalGripLevel * 7;
  if (p.elementalInferno) cost += 8;
  if (p.elementalGrowth) cost += 7;
  if (p.drowning) cost += 4;
  if (p.areaAttack) cost += 7;
  if (p.flight) cost += 5;
  if (p.frost) cost += 3;
  if (p.ember) cost += 3;
  if (p.criticalImmunity) cost += 2;
  if (p.boilingBlood) cost += 5;
  if (p.fog) cost += 2;
  if (p.smoke) cost += 4;
  if (p.stasis) cost += 5;
  cost += p.stoneEatingLevel * 2;
  cost += p.stoneSkinLevel * 2;
  if (p.mergeWithElement) cost += 7;
  if (p.sinking) cost += 6;
  if (p.wildGrowth) cost += 7;
  if (p.burst) cost += 4;
  if (p.shatteringArmor) cost += 3;

  // Value modifications
  cost += p.modLeP * 2;
  cost += p.modINI * 3;
  cost += p.modRS * 3;
  cost += p.modGS * 3;
  cost += p.modMR * 3;
  cost += p.modAT * 4;
  cost += p.modPA * 4;
  cost += p.modTP * 4;
  cost += p.modAttribute * 5;
  cost += p.modNewTalent * 4;
  cost += p.modTaWZfW * 1;

  return cost;
}

function isTalentedForElement(c: SummoningConfig, element: DsaElement): boolean {
  switch (element) {
    case DsaElement.Fire:  return c.character.talentedFire;
    case DsaElement.Water: return c.character.talentedWater;
    case DsaElement.Life:  return c.character.talentedLife;
    case DsaElement.Ice:   return c.character.talentedIce;
    case DsaElement.Stone: return c.character.talentedStone;
    case DsaElement.Air:   return c.character.talentedAir;
  }
}

function hasKnowledgeOfElement(c: SummoningConfig, element: DsaElement): boolean {
  switch (element) {
    case DsaElement.Fire:  return c.character.knowledgeFire;
    case DsaElement.Water: return c.character.knowledgeWater;
    case DsaElement.Life:  return c.character.knowledgeLife;
    case DsaElement.Ice:   return c.character.knowledgeIce;
    case DsaElement.Stone: return c.character.knowledgeStone;
    case DsaElement.Air:   return c.character.knowledgeAir;
  }
}

import 'dart:math';

import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/constants/predefined_summonings.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_result.dart';

class SummoningCalculator {
  static SummoningResult calculate(SummoningConfig c, {String locale = 'en'}) {
    int summon = 0;
    int control = 0;

    // 1. Base cost: predefined adjusted base OR summoning type base
    if (c.predefined != null) {
      final p = c.predefined!;
      // Predefined mode: use fixed base minus standard ability cost.
      // All abilities are computed normally below, so subtracting the
      // predefined creature's standard ability cost ensures built-in
      // abilities are "free" while additional ones cost normally.
      summon += p.baseSummonMod - _predefinedAbilitySummonCost(p, c.element);
      control += p.baseControlMod;
    } else {
      summon += c.summoningType.summonCost;
      control += c.summoningType.controlCost;
    }

    // 3. Astral sense
    if (c.astralSense) {
      summon += 5;
    }

    // 4. Long arm
    if (c.longArm) {
      summon += 3;
    }

    // 5. Life sense (4 ZfP*)
    if (c.lifeSense) {
      summon += 4;
    }

    // 6. Immunity/Resistance against magic (mutually exclusive)
    if (c.immunityMagic) {
      summon += 10;
    } else if (c.resistanceMagic) {
      summon += 5;
    }

    // 7. Regeneration
    if (c.regenerationLevel == 2) {
      summon += 7;
    } else if (c.regenerationLevel == 1) {
      summon += 4;
    }

    // 8. Additional actions
    if (c.additionalActionsLevel == 2) {
      summon += 7;
    } else if (c.additionalActionsLevel == 1) {
      summon += 3;
    }

    // 9. Immunity/Resistance against trait damage (mutually exclusive)
    // - Immunity magic overrides both immunity and resistance trait damage
    // - Resistance magic overrides only resistance trait damage
    // - Immunity trait damage overrides resistance trait damage
    if (c.immunityMagic) {
      // Magic immunity covers everything, skip trait damage entirely
    } else if (c.immunityTraitDamage) {
      summon += 10;
    } else if (!c.resistanceMagic && c.resistanceTraitDamage) {
      // Only add resistance trait damage if no magic resistance
      summon += 5;
    }

    // 10. Demonic resistances/immunities (8 demons)
    for (final demon in demonNames) {
      if (c.immunitiesDemonic[demon] == true) {
        summon += 10;
      } else if (c.resistancesDemonic[demon] == true) {
        summon += 5;
      }
    }

    // 11. Elemental attack resistances/immunities (for non-selected elements)
    for (final el in DsaElement.values) {
      if (el == c.element) {
        // Own element immunity is free/automatic
        continue;
      }
      if (c.immunitiesElemental[el] == true) {
        summon += 7;
      } else if (c.resistancesElemental[el] == true) {
        summon += 3;
      }
    }

    // 2. Proper Attire (Richtige Gewandung): -2 summon only
    if (c.properAttire) {
      summon -= 2;
    }

    // 12. Quality of true name
    final trueName = trueNameModifiers[c.trueNameIndex];
    summon += trueName.$1;
    control += trueName.$2;

    // 13. Talented for selected element
    if (_isTalentedForElement(c, c.element)) {
      summon -= 2;
      control -= 2;
    }

    // 14. Knowledge of selected element
    if (_hasKnowledgeOfElement(c, c.element)) {
      summon -= 2;
      control -= 2;
    }

    // 15. Talented for counter element (penalty)
    if (_isTalentedForElement(c, c.element.counterElement)) {
      summon += 4;
      control += 2;
    }

    // 16. Knowledge of counter element (penalty)
    if (_hasKnowledgeOfElement(c, c.element.counterElement)) {
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
    final place = placeModifiers[c.placeIndex];
    summon += place.$1;
    control += place.$2;

    // 25. Powernode (only if powerline magic I)
    if (c.character.powerlineMagicI) {
      summon += powernodeModifiers[c.powernodeIndex];
    }

    // 26. Circumstances of time
    final time = timeModifiers[c.timeIndex];
    summon += time.$1;
    control += time.$2;

    // 27. Quality of material (element-specific purity)
    summon += materialPurityModifiers[c.element]![c.materialPurityIndex];

    // 28. Quality of gift
    final gift = giftModifiers[c.giftIndex];
    summon += gift.$1;
    control += gift.$2;

    // 29. Quality of deed
    final deed = deedModifiers[c.deedIndex];
    summon += deed.$1;
    control += deed.$2;

    // 30. Blood magic
    if (c.bloodMagicUsed) {
      control += 12;
    }

    // 31/32. Summoned demon (horned takes precedence over lesser)
    if (c.summonedHornedDemon) {
      control += 4;
    } else if (c.summonedLesserDemon) {
      control += 4;
    }

    // 33. Special properties (ZfP* → summon)
    if (c.causeFear) summon += 5;
    summon += c.artifactAnimationLevel * 3; // 3 ZfP* per level
    if (c.aura) summon += 5;
    if (c.blinkingInvisibility) summon += 6;
    if (c.elementalShackle) summon += 5;
    summon += c.elementalGripLevel * 7; // 7 ZfP* per level
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
    summon += c.stoneEatingLevel * 2; // 2 ZfP* per level
    summon += c.stoneSkinLevel * 2; // 2 ZfP* per level
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
    final personalities = locale == 'de'
        ? personalitiesDe[c.element]!
        : personalitiesEn[c.element]!;
    final personality = personalities[Random().nextInt(personalities.length)];

    return SummoningResult(
      summonDifficulty: summon,
      controlDifficulty: control,
      personality: personality,
      element: c.element,
      summoningType: c.summoningType,
    );
  }

  /// Computes the standard ZfP* summon cost of a predefined creature's
  /// built-in abilities. Used to calculate the adjusted base so that
  /// built-in abilities are effectively "free" in predefined mode.
  static int _predefinedAbilitySummonCost(PredefinedSummoning p, DsaElement element) {
    int cost = 0;

    // Abilities (steps 3-11)
    if (p.astralSense) cost += 5;
    if (p.longArm) cost += 3;
    if (p.lifeSense) cost += 4;

    if (p.immunityMagic) {
      cost += 10;
    } else if (p.resistanceMagic) {
      cost += 5;
    }

    if (p.regenerationLevel == 2) {
      cost += 7;
    } else if (p.regenerationLevel == 1) {
      cost += 4;
    }

    if (p.additionalActionsLevel == 2) {
      cost += 7;
    } else if (p.additionalActionsLevel == 1) {
      cost += 3;
    }

    if (p.immunityMagic) {
      // covered above
    } else if (p.immunityTraitDamage) {
      cost += 10;
    } else if (!p.resistanceMagic && p.resistanceTraitDamage) {
      cost += 5;
    }

    for (final demon in demonNames) {
      if (p.immunitiesDemonic[demon] == true) {
        cost += 10;
      } else if (p.resistancesDemonic[demon] == true) {
        cost += 5;
      }
    }

    for (final el in DsaElement.values) {
      if (el == element) continue;
      if (p.immunitiesElemental[el] == true) {
        cost += 7;
      } else if (p.resistancesElemental[el] == true) {
        cost += 3;
      }
    }

    // Special properties (step 33)
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

    // Value modifications (step 34)
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

  static bool _isTalentedForElement(SummoningConfig c, DsaElement element) {
    return switch (element) {
      DsaElement.fire => c.character.talentedFire,
      DsaElement.water => c.character.talentedWater,
      DsaElement.life => c.character.talentedLife,
      DsaElement.ice => c.character.talentedIce,
      DsaElement.stone => c.character.talentedStone,
      DsaElement.air => c.character.talentedAir,
    };
  }

  static bool _hasKnowledgeOfElement(SummoningConfig c, DsaElement element) {
    return switch (element) {
      DsaElement.fire => c.character.knowledgeFire,
      DsaElement.water => c.character.knowledgeWater,
      DsaElement.life => c.character.knowledgeLife,
      DsaElement.ice => c.character.knowledgeIce,
      DsaElement.stone => c.character.knowledgeStone,
      DsaElement.air => c.character.knowledgeAir,
    };
  }
}

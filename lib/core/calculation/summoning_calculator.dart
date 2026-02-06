import 'dart:math';

import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_result.dart';

class SummoningCalculator {
  static SummoningResult calculate(SummoningConfig c, {String locale = 'en'}) {
    int summon = 0;
    int control = 0;

    // 1. Summoning type base cost
    summon += c.summoningType.summonCost;
    control += c.summoningType.controlCost;

    // 2. Equipment bitmask
    final equipBits = (c.equipment1 ? 1 : 0) + (c.equipment2 ? 2 : 0);
    if (equipBits == 1 || equipBits == 2) {
      summon -= 1;
      control -= 1;
    } else if (equipBits == 3) {
      summon -= 2;
      control -= 2;
    }

    // 3. Astral sense
    if (c.astralSense) {
      summon += 5;
    }

    // 4. Long arm
    if (c.longArm) {
      summon += 3;
    }

    // 5. Life sense
    if (c.lifeSense) {
      summon += 6;
      control += 9;
    }

    // 6. Immunity/Resistance against magic (mutually exclusive)
    if (c.immunityMagic) {
      summon += 13;
    } else if (c.resistanceMagic) {
      summon += 6;
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

    // 33. Additional manual modifiers
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

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/constants/predefined_summonings.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';

class SummoningConfig {
  final Character character;
  final DsaElement element;
  final SummoningType summoningType;
  final int materialPurityIndex;
  final int trueNameIndex;
  final int placeIndex;
  final int powernodeIndex;
  final int timeIndex;
  final int giftIndex;
  final int deedIndex;
  final bool properAttire;
  final bool astralSense;
  final bool longArm;
  final bool lifeSense;
  final bool resistanceMagic;
  final bool immunityMagic;
  final int regenerationLevel; // 0, 1, 2
  final int additionalActionsLevel; // 0, 1, 2
  final bool resistanceTraitDamage;
  final bool immunityTraitDamage;
  final Map<String, bool> resistancesDemonic;
  final Map<String, bool> immunitiesDemonic;
  final Map<DsaElement, bool> resistancesElemental;
  final Map<DsaElement, bool> immunitiesElemental;
  final bool bloodMagicUsed;
  final bool summonedLesserDemon;
  final bool summonedHornedDemon;
  final int additionalSummonMod;
  final int additionalControlMod;

  // Predefined creature (null = normal calculation mode)
  final PredefinedSummoning? predefined;

  // Special properties (S. 140)
  final bool causeFear;
  final int artifactAnimationLevel; // 0-3
  final bool aura;
  final bool blinkingInvisibility;
  final bool elementalShackle;
  final int elementalGripLevel; // 0-3
  final bool elementalInferno;
  final bool elementalGrowth;
  final bool drowning;
  final bool areaAttack;
  final bool flight;
  final bool frost;
  final bool ember;
  final bool criticalImmunity;
  final bool boilingBlood;
  final bool fog;
  final bool smoke;
  final bool stasis;
  final int stoneEatingLevel; // 0-6
  final int stoneSkinLevel; // 0-6
  final bool mergeWithElement;
  final bool sinking;
  final bool wildGrowth;
  final bool burst;
  final bool shatteringArmor;

  // Value modifications (S. 141)
  final int modLeP;
  final int modINI;
  final int modRS;
  final int modGS;
  final int modMR;
  final int modAT;
  final int modPA;
  final int modTP;
  final int modAttribute;
  final int modNewTalent;
  final int modTaWZfW;

  const SummoningConfig({
    required this.character,
    required this.element,
    required this.summoningType,
    this.materialPurityIndex = 3,
    this.trueNameIndex = 0,
    this.placeIndex = 6,
    this.powernodeIndex = 0,
    this.timeIndex = 3,
    this.giftIndex = 7,
    this.deedIndex = 7,
    this.properAttire = false,
    this.astralSense = false,
    this.longArm = false,
    this.lifeSense = false,
    this.resistanceMagic = false,
    this.immunityMagic = false,
    this.regenerationLevel = 0,
    this.additionalActionsLevel = 0,
    this.resistanceTraitDamage = false,
    this.immunityTraitDamage = false,
    this.resistancesDemonic = const {},
    this.immunitiesDemonic = const {},
    this.resistancesElemental = const {},
    this.immunitiesElemental = const {},
    this.bloodMagicUsed = false,
    this.summonedLesserDemon = false,
    this.summonedHornedDemon = false,
    this.additionalSummonMod = 0,
    this.additionalControlMod = 0,
    this.predefined,
    this.causeFear = false,
    this.artifactAnimationLevel = 0,
    this.aura = false,
    this.blinkingInvisibility = false,
    this.elementalShackle = false,
    this.elementalGripLevel = 0,
    this.elementalInferno = false,
    this.elementalGrowth = false,
    this.drowning = false,
    this.areaAttack = false,
    this.flight = false,
    this.frost = false,
    this.ember = false,
    this.criticalImmunity = false,
    this.boilingBlood = false,
    this.fog = false,
    this.smoke = false,
    this.stasis = false,
    this.stoneEatingLevel = 0,
    this.stoneSkinLevel = 0,
    this.mergeWithElement = false,
    this.sinking = false,
    this.wildGrowth = false,
    this.burst = false,
    this.shatteringArmor = false,
    this.modLeP = 0,
    this.modINI = 0,
    this.modRS = 0,
    this.modGS = 0,
    this.modMR = 0,
    this.modAT = 0,
    this.modPA = 0,
    this.modTP = 0,
    this.modAttribute = 0,
    this.modNewTalent = 0,
    this.modTaWZfW = 0,
  });

  SummoningConfig copyWith({
    Character? character,
    DsaElement? element,
    SummoningType? summoningType,
    int? materialPurityIndex,
    int? trueNameIndex,
    int? placeIndex,
    int? powernodeIndex,
    int? timeIndex,
    int? giftIndex,
    int? deedIndex,
    bool? properAttire,
    bool? astralSense,
    bool? longArm,
    bool? lifeSense,
    bool? resistanceMagic,
    bool? immunityMagic,
    int? regenerationLevel,
    int? additionalActionsLevel,
    bool? resistanceTraitDamage,
    bool? immunityTraitDamage,
    Map<String, bool>? resistancesDemonic,
    Map<String, bool>? immunitiesDemonic,
    Map<DsaElement, bool>? resistancesElemental,
    Map<DsaElement, bool>? immunitiesElemental,
    bool? bloodMagicUsed,
    bool? summonedLesserDemon,
    bool? summonedHornedDemon,
    int? additionalSummonMod,
    int? additionalControlMod,
    PredefinedSummoning? predefined,
    bool? causeFear,
    int? artifactAnimationLevel,
    bool? aura,
    bool? blinkingInvisibility,
    bool? elementalShackle,
    int? elementalGripLevel,
    bool? elementalInferno,
    bool? elementalGrowth,
    bool? drowning,
    bool? areaAttack,
    bool? flight,
    bool? frost,
    bool? ember,
    bool? criticalImmunity,
    bool? boilingBlood,
    bool? fog,
    bool? smoke,
    bool? stasis,
    int? stoneEatingLevel,
    int? stoneSkinLevel,
    bool? mergeWithElement,
    bool? sinking,
    bool? wildGrowth,
    bool? burst,
    bool? shatteringArmor,
    int? modLeP,
    int? modINI,
    int? modRS,
    int? modGS,
    int? modMR,
    int? modAT,
    int? modPA,
    int? modTP,
    int? modAttribute,
    int? modNewTalent,
    int? modTaWZfW,
  }) {
    return SummoningConfig(
      character: character ?? this.character,
      element: element ?? this.element,
      summoningType: summoningType ?? this.summoningType,
      materialPurityIndex: materialPurityIndex ?? this.materialPurityIndex,
      trueNameIndex: trueNameIndex ?? this.trueNameIndex,
      placeIndex: placeIndex ?? this.placeIndex,
      powernodeIndex: powernodeIndex ?? this.powernodeIndex,
      timeIndex: timeIndex ?? this.timeIndex,
      giftIndex: giftIndex ?? this.giftIndex,
      deedIndex: deedIndex ?? this.deedIndex,
      properAttire: properAttire ?? this.properAttire,
      astralSense: astralSense ?? this.astralSense,
      longArm: longArm ?? this.longArm,
      lifeSense: lifeSense ?? this.lifeSense,
      resistanceMagic: resistanceMagic ?? this.resistanceMagic,
      immunityMagic: immunityMagic ?? this.immunityMagic,
      regenerationLevel: regenerationLevel ?? this.regenerationLevel,
      additionalActionsLevel: additionalActionsLevel ?? this.additionalActionsLevel,
      resistanceTraitDamage: resistanceTraitDamage ?? this.resistanceTraitDamage,
      immunityTraitDamage: immunityTraitDamage ?? this.immunityTraitDamage,
      resistancesDemonic: resistancesDemonic ?? this.resistancesDemonic,
      immunitiesDemonic: immunitiesDemonic ?? this.immunitiesDemonic,
      resistancesElemental: resistancesElemental ?? this.resistancesElemental,
      immunitiesElemental: immunitiesElemental ?? this.immunitiesElemental,
      bloodMagicUsed: bloodMagicUsed ?? this.bloodMagicUsed,
      summonedLesserDemon: summonedLesserDemon ?? this.summonedLesserDemon,
      summonedHornedDemon: summonedHornedDemon ?? this.summonedHornedDemon,
      additionalSummonMod: additionalSummonMod ?? this.additionalSummonMod,
      additionalControlMod: additionalControlMod ?? this.additionalControlMod,
      predefined: predefined ?? this.predefined,
      causeFear: causeFear ?? this.causeFear,
      artifactAnimationLevel: artifactAnimationLevel ?? this.artifactAnimationLevel,
      aura: aura ?? this.aura,
      blinkingInvisibility: blinkingInvisibility ?? this.blinkingInvisibility,
      elementalShackle: elementalShackle ?? this.elementalShackle,
      elementalGripLevel: elementalGripLevel ?? this.elementalGripLevel,
      elementalInferno: elementalInferno ?? this.elementalInferno,
      elementalGrowth: elementalGrowth ?? this.elementalGrowth,
      drowning: drowning ?? this.drowning,
      areaAttack: areaAttack ?? this.areaAttack,
      flight: flight ?? this.flight,
      frost: frost ?? this.frost,
      ember: ember ?? this.ember,
      criticalImmunity: criticalImmunity ?? this.criticalImmunity,
      boilingBlood: boilingBlood ?? this.boilingBlood,
      fog: fog ?? this.fog,
      smoke: smoke ?? this.smoke,
      stasis: stasis ?? this.stasis,
      stoneEatingLevel: stoneEatingLevel ?? this.stoneEatingLevel,
      stoneSkinLevel: stoneSkinLevel ?? this.stoneSkinLevel,
      mergeWithElement: mergeWithElement ?? this.mergeWithElement,
      sinking: sinking ?? this.sinking,
      wildGrowth: wildGrowth ?? this.wildGrowth,
      burst: burst ?? this.burst,
      shatteringArmor: shatteringArmor ?? this.shatteringArmor,
      modLeP: modLeP ?? this.modLeP,
      modINI: modINI ?? this.modINI,
      modRS: modRS ?? this.modRS,
      modGS: modGS ?? this.modGS,
      modMR: modMR ?? this.modMR,
      modAT: modAT ?? this.modAT,
      modPA: modPA ?? this.modPA,
      modTP: modTP ?? this.modTP,
      modAttribute: modAttribute ?? this.modAttribute,
      modNewTalent: modNewTalent ?? this.modNewTalent,
      modTaWZfW: modTaWZfW ?? this.modTaWZfW,
    );
  }
}

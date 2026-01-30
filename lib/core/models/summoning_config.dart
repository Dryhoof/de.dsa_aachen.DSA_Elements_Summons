import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
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
  final bool equipment1;
  final bool equipment2;
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
    this.equipment1 = false,
    this.equipment2 = false,
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
    bool? equipment1,
    bool? equipment2,
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
      equipment1: equipment1 ?? this.equipment1,
      equipment2: equipment2 ?? this.equipment2,
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
    );
  }
}

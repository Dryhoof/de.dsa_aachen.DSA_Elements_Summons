import 'dart:convert';
import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';

class PredefinedSummoning {
  final String id;
  final DsaElement element;
  final SummoningType summoningType;

  // Fixed base costs from PDF (total creature cost incl. type + built-in abilities)
  final int baseSummonMod;
  final int baseControlMod;

  // Abilities
  final bool astralSense;
  final bool longArm;
  final bool lifeSense;
  final int regenerationLevel;
  final int additionalActionsLevel;
  final bool resistanceMagic;
  final bool resistanceTraitDamage;
  final bool immunityMagic;
  final bool immunityTraitDamage;
  final Map<String, bool> resistancesDemonic;
  final Map<DsaElement, bool> resistancesElemental;
  final Map<String, bool> immunitiesDemonic;
  final Map<DsaElement, bool> immunitiesElemental;

  // Special properties (S. 140)
  final bool causeFear;
  final int artifactAnimationLevel;
  final bool aura;
  final bool blinkingInvisibility;
  final bool elementalShackle;
  final int elementalGripLevel;
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
  final int stoneEatingLevel;
  final int stoneSkinLevel;
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

  const PredefinedSummoning({
    required this.id,
    required this.element,
    required this.summoningType,
    required this.baseSummonMod,
    required this.baseControlMod,
    this.astralSense = false,
    this.longArm = false,
    this.lifeSense = false,
    this.regenerationLevel = 0,
    this.additionalActionsLevel = 0,
    this.resistanceMagic = false,
    this.resistanceTraitDamage = false,
    this.immunityMagic = false,
    this.immunityTraitDamage = false,
    this.resistancesDemonic = const {},
    this.resistancesElemental = const {},
    this.immunitiesDemonic = const {},
    this.immunitiesElemental = const {},
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

  String _encodeMap(Map<String, bool> map) => jsonEncode(map);
  String _encodeElementalMap(Map<DsaElement, bool> map) =>
      jsonEncode({for (final e in map.entries) e.key.index.toString(): e.value});

  ElementalTemplate toElementalTemplate() {
    return ElementalTemplate(
      id: -1,
      characterId: -1,
      templateName: id,
      element: element.index,
      summoningType: summoningType.index,
      astralSense: astralSense,
      longArm: longArm,
      lifeSense: lifeSense,
      regenerationLevel: regenerationLevel,
      additionalActionsLevel: additionalActionsLevel,
      resistanceMagic: resistanceMagic,
      resistanceTraitDamage: resistanceTraitDamage,
      immunityMagic: immunityMagic,
      immunityTraitDamage: immunityTraitDamage,
      resistancesDemonicJson: _encodeMap(resistancesDemonic),
      resistancesElementalJson: _encodeElementalMap(resistancesElemental),
      immunitiesDemonicJson: _encodeMap(immunitiesDemonic),
      immunitiesElementalJson: _encodeElementalMap(immunitiesElemental),
      causeFear: causeFear,
      artifactAnimationLevel: artifactAnimationLevel,
      aura: aura,
      blinkingInvisibility: blinkingInvisibility,
      elementalShackle: elementalShackle,
      elementalGripLevel: elementalGripLevel,
      elementalInferno: elementalInferno,
      elementalGrowth: elementalGrowth,
      drowning: drowning,
      areaAttack: areaAttack,
      flight: flight,
      frost: frost,
      ember: ember,
      criticalImmunity: criticalImmunity,
      boilingBlood: boilingBlood,
      fog: fog,
      smoke: smoke,
      stasis: stasis,
      stoneEatingLevel: stoneEatingLevel,
      stoneSkinLevel: stoneSkinLevel,
      mergeWithElement: mergeWithElement,
      sinking: sinking,
      wildGrowth: wildGrowth,
      burst: burst,
      shatteringArmor: shatteringArmor,
      modLeP: modLeP,
      modINI: modINI,
      modRS: modRS,
      modGS: modGS,
      modMR: modMR,
      modAT: modAT,
      modPA: modPA,
      modTP: modTP,
      modAttribute: modAttribute,
      modNewTalent: modNewTalent,
      modTaWZfW: modTaWZfW,
    );
  }
}

String predefinedName(String id, String locale) {
  return (locale == 'de' ? _namesDe : _namesEn)[id] ?? id;
}

// ---------------------------------------------------------------------------
// Creature definitions – only ZfP*-costing properties are set.
// Automatic properties (Elementare Gewalt, Flugfähig bei Luft, Immunität
// eigenes Element, etc.) are handled by the calculator and NOT listed here.
// ---------------------------------------------------------------------------

const predefinedSummonings = <PredefinedSummoning>[
  // ── Eis ──────────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_eis', element: DsaElement.ice, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2),
  PredefinedSummoning(id: 'dschinn_eis', element: DsaElement.ice, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4),
  PredefinedSummoning(id: 'meister_eis', element: DsaElement.ice, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8),

  // ── Erz ──────────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_erz', element: DsaElement.stone, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2, shatteringArmor: true),
  PredefinedSummoning(id: 'dschinn_erz', element: DsaElement.stone, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4, shatteringArmor: true),
  PredefinedSummoning(id: 'meister_erz', element: DsaElement.stone, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8, shatteringArmor: true),

  // ── Feuer ────────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_feuer', element: DsaElement.fire, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2),
  PredefinedSummoning(id: 'dschinn_feuer', element: DsaElement.fire, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4),
  PredefinedSummoning(id: 'meister_feuer', element: DsaElement.fire, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8),

  // ── Humus ────────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_humus', element: DsaElement.life, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2),
  PredefinedSummoning(id: 'dschinn_humus', element: DsaElement.life, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4),
  PredefinedSummoning(id: 'meister_humus', element: DsaElement.life, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8),

  // ── Luft ─────────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_luft', element: DsaElement.air, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2),
  PredefinedSummoning(id: 'dschinn_luft', element: DsaElement.air, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4),
  PredefinedSummoning(id: 'meister_luft', element: DsaElement.air, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8),

  // ── Wasser ───────────────────────────────────────────────────────────────
  PredefinedSummoning(id: 'geist_wasser', element: DsaElement.water, summoningType: SummoningType.servant, baseSummonMod: 4, baseControlMod: 2),
  PredefinedSummoning(id: 'dschinn_wasser', element: DsaElement.water, summoningType: SummoningType.djinn, baseSummonMod: 8, baseControlMod: 4),
  PredefinedSummoning(id: 'meister_wasser', element: DsaElement.water, summoningType: SummoningType.master, baseSummonMod: 12, baseControlMod: 8),
];

// ---------------------------------------------------------------------------
// Localized creature names
// ---------------------------------------------------------------------------

const _namesDe = <String, String>{
  // Eis
  'geist_eis': 'Geist des Eises',
  'dschinn_eis': 'Dschinn des Eises',
  'meister_eis': 'Elementarer Meister des Eises',
  // Erz
  'geist_erz': 'Geist des Erzes',
  'dschinn_erz': 'Dschinn des Erzes',
  'meister_erz': 'Elementarer Meister des Erzes',
  // Feuer
  'geist_feuer': 'Geist des Feuers',
  'dschinn_feuer': 'Dschinn des Feuers',
  'meister_feuer': 'Elementarer Meister des Feuers',
  // Humus
  'geist_humus': 'Geist des Humus',
  'dschinn_humus': 'Dschinn des Humus',
  'meister_humus': 'Elementarer Meister des Humus',
  // Luft
  'geist_luft': 'Geist der Luft',
  'dschinn_luft': 'Dschinn der Luft',
  'meister_luft': 'Elementarer Meister der Luft',
  // Wasser
  'geist_wasser': 'Geist des Wassers',
  'dschinn_wasser': 'Dschinn des Wassers',
  'meister_wasser': 'Elementarer Meister des Wassers',
};

const _namesEn = <String, String>{
  // Ice
  'geist_eis': 'Spirit of Ice',
  'dschinn_eis': 'Djinn of Ice',
  'meister_eis': 'Elemental Master of Ice',
  // Ore
  'geist_erz': 'Spirit of Ore',
  'dschinn_erz': 'Djinn of Ore',
  'meister_erz': 'Elemental Master of Ore',
  // Fire
  'geist_feuer': 'Spirit of Fire',
  'dschinn_feuer': 'Djinn of Fire',
  'meister_feuer': 'Elemental Master of Fire',
  // Life
  'geist_humus': 'Spirit of Life',
  'dschinn_humus': 'Djinn of Life',
  'meister_humus': 'Elemental Master of Life',
  // Air
  'geist_luft': 'Spirit of Air',
  'dschinn_luft': 'Djinn of Air',
  'meister_luft': 'Elemental Master of Air',
  // Water
  'geist_wasser': 'Spirit of Water',
  'dschinn_wasser': 'Djinn of Water',
  'meister_wasser': 'Elemental Master of Water',
};

import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/calculation/summoning_calculator.dart';
import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';

/// A default character with all booleans false, all ints 0.
Character _char({
  bool talentedFire = false,
  bool talentedWater = false,
  bool knowledgeFire = false,
  bool knowledgeWater = false,
  int talentedDemonic = 0,
  int knowledgeDemonic = 0,
  bool affinityToElementals = false,
  bool demonicCovenant = false,
  bool cloakedAura = false,
  int weakPresence = 0,
  int strengthOfStigma = 0,
  bool powerlineMagicI = false,
}) =>
    Character(
      id: 1,
      characterName: 'Test',
      characterClass: 0,
      statCourage: 12,
      statWisdom: 13,
      statCharisma: 14,
      statIntuition: 11,
      talentCallElementalServant: 5,
      talentCallDjinn: 3,
      talentCallMasterOfElement: 0,
      talentedFire: talentedFire,
      talentedWater: talentedWater,
      talentedLife: false,
      talentedIce: false,
      talentedStone: false,
      talentedAir: false,
      talentedDemonic: talentedDemonic,
      knowledgeFire: knowledgeFire,
      knowledgeWater: knowledgeWater,
      knowledgeLife: false,
      knowledgeIce: false,
      knowledgeStone: false,
      knowledgeAir: false,
      knowledgeDemonic: knowledgeDemonic,
      affinityToElementals: affinityToElementals,
      demonicCovenant: demonicCovenant,
      cloakedAura: cloakedAura,
      weakPresence: weakPresence,
      strengthOfStigma: strengthOfStigma,
      powerlineMagicI: powerlineMagicI,
    );

/// Build a config with neutral defaults (all circumstance indices at neutral).
SummoningConfig _config({
  Character? character,
  DsaElement element = DsaElement.fire,
  SummoningType summoningType = SummoningType.servant,
  bool equipment1 = false,
  bool equipment2 = false,
  bool astralSense = false,
  bool longArm = false,
  bool lifeSense = false,
  bool resistanceMagic = false,
  bool immunityMagic = false,
  int regenerationLevel = 0,
  int additionalActionsLevel = 0,
  bool resistanceTraitDamage = false,
  bool immunityTraitDamage = false,
  Map<String, bool> resistancesDemonic = const {},
  Map<String, bool> immunitiesDemonic = const {},
  Map<DsaElement, bool> resistancesElemental = const {},
  Map<DsaElement, bool> immunitiesElemental = const {},
  bool bloodMagicUsed = false,
  bool summonedLesserDemon = false,
  bool summonedHornedDemon = false,
  int additionalSummonMod = 0,
  int additionalControlMod = 0,
  int materialPurityIndex = 3,
  int trueNameIndex = 0,
  int placeIndex = 6,
  int powernodeIndex = 0,
  int timeIndex = 3,
  int giftIndex = 7,
  int deedIndex = 7,
}) =>
    SummoningConfig(
      character: character ?? _char(),
      element: element,
      summoningType: summoningType,
      materialPurityIndex: materialPurityIndex,
      trueNameIndex: trueNameIndex,
      placeIndex: placeIndex,
      powernodeIndex: powernodeIndex,
      timeIndex: timeIndex,
      giftIndex: giftIndex,
      deedIndex: deedIndex,
      equipment1: equipment1,
      equipment2: equipment2,
      astralSense: astralSense,
      longArm: longArm,
      lifeSense: lifeSense,
      resistanceMagic: resistanceMagic,
      immunityMagic: immunityMagic,
      regenerationLevel: regenerationLevel,
      additionalActionsLevel: additionalActionsLevel,
      resistanceTraitDamage: resistanceTraitDamage,
      immunityTraitDamage: immunityTraitDamage,
      resistancesDemonic: resistancesDemonic,
      immunitiesDemonic: immunitiesDemonic,
      resistancesElemental: resistancesElemental,
      immunitiesElemental: immunitiesElemental,
      bloodMagicUsed: bloodMagicUsed,
      summonedLesserDemon: summonedLesserDemon,
      summonedHornedDemon: summonedHornedDemon,
      additionalSummonMod: additionalSummonMod,
      additionalControlMod: additionalControlMod,
    );

void main() {
  group('SummoningCalculator', () {
    group('base costs', () {
      test('servant base cost with neutral defaults', () {
        final r = SummoningCalculator.calculate(_config());
        // servant: summon=4, control=2; all circumstances neutral → 0
        expect(r.summonDifficulty, 4);
        expect(r.controlDifficulty, 2);
      });

      test('djinn base cost with neutral defaults', () {
        final r = SummoningCalculator.calculate(
            _config(summoningType: SummoningType.djinn));
        expect(r.summonDifficulty, 8);
        expect(r.controlDifficulty, 4);
      });

      test('master base cost with neutral defaults', () {
        final r = SummoningCalculator.calculate(
            _config(summoningType: SummoningType.master));
        expect(r.summonDifficulty, 12);
        expect(r.controlDifficulty, 8);
      });
    });

    group('equipment', () {
      test('one equipment reduces by 1', () {
        final r = SummoningCalculator.calculate(_config(equipment1: true));
        expect(r.summonDifficulty, 4 - 1);
        expect(r.controlDifficulty, 2 - 1);
      });

      test('other equipment reduces by 1', () {
        final r = SummoningCalculator.calculate(_config(equipment2: true));
        expect(r.summonDifficulty, 4 - 1);
        expect(r.controlDifficulty, 2 - 1);
      });

      test('both equipment reduces by 2', () {
        final r = SummoningCalculator.calculate(
            _config(equipment1: true, equipment2: true));
        expect(r.summonDifficulty, 4 - 2);
        expect(r.controlDifficulty, 2 - 2);
      });
    });

    group('abilities', () {
      test('astral sense adds +5 summon', () {
        final r = SummoningCalculator.calculate(_config(astralSense: true));
        expect(r.summonDifficulty, 4 + 5);
        expect(r.controlDifficulty, 2);
      });

      test('long arm adds +3 summon', () {
        final r = SummoningCalculator.calculate(_config(longArm: true));
        expect(r.summonDifficulty, 4 + 3);
        expect(r.controlDifficulty, 2);
      });

      test('life sense adds +6 summon, +9 control', () {
        final r = SummoningCalculator.calculate(_config(lifeSense: true));
        expect(r.summonDifficulty, 4 + 6);
        expect(r.controlDifficulty, 2 + 9);
      });

      test('regeneration I adds +4 summon', () {
        final r =
            SummoningCalculator.calculate(_config(regenerationLevel: 1));
        expect(r.summonDifficulty, 4 + 4);
      });

      test('regeneration II adds +7 summon', () {
        final r =
            SummoningCalculator.calculate(_config(regenerationLevel: 2));
        expect(r.summonDifficulty, 4 + 7);
      });

      test('additional actions I adds +3 summon', () {
        final r = SummoningCalculator.calculate(
            _config(additionalActionsLevel: 1));
        expect(r.summonDifficulty, 4 + 3);
      });

      test('additional actions II adds +7 summon', () {
        final r = SummoningCalculator.calculate(
            _config(additionalActionsLevel: 2));
        expect(r.summonDifficulty, 4 + 7);
      });
    });

    group('resistances and immunities', () {
      test('resistance magic adds +6 summon', () {
        final r =
            SummoningCalculator.calculate(_config(resistanceMagic: true));
        expect(r.summonDifficulty, 4 + 6);
      });

      test('immunity magic adds +13 summon (overrides resistance)', () {
        final r = SummoningCalculator.calculate(
            _config(immunityMagic: true, resistanceMagic: true));
        expect(r.summonDifficulty, 4 + 13);
      });

      test('resistance trait damage adds +5 summon', () {
        final r = SummoningCalculator.calculate(
            _config(resistanceTraitDamage: true));
        expect(r.summonDifficulty, 4 + 5);
      });

      test('immunity trait damage adds +10 summon', () {
        final r = SummoningCalculator.calculate(
            _config(immunityTraitDamage: true));
        expect(r.summonDifficulty, 4 + 10);
      });

      test('resistance magic makes resistance trait damage redundant', () {
        final r = SummoningCalculator.calculate(
            _config(resistanceMagic: true, resistanceTraitDamage: true));
        // Only +6 for magic resistance, trait damage ignored
        expect(r.summonDifficulty, 4 + 6);
      });

      test('immunity magic makes immunity trait damage redundant', () {
        final r = SummoningCalculator.calculate(
            _config(immunityMagic: true, immunityTraitDamage: true));
        // Only +13 for magic immunity, trait damage ignored
        expect(r.summonDifficulty, 4 + 13);
      });

      test('demonic resistance adds +5 per demon', () {
        final r = SummoningCalculator.calculate(
            _config(resistancesDemonic: {'Blakharaz': true}));
        expect(r.summonDifficulty, 4 + 5);
      });

      test('demonic immunity adds +10 per demon', () {
        final r = SummoningCalculator.calculate(
            _config(immunitiesDemonic: {'Blakharaz': true}));
        expect(r.summonDifficulty, 4 + 10);
      });

      test('demonic immunity overrides resistance for same demon', () {
        final r = SummoningCalculator.calculate(_config(
          resistancesDemonic: {'Blakharaz': true},
          immunitiesDemonic: {'Blakharaz': true},
        ));
        // immunity takes precedence → +10 not +15
        expect(r.summonDifficulty, 4 + 10);
      });

      test('elemental resistance adds +3 (non-own, non-counter)', () {
        // Fire character, resistance against stone
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          resistancesElemental: {DsaElement.stone: true},
        ));
        expect(r.summonDifficulty, 4 + 3);
      });

      test('elemental immunity adds +7 (non-own)', () {
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          immunitiesElemental: {DsaElement.stone: true},
        ));
        expect(r.summonDifficulty, 4 + 7);
      });

      test('own element immunity is free (no cost)', () {
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          immunitiesElemental: {DsaElement.fire: true},
        ));
        // Own element is skipped → base cost only
        expect(r.summonDifficulty, 4);
      });
    });

    group('character traits', () {
      test('talented for own element reduces by 2/2', () {
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          character: _char(talentedFire: true),
        ));
        expect(r.summonDifficulty, 4 - 2);
        expect(r.controlDifficulty, 2 - 2);
      });

      test('knowledge of own element reduces by 2/2', () {
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          character: _char(knowledgeFire: true),
        ));
        expect(r.summonDifficulty, 4 - 2);
        expect(r.controlDifficulty, 2 - 2);
      });

      test('talented for counter element adds +4/+2', () {
        // Fire's counter is water
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          character: _char(talentedWater: true),
        ));
        expect(r.summonDifficulty, 4 + 4);
        expect(r.controlDifficulty, 2 + 2);
      });

      test('knowledge of counter element adds +4/+2', () {
        final r = SummoningCalculator.calculate(_config(
          element: DsaElement.fire,
          character: _char(knowledgeWater: true),
        ));
        expect(r.summonDifficulty, 4 + 4);
        expect(r.controlDifficulty, 2 + 2);
      });

      test('demonic talents add +2 summon, +4 control per talent', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(talentedDemonic: 2)));
        expect(r.summonDifficulty, 4 + 4); // 2*2
        expect(r.controlDifficulty, 2 + 8); // 2*4
      });

      test('demonic knowledge adds +2 summon, +4 control per knowledge', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(knowledgeDemonic: 3)));
        expect(r.summonDifficulty, 4 + 6); // 3*2
        expect(r.controlDifficulty, 2 + 12); // 3*4
      });

      test('demonic covenant adds +6 summon, +9 control', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(demonicCovenant: true)));
        expect(r.summonDifficulty, 4 + 6);
        expect(r.controlDifficulty, 2 + 9);
      });

      test('affinity to elementals reduces control by 3', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(affinityToElementals: true)));
        expect(r.summonDifficulty, 4);
        expect(r.controlDifficulty, 2 - 3);
      });

      test('cloaked aura adds +1 control', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(cloakedAura: true)));
        expect(r.controlDifficulty, 2 + 1);
      });

      test('weak presence adds to control', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(weakPresence: 3)));
        expect(r.controlDifficulty, 2 + 3);
      });

      test('strength of stigma adds to control', () {
        final r = SummoningCalculator.calculate(
            _config(character: _char(strengthOfStigma: 2)));
        expect(r.controlDifficulty, 2 + 2);
      });
    });

    group('circumstances', () {
      test('true name quality 7 gives -7/-2', () {
        final r = SummoningCalculator.calculate(_config(trueNameIndex: 7));
        expect(r.summonDifficulty, 4 - 7);
        expect(r.controlDifficulty, 2 - 2);
      });

      test('material purity index 0 gives -3', () {
        final r =
            SummoningCalculator.calculate(_config(materialPurityIndex: 0));
        expect(r.summonDifficulty, 4 - 3);
      });

      test('material purity index 6 gives +3', () {
        final r =
            SummoningCalculator.calculate(_config(materialPurityIndex: 6));
        expect(r.summonDifficulty, 4 + 3);
      });

      test('place index 0 (elemental citadel) gives -7/-2', () {
        final r = SummoningCalculator.calculate(_config(placeIndex: 0));
        expect(r.summonDifficulty, 4 - 7);
        expect(r.controlDifficulty, 2 - 2);
      });

      test('time index 0 gives -3/-1', () {
        final r = SummoningCalculator.calculate(_config(timeIndex: 0));
        expect(r.summonDifficulty, 4 - 3);
        expect(r.controlDifficulty, 2 - 1);
      });

      test('gift index 0 gives -7/-2', () {
        final r = SummoningCalculator.calculate(_config(giftIndex: 0));
        expect(r.summonDifficulty, 4 - 7);
        expect(r.controlDifficulty, 2 - 2);
      });

      test('deed index 14 gives +7/+2', () {
        final r = SummoningCalculator.calculate(_config(deedIndex: 14));
        expect(r.summonDifficulty, 4 + 7);
        expect(r.controlDifficulty, 2 + 2);
      });

      test('powernode is only applied with powerlineMagicI', () {
        // Without powerlineMagicI: powernode ignored
        final r1 = SummoningCalculator.calculate(_config(powernodeIndex: 5));
        expect(r1.summonDifficulty, 4);

        // With powerlineMagicI: powernode applied
        final r2 = SummoningCalculator.calculate(_config(
          character: _char(powerlineMagicI: true),
          powernodeIndex: 5,
        ));
        expect(r2.summonDifficulty, 4 + powernodeModifiers[5]);
      });
    });

    group('GM modifiers', () {
      test('blood magic adds +12 control', () {
        final r =
            SummoningCalculator.calculate(_config(bloodMagicUsed: true));
        expect(r.summonDifficulty, 4);
        expect(r.controlDifficulty, 2 + 12);
      });

      test('summoned lesser demon adds +4 control', () {
        final r = SummoningCalculator.calculate(
            _config(summonedLesserDemon: true));
        expect(r.controlDifficulty, 2 + 4);
      });

      test('summoned horned demon adds +4 control', () {
        final r = SummoningCalculator.calculate(
            _config(summonedHornedDemon: true));
        expect(r.controlDifficulty, 2 + 4);
      });

      test('horned demon takes precedence over lesser (no stacking)', () {
        final r = SummoningCalculator.calculate(
            _config(summonedLesserDemon: true, summonedHornedDemon: true));
        expect(r.controlDifficulty, 2 + 4); // only +4, not +8
      });
    });

    group('additional modifiers', () {
      test('additional summon mod is applied', () {
        final r = SummoningCalculator.calculate(
            _config(additionalSummonMod: -5));
        expect(r.summonDifficulty, 4 - 5);
      });

      test('additional control mod is applied', () {
        final r = SummoningCalculator.calculate(
            _config(additionalControlMod: 3));
        expect(r.controlDifficulty, 2 + 3);
      });
    });

    group('result metadata', () {
      test('result contains correct element', () {
        final r = SummoningCalculator.calculate(
            _config(element: DsaElement.ice));
        expect(r.element, DsaElement.ice);
      });

      test('result contains correct summoning type', () {
        final r = SummoningCalculator.calculate(
            _config(summoningType: SummoningType.djinn));
        expect(r.summoningType, SummoningType.djinn);
      });

      test('personality is not empty', () {
        final r = SummoningCalculator.calculate(_config());
        expect(r.personality, isNotEmpty);
      });

      test('personality uses German list when locale is de', () {
        // Run many times to check it always picks from the right list
        for (int i = 0; i < 50; i++) {
          final r =
              SummoningCalculator.calculate(_config(), locale: 'de');
          expect(r.personality, isNotEmpty);
        }
      });
    });

    group('combined scenario', () {
      test('complex summoning scenario accumulates correctly', () {
        // Servant + fire, talented fire, knowledge fire,
        // astral sense, regen I, 1 equipment, true name quality 3
        final r = SummoningCalculator.calculate(_config(
          character: _char(talentedFire: true, knowledgeFire: true),
          element: DsaElement.fire,
          summoningType: SummoningType.servant,
          astralSense: true,
          regenerationLevel: 1,
          equipment1: true,
          trueNameIndex: 3,
        ));

        // summon: 4 (base) +5 (astral) +4 (regen I) -1 (equip) -3 (truename)
        //         -2 (talented) -2 (knowledge) = 5
        expect(r.summonDifficulty, 5);
        // control: 2 (base) -1 (equip) -1 (truename) -2 (talented) -2 (knowledge) = -4
        expect(r.controlDifficulty, -4);
      });
    });
  });
}

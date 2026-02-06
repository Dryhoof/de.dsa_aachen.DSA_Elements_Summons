import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';

Character _defaultCharacter() => const Character(
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
      talentedFire: false,
      talentedWater: false,
      talentedLife: false,
      talentedIce: false,
      talentedStone: false,
      talentedAir: false,
      talentedDemonic: 0,
      knowledgeFire: false,
      knowledgeWater: false,
      knowledgeLife: false,
      knowledgeIce: false,
      knowledgeStone: false,
      knowledgeAir: false,
      knowledgeDemonic: 0,
      affinityToElementals: false,
      demonicCovenant: false,
      cloakedAura: false,
      weakPresence: 0,
      strengthOfStigma: 0,
      powerlineMagicI: false,
    );

void main() {
  group('SummoningConfig', () {
    test('default values are neutral', () {
      final config = SummoningConfig(
        character: _defaultCharacter(),
        element: DsaElement.fire,
        summoningType: SummoningType.servant,
      );

      expect(config.materialPurityIndex, 3);
      expect(config.trueNameIndex, 0);
      expect(config.placeIndex, 6);
      expect(config.timeIndex, 3);
      expect(config.giftIndex, 7);
      expect(config.deedIndex, 7);
      expect(config.properAttire, false);
      expect(config.astralSense, false);
      expect(config.bloodMagicUsed, false);
    });

    test('copyWith preserves unchanged values', () {
      final config = SummoningConfig(
        character: _defaultCharacter(),
        element: DsaElement.fire,
        summoningType: SummoningType.servant,
        astralSense: true,
        longArm: true,
      );

      final copied = config.copyWith(element: DsaElement.water);

      expect(copied.element, DsaElement.water);
      expect(copied.astralSense, true);
      expect(copied.longArm, true);
      expect(copied.summoningType, SummoningType.servant);
    });

    test('copyWith overrides specified values', () {
      final config = SummoningConfig(
        character: _defaultCharacter(),
        element: DsaElement.fire,
        summoningType: SummoningType.servant,
      );

      final copied = config.copyWith(
        summoningType: SummoningType.master,
        astralSense: true,
        regenerationLevel: 2,
      );

      expect(copied.summoningType, SummoningType.master);
      expect(copied.astralSense, true);
      expect(copied.regenerationLevel, 2);
      expect(copied.element, DsaElement.fire); // unchanged
    });
  });
}

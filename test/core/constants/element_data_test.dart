import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';

void main() {
  group('element_data constants', () {
    test('materialPurityModifiers has entry for each element', () {
      for (final e in DsaElement.values) {
        expect(materialPurityModifiers.containsKey(e), true,
            reason: '${e.name} should have material purity modifiers');
        expect(materialPurityModifiers[e]!.length, 7);
      }
    });

    test('materialPurityModifiers are symmetric around 0', () {
      for (final e in DsaElement.values) {
        final mods = materialPurityModifiers[e]!;
        expect(mods[3], 0, reason: 'Middle index should be neutral');
        expect(mods.first, -3);
        expect(mods.last, 3);
      }
    });

    test('trueNameModifiers has 8 entries', () {
      expect(trueNameModifiers.length, 8);
      // First is no true name → (0,0)
      expect(trueNameModifiers[0], (0, 0));
    });

    test('placeModifiers has 14 entries', () {
      expect(placeModifiers.length, 14);
    });

    test('powernodeModifiers has 10 entries', () {
      expect(powernodeModifiers.length, 10);
      expect(powernodeModifiers[0], 0);
    });

    test('timeModifiers has 7 entries', () {
      expect(timeModifiers.length, 7);
    });

    test('giftModifiers has 15 entries with neutral at index 7', () {
      expect(giftModifiers.length, 15);
      expect(giftModifiers[7], (0, 0));
    });

    test('deedModifiers has 15 entries with neutral at index 7', () {
      expect(deedModifiers.length, 15);
      expect(deedModifiers[7], (0, 0));
    });

    test('demonNames has 8 entries', () {
      expect(demonNames.length, 8);
      expect(demonNames, contains('Blakharaz'));
      expect(demonNames, contains('Agrimoth'));
    });

    test('personalitiesEn has entry for each element', () {
      for (final e in DsaElement.values) {
        expect(personalitiesEn.containsKey(e), true);
        expect(personalitiesEn[e]!, isNotEmpty);
      }
    });

    test('personalitiesDe has entry for each element', () {
      for (final e in DsaElement.values) {
        expect(personalitiesDe.containsKey(e), true);
        expect(personalitiesDe[e]!, isNotEmpty);
      }
    });

    test('personality lists have same length in EN and DE', () {
      for (final e in DsaElement.values) {
        expect(personalitiesEn[e]!.length, personalitiesDe[e]!.length,
            reason:
                '${e.name} should have same number of personalities in EN and DE');
      }
    });
  });
}

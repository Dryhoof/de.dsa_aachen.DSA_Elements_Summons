import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';

void main() {
  group('SummoningType', () {
    test('has 3 types', () {
      expect(SummoningType.values.length, 3);
    });

    test('servant has correct costs', () {
      expect(SummoningType.servant.summonCost, 4);
      expect(SummoningType.servant.controlCost, 2);
    });

    test('djinn has correct costs', () {
      expect(SummoningType.djinn.summonCost, 8);
      expect(SummoningType.djinn.controlCost, 4);
    });

    test('master has correct costs', () {
      expect(SummoningType.master.summonCost, 12);
      expect(SummoningType.master.controlCost, 8);
    });

    test('costs increase with power level', () {
      expect(SummoningType.servant.summonCost,
          lessThan(SummoningType.djinn.summonCost));
      expect(SummoningType.djinn.summonCost,
          lessThan(SummoningType.master.summonCost));
      expect(SummoningType.servant.controlCost,
          lessThan(SummoningType.djinn.controlCost));
      expect(SummoningType.djinn.controlCost,
          lessThan(SummoningType.master.controlCost));
    });
  });
}

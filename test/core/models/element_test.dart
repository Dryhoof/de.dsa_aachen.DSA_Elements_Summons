import 'package:flutter_test/flutter_test.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';

void main() {
  group('DsaElement', () {
    test('has 6 elements', () {
      expect(DsaElement.values.length, 6);
    });

    test('counter elements are correct pairs', () {
      expect(DsaElement.fire.counterElement, DsaElement.water);
      expect(DsaElement.water.counterElement, DsaElement.fire);
      expect(DsaElement.life.counterElement, DsaElement.ice);
      expect(DsaElement.ice.counterElement, DsaElement.life);
      expect(DsaElement.stone.counterElement, DsaElement.air);
      expect(DsaElement.air.counterElement, DsaElement.stone);
    });

    test('counter elements are symmetric', () {
      for (final e in DsaElement.values) {
        expect(e.counterElement.counterElement, e,
            reason: '${e.name}.counterElement.counterElement should be ${e.name}');
      }
    });

    test('no element is its own counter', () {
      for (final e in DsaElement.values) {
        expect(e.counterElement, isNot(e),
            reason: '${e.name} should not be its own counter element');
      }
    });
  });
}

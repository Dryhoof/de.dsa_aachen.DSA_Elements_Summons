import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';

class SummoningResult {
  final int summonDifficulty;
  final int controlDifficulty;
  final String personality;
  final DsaElement element;
  final SummoningType summoningType;

  const SummoningResult({
    required this.summonDifficulty,
    required this.controlDifficulty,
    required this.personality,
    required this.element,
    required this.summoningType,
  });
}

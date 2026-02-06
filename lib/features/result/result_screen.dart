import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/calculation/summoning_calculator.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';
import 'package:dsa_elements_summons_flutter/features/summoning/summoning_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = SummoningScreen.lastConfig;

    if (config == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.result),
        ),
        body: Center(child: Text(l10n.noData)),
      );
    }

    final locale = Localizations.localeOf(context).languageCode;
    final result = SummoningCalculator.calculate(config, locale: locale);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.result),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with type, element, personality
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.summoningType.localized(l10n)} - ${result.element.localized(l10n)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${l10n.personality}: ${result.personality}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider(height: 32),
                    _modifierRow(
                      context,
                      l10n.summoningModifier,
                      result.summonDifficulty,
                    ),
                    const SizedBox(height: 8),
                    _modifierRow(
                      context,
                      l10n.controlTestModifier,
                      result.controlDifficulty,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Abilities
            if (_hasAbilities(config))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.abilities,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._buildAbilities(config, l10n),
                    ],
                  ),
                ),
              ),

            if (_hasAbilities(config)) const SizedBox(height: 12),

            // Resistances
            if (_hasResistances(config))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.resistances,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._buildResistances(config, l10n),
                    ],
                  ),
                ),
              ),

            if (_hasResistances(config)) const SizedBox(height: 12),

            // Immunities
            if (_hasImmunities(config))
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.immunities,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ..._buildImmunities(config, l10n),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Weakness
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.weakAgainst,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _bulletItem(config.element.counterElement.localized(l10n)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modifierRow(BuildContext context, String label, int value) {
    final sign = value >= 0 ? '+' : '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(width: 16),
        Text(
          '$sign$value',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  bool _hasAbilities(SummoningConfig config) {
    return config.astralSense ||
        config.longArm ||
        config.lifeSense ||
        config.regenerationLevel > 0 ||
        config.additionalActionsLevel > 0;
  }

  List<Widget> _buildAbilities(SummoningConfig config, AppLocalizations l10n) {
    final items = <String>[];
    if (config.astralSense) items.add(l10n.astralSense);
    if (config.longArm) items.add(l10n.longArm);
    if (config.lifeSense) items.add(l10n.lifeSense);
    if (config.regenerationLevel > 0) {
      items.add('${l10n.regeneration} ${'I' * config.regenerationLevel}');
    }
    if (config.additionalActionsLevel > 0) {
      items.add(
          '${l10n.additionalActions} ${'I' * config.additionalActionsLevel}');
    }
    return items.map((s) => _bulletItem(s)).toList();
  }

  bool _hasResistances(SummoningConfig config) {
    return config.resistanceMagic ||
        config.resistanceTraitDamage ||
        config.resistancesDemonic.values.any((v) => v) ||
        config.resistancesElemental.values.any((v) => v);
  }

  List<Widget> _buildResistances(
      SummoningConfig config, AppLocalizations l10n) {
    final items = <String>[];
    if (config.resistanceMagic) items.add(l10n.resistanceMagic);
    if (config.resistanceTraitDamage) items.add(l10n.resistanceTraitDamage);
    for (final entry in config.resistancesDemonic.entries) {
      if (entry.value) items.add('${l10n.resistance} ${entry.key}');
    }
    for (final entry in config.resistancesElemental.entries) {
      if (entry.value) {
        items.add('${l10n.resistance} ${entry.key.localized(l10n)}');
      }
    }
    return items.map((s) => _bulletItem(s)).toList();
  }

  bool _hasImmunities(SummoningConfig config) {
    return config.immunityMagic ||
        config.immunityTraitDamage ||
        config.immunitiesDemonic.values.any((v) => v) ||
        config.immunitiesElemental.values.any((v) => v);
  }

  List<Widget> _buildImmunities(
      SummoningConfig config, AppLocalizations l10n) {
    final items = <String>[];
    if (config.immunityMagic) items.add(l10n.immunityMagic);
    if (config.immunityTraitDamage) items.add(l10n.immunityTraitDamage);
    for (final entry in config.immunitiesDemonic.entries) {
      if (entry.value) items.add('${l10n.immunity} ${entry.key}');
    }
    for (final entry in config.immunitiesElemental.entries) {
      if (entry.value) {
        items.add('${l10n.immunity} ${entry.key.localized(l10n)}');
      }
    }
    return items.map((s) => _bulletItem(s)).toList();
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('  \u2022  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

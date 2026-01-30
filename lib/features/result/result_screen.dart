import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/calculation/summoning_calculator.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result.summoningType.name} - ${result.element.name}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  '${l10n.personality}: ${result.personality}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.weakAgainst}: ${config.element.counterElement.name}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(height: 32),
                Text(
                  '${l10n.summoningModifier}: ${result.summonDifficulty >= 0 ? '+' : ''}${result.summonDifficulty}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  '${l10n.controlTestModifier}: ${result.controlDifficulty >= 0 ? '+' : ''}${result.controlDifficulty}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

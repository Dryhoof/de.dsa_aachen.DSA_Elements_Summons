import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/character_class.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'package:dsa_elements_summons_flutter/core/providers/locale_provider.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Store templates before deletion for undo
  Map<int, List<ElementalTemplate>> _deletedTemplates = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(characterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<Locale?>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              ref.read(localeProvider.notifier).set(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Text('System'),
              ),
              const PopupMenuItem(
                value: Locale('de'),
                child: Text('Deutsch'),
              ),
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
            ],
          ),
        ],
      ),
      body: charactersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (characters) {
          if (characters.isEmpty) {
            return Center(child: Text(l10n.noCharacters));
          }
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              final className = CharacterClass
                  .values[character.characterClass]
                  .localized(l10n);
              return Dismissible(
                key: ValueKey(character.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.deleteConfirmTitle),
                      content: Text(l10n.deleteCharacterConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                  ) ?? false;

                  if (confirmed) {
                    // Save templates before deletion for potential undo
                    final db = ref.read(databaseProvider);
                    final templates = await db.getTemplatesForCharacter(character.id);
                    _deletedTemplates[character.id] = templates;
                  }

                  return confirmed;
                },
                onDismissed: (_) {
                  final db = ref.read(databaseProvider);
                  final templates = _deletedTemplates[character.id] ?? [];
                  db.deleteCharacter(character.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Text('${character.characterName} - ${l10n.characterDeleted}'),
                      action: SnackBarAction(
                        label: l10n.undo,
                        onPressed: () async {
                          // Restore character
                          final newCharId = await db.insertCharacter(CharactersCompanion.insert(
                            characterName: character.characterName,
                            characterClass: Value(character.characterClass),
                            statCourage: Value(character.statCourage),
                            statWisdom: Value(character.statWisdom),
                            statCharisma: Value(character.statCharisma),
                            statIntuition: Value(character.statIntuition),
                            talentCallElementalServant:
                                Value(character.talentCallElementalServant),
                            talentCallDjinn:
                                Value(character.talentCallDjinn),
                            talentCallMasterOfElement:
                                Value(character.talentCallMasterOfElement),
                            talentedFire: Value(character.talentedFire),
                            talentedWater: Value(character.talentedWater),
                            talentedLife: Value(character.talentedLife),
                            talentedIce: Value(character.talentedIce),
                            talentedStone: Value(character.talentedStone),
                            talentedAir: Value(character.talentedAir),
                            talentedDemonic:
                                Value(character.talentedDemonic),
                            knowledgeFire: Value(character.knowledgeFire),
                            knowledgeWater: Value(character.knowledgeWater),
                            knowledgeLife: Value(character.knowledgeLife),
                            knowledgeIce: Value(character.knowledgeIce),
                            knowledgeStone: Value(character.knowledgeStone),
                            knowledgeAir: Value(character.knowledgeAir),
                            knowledgeDemonic:
                                Value(character.knowledgeDemonic),
                            affinityToElementals:
                                Value(character.affinityToElementals),
                            demonicCovenant:
                                Value(character.demonicCovenant),
                            cloakedAura: Value(character.cloakedAura),
                            weakPresence: Value(character.weakPresence),
                            strengthOfStigma:
                                Value(character.strengthOfStigma),
                            powerlineMagicI:
                                Value(character.powerlineMagicI),
                          ));

                          // Restore all templates with new character ID
                          for (final template in templates) {
                            await db.insertTemplate(ElementalTemplatesCompanion.insert(
                              characterId: newCharId,
                              templateName: template.templateName,
                              element: Value(template.element),
                              summoningType: Value(template.summoningType),
                              astralSense: Value(template.astralSense),
                              longArm: Value(template.longArm),
                              lifeSense: Value(template.lifeSense),
                              regenerationLevel: Value(template.regenerationLevel),
                              additionalActionsLevel: Value(template.additionalActionsLevel),
                              resistanceMagic: Value(template.resistanceMagic),
                              resistanceTraitDamage: Value(template.resistanceTraitDamage),
                              immunityMagic: Value(template.immunityMagic),
                              immunityTraitDamage: Value(template.immunityTraitDamage),
                              resistancesDemonicJson: Value(template.resistancesDemonicJson),
                              resistancesElementalJson: Value(template.resistancesElementalJson),
                              immunitiesDemonicJson: Value(template.immunitiesDemonicJson),
                              immunitiesElementalJson: Value(template.immunitiesElementalJson),
                            ));
                          }

                          // Clean up
                          _deletedTemplates.remove(character.id);
                        },
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(character.characterName),
                  subtitle: Text(className),
                  onTap: () => _showOptionsBottomSheet(
                      context, character),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/character/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, Character character) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/character/${character.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: Text(l10n.summon),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/summon/${character.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(l10n.elementals),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/character/${character.id}/elementals');
              },
            ),
          ],
        ),
      ),
    );
  }
}

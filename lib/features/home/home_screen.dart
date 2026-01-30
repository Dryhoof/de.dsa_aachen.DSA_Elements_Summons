import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/character_class.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(characterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
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
                  .name;
              return Dismissible(
                key: ValueKey(character.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  final db = ref.read(databaseProvider);
                  db.deleteCharacter(character.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${character.characterName} deleted'),
                      action: SnackBarAction(
                        label: l10n.undo,
                        onPressed: () {
                          db.insertCharacter(CharactersCompanion.insert(
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
          ],
        ),
      ),
    );
  }
}

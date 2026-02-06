import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class ElementalTemplatesScreen extends ConsumerWidget {
  final int characterId;

  const ElementalTemplatesScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final templatesAsync = ref.watch(elementalTemplatesProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.elementalTemplates),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (templates) {
          if (templates.isEmpty) {
            return Center(child: Text(l10n.noTemplates));
          }
          return ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              final element = DsaElement.values[template.element];
              final type = SummoningType.values[template.summoningType];
              return Dismissible(
                key: ValueKey(template.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.deleteConfirmTitle),
                      content: Text(l10n.deleteTemplateConfirm),
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
                },
                onDismissed: (_) {
                  final db = ref.read(databaseProvider);
                  db.deleteTemplate(template.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      content: Text(
                          '${template.templateName} - ${l10n.templateDeleted}'),
                      action: SnackBarAction(
                        label: l10n.undo,
                        onPressed: () {
                          _reinsertTemplate(ref, template);
                        },
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(template.templateName),
                  subtitle: Text(
                      '${type.localized(l10n)} - ${element.localized(l10n)}'),
                  onTap: () => context.push(
                      '/character/$characterId/elementals/${template.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.auto_fix_high),
                    tooltip: l10n.summon,
                    onPressed: () => context.push(
                        '/summon/$characterId?templateId=${template.id}'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/character/$characterId/elementals/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _reinsertTemplate(WidgetRef ref, ElementalTemplate template) {
    final db = ref.read(databaseProvider);
    db.insertTemplate(ElementalTemplatesCompanion.insert(
      characterId: template.characterId,
      templateName: template.templateName,
    ));
  }
}

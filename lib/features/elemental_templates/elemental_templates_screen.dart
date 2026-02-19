import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/constants/predefined_summonings.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class ElementalTemplatesScreen extends ConsumerWidget {
  final int characterId;

  const ElementalTemplatesScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final templatesAsync = ref.watch(elementalTemplatesProvider(characterId));
    final hiddenAsync = ref.watch(hiddenPredefinedProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.elementalTemplates),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_off),
            tooltip: l10n.managePredefined,
            onPressed: () => _showManageHiddenDialog(context, ref, l10n, locale),
          ),
        ],
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (templates) {
          final hiddenIds = hiddenAsync.valueOrNull ?? [];
          final visiblePredefined = predefinedSummonings
              .where((p) => !hiddenIds.contains(p.id))
              .toList();

          final hasPredefined = visiblePredefined.isNotEmpty;
          final hasTemplates = templates.isNotEmpty;

          if (!hasPredefined && !hasTemplates) {
            return Center(child: Text(l10n.noTemplates));
          }

          return ListView(
            children: [
              // Predefined summonings section
              if (hasPredefined) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    l10n.predefinedSummonings,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                ...visiblePredefined.map((p) {
                  final element = p.element;
                  final type = p.summoningType;
                  return ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(predefinedName(p.id, locale)),
                    subtitle: Text(
                        '${type.localized(l10n)} - ${element.localized(l10n)}'),
                    onTap: () => context.push(
                        '/summon/$characterId?predefinedId=${p.id}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.visibility_off, size: 20),
                      tooltip: l10n.hide,
                      onPressed: () {
                        final db = ref.read(databaseProvider);
                        db.hidePredefined(characterId, p.id);
                      },
                    ),
                  );
                }),
              ],
              // User templates section
              if (hasTemplates) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    l10n.elementalTemplates,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                ...templates.map((template) {
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
                }),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/character/$characterId/elementals/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showManageHiddenDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n, String locale) {
    final db = ref.read(databaseProvider);
    showDialog(
      context: context,
      builder: (ctx) => _ManageHiddenDialog(
        characterId: characterId,
        db: db,
        l10n: l10n,
        locale: locale,
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

class _ManageHiddenDialog extends StatefulWidget {
  final int characterId;
  final AppDatabase db;
  final AppLocalizations l10n;
  final String locale;

  const _ManageHiddenDialog({
    required this.characterId,
    required this.db,
    required this.l10n,
    required this.locale,
  });

  @override
  State<_ManageHiddenDialog> createState() => _ManageHiddenDialogState();
}

class _ManageHiddenDialogState extends State<_ManageHiddenDialog> {
  List<String> _hiddenIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ids = await widget.db.getHiddenPredefinedIds(widget.characterId);
    setState(() {
      _hiddenIds = ids;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hiddenPredefined = predefinedSummonings
        .where((p) => _hiddenIds.contains(p.id))
        .toList();

    return AlertDialog(
      title: Text(widget.l10n.hiddenPredefined),
      content: _isLoading
          ? const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator()),
            )
          : hiddenPredefined.isEmpty
              ? Text(widget.l10n.noHiddenPredefined)
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: hiddenPredefined.length,
                    itemBuilder: (context, index) {
                      final p = hiddenPredefined[index];
                      return ListTile(
                        dense: true,
                        title: Text(predefinedName(p.id, widget.locale)),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility, size: 20),
                          tooltip: widget.l10n.unhide,
                          onPressed: () async {
                            await widget.db
                                .unhidePredefined(widget.characterId, p.id);
                            await _load();
                          },
                        ),
                      );
                    },
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}

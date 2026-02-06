import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class ElementalTemplateEditScreen extends ConsumerStatefulWidget {
  final int characterId;
  final int? templateId;

  const ElementalTemplateEditScreen({
    super.key,
    required this.characterId,
    this.templateId,
  });

  @override
  ConsumerState<ElementalTemplateEditScreen> createState() =>
      _ElementalTemplateEditScreenState();
}

class _ElementalTemplateEditScreenState
    extends ConsumerState<ElementalTemplateEditScreen> {
  final _nameCtrl = TextEditingController();
  bool _isDirty = false;
  bool _isLoading = true;
  ElementalTemplate? _existing;

  DsaElement _element = DsaElement.fire;
  SummoningType _summoningType = SummoningType.servant;

  bool _astralSense = false;
  bool _longArm = false;
  bool _lifeSense = false;
  int _regenerationLevel = 0;
  int _additionalActionsLevel = 0;

  bool _resistanceMagic = false;
  bool _resistanceTraitDamage = false;
  bool _immunityMagic = false;
  bool _immunityTraitDamage = false;

  late Map<String, bool> _resistancesDemonic;
  late Map<String, bool> _immunitiesDemonic;
  late Map<DsaElement, bool> _resistancesElemental;
  late Map<DsaElement, bool> _immunitiesElemental;

  @override
  void initState() {
    super.initState();
    _resistancesDemonic = {for (final d in demonNames) d: false};
    _immunitiesDemonic = {for (final d in demonNames) d: false};
    _resistancesElemental = {for (final e in DsaElement.values) e: false};
    _immunitiesElemental = {for (final e in DsaElement.values) e: false};
    _immunitiesElemental[_element] = true;
    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    if (widget.templateId != null) {
      final db = ref.read(databaseProvider);
      final t = await db.getTemplateById(widget.templateId!);
      _existing = t;
      _nameCtrl.text = t.templateName;
      _element = DsaElement.values[t.element];
      _summoningType = SummoningType.values[t.summoningType];
      _astralSense = t.astralSense;
      _longArm = t.longArm;
      _lifeSense = t.lifeSense;
      _regenerationLevel = t.regenerationLevel;
      _additionalActionsLevel = t.additionalActionsLevel;
      _resistanceMagic = t.resistanceMagic;
      _resistanceTraitDamage = t.resistanceTraitDamage;
      _immunityMagic = t.immunityMagic;
      _immunityTraitDamage = t.immunityTraitDamage;
      _resistancesDemonic = _decodeDemonicMap(t.resistancesDemonicJson);
      _immunitiesDemonic = _decodeDemonicMap(t.immunitiesDemonicJson);
      _resistancesElemental = _decodeElementalMap(t.resistancesElementalJson);
      _immunitiesElemental = _decodeElementalMap(t.immunitiesElementalJson);
    }
    setState(() {
      _isLoading = false;
      _isDirty = false;
    });
  }

  Map<String, bool> _decodeDemonicMap(String json) {
    final base = {for (final d in demonNames) d: false};
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      if (base.containsKey(entry.key)) {
        base[entry.key] = entry.value as bool;
      }
    }
    return base;
  }

  Map<DsaElement, bool> _decodeElementalMap(String json) {
    final base = {for (final e in DsaElement.values) e: false};
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      final idx = int.tryParse(entry.key);
      if (idx != null && idx < DsaElement.values.length) {
        base[DsaElement.values[idx]] = entry.value as bool;
      }
    }
    return base;
  }

  String _encodeDemonicMap(Map<String, bool> map) =>
      jsonEncode(map.map((k, v) => MapEntry(k, v)));

  String _encodeElementalMap(Map<DsaElement, bool> map) =>
      jsonEncode(map.map((k, v) => MapEntry(k.index.toString(), v)));

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _isOwnElement(DsaElement e) => e == _element;
  bool _isCounterElement(DsaElement e) => e == _element.counterElement;

  void _onElementChanged(DsaElement newElement) {
    setState(() {
      _element = newElement;
      _isDirty = true;
      for (final e in DsaElement.values) {
        _resistancesElemental[e] = false;
        _immunitiesElemental[e] = false;
      }
      _immunitiesElemental[_element] = true;
    });
  }

  void _onImmunityMagicChanged(bool? value) {
    setState(() {
      _immunityMagic = value ?? false;
      _isDirty = true;
      // Don't reset resistance/immunity values - just disable the checkboxes
      // The calculator already ignores resistances when immunity is active
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorTemplateName)),
      );
      return;
    }

    final db = ref.read(databaseProvider);

    // Check if another template with this name already exists
    final existingTemplates = await db.getTemplatesForCharacter(widget.characterId);
    final conflicting = existingTemplates.where((t) =>
        t.templateName == name && t.id != (_existing?.id ?? -1)).firstOrNull;

    if (conflicting != null && mounted) {
      // Ask for confirmation to overwrite
      final shouldOverwrite = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.overwriteTemplateTitle),
          content: Text(l10n.overwriteTemplateMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.overwrite),
            ),
          ],
        ),
      );

      if (shouldOverwrite != true) return;

      // Delete the conflicting template, we'll use its slot
      await db.deleteTemplate(conflicting.id);
    }

    if (_existing != null) {
      await db.updateTemplate(ElementalTemplate(
        id: _existing!.id,
        characterId: widget.characterId,
        templateName: name,
        element: _element.index,
        summoningType: _summoningType.index,
        astralSense: _astralSense,
        longArm: _longArm,
        lifeSense: _lifeSense,
        regenerationLevel: _regenerationLevel,
        additionalActionsLevel: _additionalActionsLevel,
        resistanceMagic: _resistanceMagic,
        resistanceTraitDamage: _resistanceTraitDamage,
        immunityMagic: _immunityMagic,
        immunityTraitDamage: _immunityTraitDamage,
        resistancesDemonicJson: _encodeDemonicMap(_resistancesDemonic),
        resistancesElementalJson: _encodeElementalMap(_resistancesElemental),
        immunitiesDemonicJson: _encodeDemonicMap(_immunitiesDemonic),
        immunitiesElementalJson: _encodeElementalMap(_immunitiesElemental),
      ));
    } else {
      await db.insertTemplate(ElementalTemplatesCompanion.insert(
        characterId: widget.characterId,
        templateName: name,
        element: Value(_element.index),
        summoningType: Value(_summoningType.index),
        astralSense: Value(_astralSense),
        longArm: Value(_longArm),
        lifeSense: Value(_lifeSense),
        regenerationLevel: Value(_regenerationLevel),
        additionalActionsLevel: Value(_additionalActionsLevel),
        resistanceMagic: Value(_resistanceMagic),
        resistanceTraitDamage: Value(_resistanceTraitDamage),
        immunityMagic: Value(_immunityMagic),
        immunityTraitDamage: Value(_immunityTraitDamage),
        resistancesDemonicJson: Value(_encodeDemonicMap(_resistancesDemonic)),
        resistancesElementalJson:
            Value(_encodeElementalMap(_resistancesElemental)),
        immunitiesDemonicJson: Value(_encodeDemonicMap(_immunitiesDemonic)),
        immunitiesElementalJson:
            Value(_encodeElementalMap(_immunitiesElemental)),
      ));
    }

    _isDirty = false;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templateSaved)),
      );
      context.pop();
    }
  }

  Future<void> _handleBack() async {
    if (!_isDirty) {
      context.pop();
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.unsavedChangesTitle),
        content: Text(l10n.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'discard'),
            child: Text(l10n.discard),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'save'),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (action == 'save') {
      await _save();
    } else if (action == 'discard') {
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(widget.templateId != null
              ? l10n.editTemplate
              : l10n.newTemplate),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          title: Text(widget.templateId != null
              ? l10n.editTemplate
              : l10n.newTemplate),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _save,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.templateName),
                onChanged: (_) => setState(() => _isDirty = true),
              ),
            ),
            const SizedBox(height: 8),

            // Element & Type
            ExpansionTile(
              title: Text(l10n.elementAndType),
              initiallyExpanded: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<DsaElement>(
                    isExpanded: true,
                    initialValue: _element,
                    decoration: InputDecoration(labelText: l10n.element),
                    items: DsaElement.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.localized(l10n)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) _onElementChanged(v);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<SummoningType>(
                    segments: SummoningType.values
                        .map((t) => ButtonSegment(
                              value: t,
                              label: Text(t.localized(l10n)),
                            ))
                        .toList(),
                    selected: {_summoningType},
                    onSelectionChanged: (v) => setState(() {
                      _summoningType = v.first;
                      _isDirty = true;
                    }),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),

            // Abilities
            ExpansionTile(
              title: Text(l10n.abilities),
              children: [
                CheckboxListTile(
                  title: Text(l10n.astralSense),
                  value: _astralSense,
                  onChanged: (v) => setState(() {
                    _astralSense = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text(l10n.longArm),
                  value: _longArm,
                  onChanged: (v) => setState(() {
                    _longArm = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text(l10n.lifeSense),
                  value: _lifeSense,
                  onChanged: (v) => setState(() {
                    _lifeSense = v ?? false;
                    _isDirty = true;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.regeneration),
                      const SizedBox(height: 4),
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment(value: 0, label: Text(l10n.no)),
                          const ButtonSegment(value: 1, label: Text('I')),
                          const ButtonSegment(value: 2, label: Text('II')),
                        ],
                        selected: {_regenerationLevel},
                        onSelectionChanged: (v) => setState(() {
                          _regenerationLevel = v.first;
                          _isDirty = true;
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.additionalActions),
                      const SizedBox(height: 4),
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment(value: 0, label: Text(l10n.no)),
                          const ButtonSegment(value: 1, label: Text('I')),
                          const ButtonSegment(value: 2, label: Text('II')),
                        ],
                        selected: {_additionalActionsLevel},
                        onSelectionChanged: (v) => setState(() {
                          _additionalActionsLevel = v.first;
                          _isDirty = true;
                        }),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),

            // Resistances
            ExpansionTile(
              title: Text(l10n.resistances),
              children: [
                CheckboxListTile(
                  title: Text(l10n.resistanceMagic),
                  value: _resistanceMagic,
                  onChanged: _immunityMagic
                      ? null
                      : (v) => setState(() {
                            _resistanceMagic = v ?? false;
                            _isDirty = true;
                          }),
                ),
                CheckboxListTile(
                  title: Text(l10n.resistanceTraitDamage),
                  value: _resistanceTraitDamage,
                  onChanged: (_resistanceMagic ||
                          _immunityMagic ||
                          _immunityTraitDamage)
                      ? null
                      : (v) => setState(() {
                            _resistanceTraitDamage = v ?? false;
                            _isDirty = true;
                          }),
                ),
                ...demonNames.map((name) => CheckboxListTile(
                      title: Text('${l10n.resistance} $name'),
                      value: _resistancesDemonic[name],
                      onChanged: (_immunitiesDemonic[name] == true)
                          ? null
                          : (v) => setState(() {
                                _resistancesDemonic[name] = v ?? false;
                                _isDirty = true;
                              }),
                    )),
                ...DsaElement.values.map((e) => CheckboxListTile(
                      title:
                          Text('${l10n.resistance} ${e.localized(l10n)}'),
                      value: _resistancesElemental[e],
                      onChanged:
                          (_isOwnElement(e) || _isCounterElement(e) ||
                                  _immunitiesElemental[e] == true)
                              ? null
                              : (v) => setState(() {
                                    _resistancesElemental[e] = v ?? false;
                                    _isDirty = true;
                                  }),
                    )),
              ],
            ),

            // Immunities
            ExpansionTile(
              title: Text(l10n.immunities),
              children: [
                CheckboxListTile(
                  title: Text(l10n.immunityMagic),
                  value: _immunityMagic,
                  onChanged: _onImmunityMagicChanged,
                ),
                CheckboxListTile(
                  title: Text(l10n.immunityTraitDamage),
                  value: _immunityTraitDamage,
                  onChanged: _immunityMagic
                      ? null
                      : (v) => setState(() {
                            _immunityTraitDamage = v ?? false;
                            _isDirty = true;
                          }),
                ),
                ...demonNames.map((name) => CheckboxListTile(
                      title: Text('${l10n.immunity} $name'),
                      value: _immunitiesDemonic[name],
                      onChanged: (v) => setState(() {
                        _immunitiesDemonic[name] = v ?? false;
                        _isDirty = true;
                      }),
                    )),
                ...DsaElement.values.map((e) => CheckboxListTile(
                      title:
                          Text('${l10n.immunity} ${e.localized(l10n)}'),
                      value: _immunitiesElemental[e],
                      onChanged:
                          (_isOwnElement(e) || _isCounterElement(e))
                              ? null
                              : (v) => setState(() {
                                    _immunitiesElemental[e] = v ?? false;
                                    _isDirty = true;
                                  }),
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

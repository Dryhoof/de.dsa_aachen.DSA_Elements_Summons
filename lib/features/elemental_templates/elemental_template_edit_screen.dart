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

  // New general properties (S. 140)
  bool _causeFear = false;
  int _artifactAnimationLevel = 0;
  bool _aura = false;
  bool _blinkingInvisibility = false;
  bool _elementalShackle = false;
  int _elementalGripLevel = 0;
  bool _elementalInferno = false;
  bool _elementalGrowth = false;
  bool _drowning = false;
  bool _areaAttack = false;
  bool _flight = false;
  bool _frost = false;
  bool _ember = false;
  bool _criticalImmunity = false;
  bool _boilingBlood = false;
  bool _fog = false;
  bool _smoke = false;
  bool _stasis = false;
  int _stoneEatingLevel = 0;
  int _stoneSkinLevel = 0;
  bool _mergeWithElement = false;
  bool _sinking = false;
  bool _wildGrowth = false;
  bool _burst = false;
  bool _shatteringArmor = false;

  // Value modifications (S. 141)
  int _modLeP = 0;
  int _modINI = 0;
  int _modRS = 0;
  int _modGS = 0;
  int _modMR = 0;
  int _modAT = 0;
  int _modPA = 0;
  int _modTP = 0;
  int _modAttribute = 0;
  int _modNewTalent = 0;
  int _modTaWZfW = 0;

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

      // New properties
      _causeFear = t.causeFear;
      _artifactAnimationLevel = t.artifactAnimationLevel;
      _aura = t.aura;
      _blinkingInvisibility = t.blinkingInvisibility;
      _elementalShackle = t.elementalShackle;
      _elementalGripLevel = t.elementalGripLevel;
      _elementalInferno = t.elementalInferno;
      _elementalGrowth = t.elementalGrowth;
      _drowning = t.drowning;
      _areaAttack = t.areaAttack;
      _flight = t.flight;
      _frost = t.frost;
      _ember = t.ember;
      _criticalImmunity = t.criticalImmunity;
      _boilingBlood = t.boilingBlood;
      _fog = t.fog;
      _smoke = t.smoke;
      _stasis = t.stasis;
      _stoneEatingLevel = t.stoneEatingLevel;
      _stoneSkinLevel = t.stoneSkinLevel;
      _mergeWithElement = t.mergeWithElement;
      _sinking = t.sinking;
      _wildGrowth = t.wildGrowth;
      _burst = t.burst;
      _shatteringArmor = t.shatteringArmor;

      // Value modifications
      _modLeP = t.modLeP;
      _modINI = t.modINI;
      _modRS = t.modRS;
      _modGS = t.modGS;
      _modMR = t.modMR;
      _modAT = t.modAT;
      _modPA = t.modPA;
      _modTP = t.modTP;
      _modAttribute = t.modAttribute;
      _modNewTalent = t.modNewTalent;
      _modTaWZfW = t.modTaWZfW;
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
        causeFear: _causeFear,
        artifactAnimationLevel: _artifactAnimationLevel,
        aura: _aura,
        blinkingInvisibility: _blinkingInvisibility,
        elementalShackle: _elementalShackle,
        elementalGripLevel: _elementalGripLevel,
        elementalInferno: _elementalInferno,
        elementalGrowth: _elementalGrowth,
        drowning: _drowning,
        areaAttack: _areaAttack,
        flight: _flight,
        frost: _frost,
        ember: _ember,
        criticalImmunity: _criticalImmunity,
        boilingBlood: _boilingBlood,
        fog: _fog,
        smoke: _smoke,
        stasis: _stasis,
        stoneEatingLevel: _stoneEatingLevel,
        stoneSkinLevel: _stoneSkinLevel,
        mergeWithElement: _mergeWithElement,
        sinking: _sinking,
        wildGrowth: _wildGrowth,
        burst: _burst,
        shatteringArmor: _shatteringArmor,
        modLeP: _modLeP,
        modINI: _modINI,
        modRS: _modRS,
        modGS: _modGS,
        modMR: _modMR,
        modAT: _modAT,
        modPA: _modPA,
        modTP: _modTP,
        modAttribute: _modAttribute,
        modNewTalent: _modNewTalent,
        modTaWZfW: _modTaWZfW,
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
        resistancesElementalJson: Value(_encodeElementalMap(_resistancesElemental)),
        immunitiesDemonicJson: Value(_encodeDemonicMap(_immunitiesDemonic)),
        immunitiesElementalJson: Value(_encodeElementalMap(_immunitiesElemental)),
        causeFear: Value(_causeFear),
        artifactAnimationLevel: Value(_artifactAnimationLevel),
        aura: Value(_aura),
        blinkingInvisibility: Value(_blinkingInvisibility),
        elementalShackle: Value(_elementalShackle),
        elementalGripLevel: Value(_elementalGripLevel),
        elementalInferno: Value(_elementalInferno),
        elementalGrowth: Value(_elementalGrowth),
        drowning: Value(_drowning),
        areaAttack: Value(_areaAttack),
        flight: Value(_flight),
        frost: Value(_frost),
        ember: Value(_ember),
        criticalImmunity: Value(_criticalImmunity),
        boilingBlood: Value(_boilingBlood),
        fog: Value(_fog),
        smoke: Value(_smoke),
        stasis: Value(_stasis),
        stoneEatingLevel: Value(_stoneEatingLevel),
        stoneSkinLevel: Value(_stoneSkinLevel),
        mergeWithElement: Value(_mergeWithElement),
        sinking: Value(_sinking),
        wildGrowth: Value(_wildGrowth),
        burst: Value(_burst),
        shatteringArmor: Value(_shatteringArmor),
        modLeP: Value(_modLeP),
        modINI: Value(_modINI),
        modRS: Value(_modRS),
        modGS: Value(_modGS),
        modMR: Value(_modMR),
        modAT: Value(_modAT),
        modPA: Value(_modPA),
        modTP: Value(_modTP),
        modAttribute: Value(_modAttribute),
        modNewTalent: Value(_modNewTalent),
        modTaWZfW: Value(_modTaWZfW),
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

  Widget _buildModifierRow(String label, String cost, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text('$label ($cost)')),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 32,
            child: Text('$value', textAlign: TextAlign.center),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: value < 10 ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
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

            // Abilities (merged with Special Properties)
            ExpansionTile(
              title: Text(l10n.abilities),
              children: [
                // Original abilities with ZfP* costs
                CheckboxListTile(
                  title: Text('${l10n.astralSense} (${l10n.astralSenseCost})'),
                  value: _astralSense,
                  onChanged: (v) => setState(() {
                    _astralSense = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.longArm} (${l10n.longArmCost})'),
                  value: _longArm,
                  onChanged: (v) => setState(() {
                    _longArm = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.lifeSense} (${l10n.lifeSenseCost})'),
                  value: _lifeSense,
                  onChanged: (v) => setState(() {
                    _lifeSense = v ?? false;
                    _isDirty = true;
                  }),
                ),
                ListTile(
                  title: Text('${l10n.regeneration} (I: ${l10n.regenerationCostI}, II: ${l10n.regenerationCostII})'),
                  subtitle: SegmentedButton<int>(
                    showSelectedIcon: false,
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
                ),
                ListTile(
                  title: Text('${l10n.additionalActions} (I: ${l10n.additionalActionsCostI}, II: ${l10n.additionalActionsCostII})'),
                  subtitle: SegmentedButton<int>(
                    showSelectedIcon: false,
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
                ),
                // Additional special properties
                CheckboxListTile(
                  title: Text('${l10n.causeFear} (${l10n.causeFearCost})'),
                  value: _causeFear,
                  onChanged: (v) => setState(() {
                    _causeFear = v ?? false;
                    _isDirty = true;
                  }),
                ),
                ListTile(
                  title: Text('${l10n.artifactAnimation} (${l10n.artifactAnimationCost})'),
                  subtitle: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 0, label: Text(l10n.no)),
                      const ButtonSegment(value: 1, label: Text('I')),
                      const ButtonSegment(value: 2, label: Text('II')),
                      const ButtonSegment(value: 3, label: Text('III')),
                    ],
                    selected: {_artifactAnimationLevel},
                    onSelectionChanged: (v) => setState(() {
                      _artifactAnimationLevel = v.first;
                      _isDirty = true;
                    }),
                  ),
                ),
                CheckboxListTile(
                  title: Text('${l10n.aura} (${l10n.auraCost})'),
                  value: _aura,
                  onChanged: (v) => setState(() {
                    _aura = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.blinkingInvisibility} (${l10n.blinkingInvisibilityCost})'),
                  value: _blinkingInvisibility,
                  onChanged: (v) => setState(() {
                    _blinkingInvisibility = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.elementalShackle} (${l10n.elementalShackleCost})'),
                  value: _elementalShackle,
                  onChanged: (v) => setState(() {
                    _elementalShackle = v ?? false;
                    _isDirty = true;
                  }),
                ),
                ListTile(
                  title: Text('${l10n.elementalGrip} (${l10n.elementalGripCost})'),
                  subtitle: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 0, label: Text(l10n.no)),
                      const ButtonSegment(value: 1, label: Text('I')),
                      const ButtonSegment(value: 2, label: Text('II')),
                      const ButtonSegment(value: 3, label: Text('III')),
                    ],
                    selected: {_elementalGripLevel},
                    onSelectionChanged: (v) => setState(() {
                      _elementalGripLevel = v.first;
                      _isDirty = true;
                    }),
                  ),
                ),
                CheckboxListTile(
                  title: Text('${l10n.elementalInferno} (${l10n.elementalInfernoCost})'),
                  value: _elementalInferno,
                  onChanged: (v) => setState(() {
                    _elementalInferno = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.elementalGrowth} (${l10n.elementalGrowthCost})'),
                  value: _elementalGrowth,
                  onChanged: (v) => setState(() {
                    _elementalGrowth = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.areaAttack} (${l10n.areaAttackCost})'),
                  value: _areaAttack,
                  onChanged: (v) => setState(() {
                    _areaAttack = v ?? false;
                    _isDirty = true;
                  }),
                ),
                // Flight - not available for Stone
                if (_element != DsaElement.stone)
                  CheckboxListTile(
                    title: Text('${l10n.flight} (${l10n.flightCost})'),
                    value: _flight,
                    onChanged: (v) => setState(() {
                      _flight = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                CheckboxListTile(
                  title: Text('${l10n.criticalImmunity} (${l10n.criticalImmunityCost})'),
                  value: _criticalImmunity,
                  onChanged: (v) => setState(() {
                    _criticalImmunity = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.mergeWithElement} (${l10n.mergeWithElementCost})'),
                  value: _mergeWithElement,
                  onChanged: (v) => setState(() {
                    _mergeWithElement = v ?? false;
                    _isDirty = true;
                  }),
                ),
                CheckboxListTile(
                  title: Text('${l10n.burst} (${l10n.burstCost})'),
                  value: _burst,
                  onChanged: (v) => setState(() {
                    _burst = v ?? false;
                    _isDirty = true;
                  }),
                ),
              ],
            ),

            // Element-Specific Properties
            ExpansionTile(
              title: Text(l10n.elementSpecificProperties),
              children: [
                // Frost - only Ice
                if (_element == DsaElement.ice)
                  CheckboxListTile(
                    title: Text('${l10n.frost} (${l10n.frostCost})'),
                    value: _frost,
                    onChanged: (v) => setState(() {
                      _frost = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Ember - Fire, Stone
                if (_element == DsaElement.fire || _element == DsaElement.stone)
                  CheckboxListTile(
                    title: Text('${l10n.ember} (${l10n.emberCost})'),
                    value: _ember,
                    onChanged: (v) => setState(() {
                      _ember = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Fog - Water, Air
                if (_element == DsaElement.water || _element == DsaElement.air)
                  CheckboxListTile(
                    title: Text('${l10n.fog} (${l10n.fogCost})'),
                    value: _fog,
                    onChanged: (v) => setState(() {
                      _fog = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Smoke - Fire, Air
                if (_element == DsaElement.fire || _element == DsaElement.air)
                  CheckboxListTile(
                    title: Text('${l10n.smoke} (${l10n.smokeCost})'),
                    value: _smoke,
                    onChanged: (v) => setState(() {
                      _smoke = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Drowning - Water
                if (_element == DsaElement.water)
                  CheckboxListTile(
                    title: Text('${l10n.drowning} (${l10n.drowningCost})'),
                    value: _drowning,
                    onChanged: (v) => setState(() {
                      _drowning = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Boiling Blood - Fire, Water
                if (_element == DsaElement.fire || _element == DsaElement.water)
                  CheckboxListTile(
                    title: Text('${l10n.boilingBlood} (${l10n.boilingBloodCost})'),
                    value: _boilingBlood,
                    onChanged: (v) => setState(() {
                      _boilingBlood = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Stasis - Stone, Ice, Life
                if (_element == DsaElement.stone || _element == DsaElement.ice || _element == DsaElement.life)
                  CheckboxListTile(
                    title: Text('${l10n.stasis} (${l10n.stasisCost})'),
                    value: _stasis,
                    onChanged: (v) => setState(() {
                      _stasis = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Stone Eating - Stone, Ice
                if (_element == DsaElement.stone || _element == DsaElement.ice)
                  ListTile(
                    title: Text('${l10n.stoneEating} (${l10n.stoneEatingCost})'),
                    subtitle: SegmentedButton<int>(
                      showSelectedIcon: false,
                      segments: List.generate(7, (i) => ButtonSegment(
                        value: i,
                        label: Text(i == 0 ? l10n.no : '$i'),
                      )),
                      selected: {_stoneEatingLevel},
                      onSelectionChanged: (v) => setState(() {
                        _stoneEatingLevel = v.first;
                        _isDirty = true;
                      }),
                    ),
                  ),
                // Stoneskin - Stone, Life
                if (_element == DsaElement.stone || _element == DsaElement.life)
                  ListTile(
                    title: Text('${l10n.stoneSkin} (${l10n.stoneSkinCost})'),
                    subtitle: SegmentedButton<int>(
                      showSelectedIcon: false,
                      segments: List.generate(7, (i) => ButtonSegment(
                        value: i,
                        label: Text(i == 0 ? l10n.no : '$i'),
                      )),
                      selected: {_stoneSkinLevel},
                      onSelectionChanged: (v) => setState(() {
                        _stoneSkinLevel = v.first;
                        _isDirty = true;
                      }),
                    ),
                  ),
                // Sinking - Life, Water
                if (_element == DsaElement.life || _element == DsaElement.water)
                  CheckboxListTile(
                    title: Text('${l10n.sinking} (${l10n.sinkingCost})'),
                    value: _sinking,
                    onChanged: (v) => setState(() {
                      _sinking = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Wild Growth - Life only
                if (_element == DsaElement.life)
                  CheckboxListTile(
                    title: Text('${l10n.wildGrowth} (${l10n.wildGrowthCost})'),
                    value: _wildGrowth,
                    onChanged: (v) => setState(() {
                      _wildGrowth = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                // Shattering Armor - Stone, Life, Fire, Ice
                if (_element == DsaElement.stone || _element == DsaElement.life ||
                    _element == DsaElement.fire || _element == DsaElement.ice)
                  CheckboxListTile(
                    title: Text('${l10n.shatteringArmor} (${l10n.shatteringArmorCost})'),
                    value: _shatteringArmor,
                    onChanged: (v) => setState(() {
                      _shatteringArmor = v ?? false;
                      _isDirty = true;
                    }),
                  ),
                const SizedBox(height: 8),
              ],
            ),

            // Value Modifications
            ExpansionTile(
              title: Text(l10n.valueModifications),
              children: [
                _buildModifierRow(l10n.modLeP, l10n.modLePCost, _modLeP, (v) => setState(() { _modLeP = v; _isDirty = true; })),
                _buildModifierRow(l10n.modINI, l10n.modINICost, _modINI, (v) => setState(() { _modINI = v; _isDirty = true; })),
                _buildModifierRow(l10n.modRS, l10n.modRSCost, _modRS, (v) => setState(() { _modRS = v; _isDirty = true; })),
                _buildModifierRow(l10n.modGS, l10n.modGSCost, _modGS, (v) => setState(() { _modGS = v; _isDirty = true; })),
                _buildModifierRow(l10n.modMR, l10n.modMRCost, _modMR, (v) => setState(() { _modMR = v; _isDirty = true; })),
                _buildModifierRow(l10n.modAT, l10n.modATCost, _modAT, (v) => setState(() { _modAT = v; _isDirty = true; })),
                _buildModifierRow(l10n.modPA, l10n.modPACost, _modPA, (v) => setState(() { _modPA = v; _isDirty = true; })),
                _buildModifierRow(l10n.modTP, l10n.modTPCost, _modTP, (v) => setState(() { _modTP = v; _isDirty = true; })),
                _buildModifierRow(l10n.modAttribute, l10n.modAttributeCost, _modAttribute, (v) => setState(() { _modAttribute = v; _isDirty = true; })),
                _buildModifierRow(l10n.modNewTalent, l10n.modNewTalentCost, _modNewTalent, (v) => setState(() { _modNewTalent = v; _isDirty = true; })),
                _buildModifierRow(l10n.modTaWZfW, l10n.modTaWZfWCost, _modTaWZfW, (v) => setState(() { _modTaWZfW = v; _isDirty = true; })),
                const SizedBox(height: 8),
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

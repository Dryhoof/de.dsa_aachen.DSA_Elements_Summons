import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';
import 'package:dsa_elements_summons_flutter/core/models/character_class.dart';
import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/calculation/summoning_calculator.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class SummoningScreen extends ConsumerStatefulWidget {
  final int characterId;
  final int? initialTemplateId;

  const SummoningScreen({super.key, required this.characterId, this.initialTemplateId});

  static SummoningConfig? lastConfig;

  @override
  ConsumerState<SummoningScreen> createState() => _SummoningScreenState();
}

class _SummoningScreenState extends ConsumerState<SummoningScreen> {
  Character? _character;
  bool _isLoading = true;
  String? _loadedTemplateName;

  DsaElement _element = DsaElement.fire;
  SummoningType _summoningType = SummoningType.servant;
  bool _equipment1 = false;
  bool _equipment2 = false;

  int _materialPurityIndex = 3;
  int _trueNameIndex = 0;
  int _placeIndex = 6;
  int _powernodeIndex = 0;
  int _timeIndex = 3;
  int _giftIndex = 7;
  int _deedIndex = 7;

  bool _astralSense = false;
  bool _longArm = false;
  bool _lifeSense = false;
  int _regenerationLevel = 0;
  int _additionalActionsLevel = 0;

  bool _resistanceMagic = false;
  bool _resistanceTraitDamage = false;
  bool _immunityMagic = false;
  bool _immunityTraitDamage = false;

  final Map<String, bool> _resistancesDemonic = {
    for (final d in demonNames) d: false,
  };
  final Map<String, bool> _immunitiesDemonic = {
    for (final d in demonNames) d: false,
  };
  late Map<DsaElement, bool> _resistancesElemental;
  late Map<DsaElement, bool> _immunitiesElemental;

  bool _bloodMagicUsed = false;
  bool _summonedLesserDemon = false;
  bool _summonedHornedDemon = false;
  final TextEditingController _additionalSummonCtrl =
      TextEditingController(text: '0');
  final TextEditingController _additionalControlCtrl =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _resetElementalMaps();
    _loadCharacter();
  }

  void _resetElementalMaps() {
    _resistancesElemental = {
      for (final e in DsaElement.values) e: false,
    };
    _immunitiesElemental = {
      for (final e in DsaElement.values) e: false,
    };
    _immunitiesElemental[_element] = true; // own element auto-checked
  }

  Future<void> _loadCharacter() async {
    final db = ref.read(databaseProvider);
    final c = await db.getCharacterById(widget.characterId);
    setState(() {
      _character = c;
      _isLoading = false;
    });
    if (widget.initialTemplateId != null) {
      final t = await db.getTemplateById(widget.initialTemplateId!);
      _loadFromTemplate(t);
      _loadedTemplateName = t.templateName;
    }
  }

  @override
  void dispose() {
    _additionalSummonCtrl.dispose();
    _additionalControlCtrl.dispose();
    super.dispose();
  }

  SummoningConfig _buildConfig() {
    return SummoningConfig(
      character: _character!,
      element: _element,
      summoningType: _summoningType,
      materialPurityIndex: _materialPurityIndex,
      trueNameIndex: _trueNameIndex,
      placeIndex: _placeIndex,
      powernodeIndex: _powernodeIndex,
      timeIndex: _timeIndex,
      giftIndex: _giftIndex,
      deedIndex: _deedIndex,
      equipment1: _equipment1,
      equipment2: _equipment2,
      astralSense: _astralSense,
      longArm: _longArm,
      lifeSense: _lifeSense,
      resistanceMagic: _resistanceMagic,
      immunityMagic: _immunityMagic,
      regenerationLevel: _regenerationLevel,
      additionalActionsLevel: _additionalActionsLevel,
      resistanceTraitDamage: _resistanceTraitDamage,
      immunityTraitDamage: _immunityTraitDamage,
      resistancesDemonic: Map.of(_resistancesDemonic),
      immunitiesDemonic: Map.of(_immunitiesDemonic),
      resistancesElemental: Map.of(_resistancesElemental),
      immunitiesElemental: Map.of(_immunitiesElemental),
      bloodMagicUsed: _bloodMagicUsed,
      summonedLesserDemon: _summonedLesserDemon,
      summonedHornedDemon: _summonedHornedDemon,
      additionalSummonMod: int.tryParse(_additionalSummonCtrl.text) ?? 0,
      additionalControlMod: int.tryParse(_additionalControlCtrl.text) ?? 0,
    );
  }

  void _onElementChanged(DsaElement newElement) {
    setState(() {
      _element = newElement;
      // Reset elemental resistance/immunity
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
      // Don't reset resistance/immunity values - just disable the checkboxes
      // The calculator already ignores resistances when immunity is active
    });
  }

  String _equipmentLabel1(AppLocalizations l10n) {
    if (_character == null) return '';
    final cc = CharacterClass.values[_character!.characterClass];
    switch (cc) {
      case CharacterClass.mage:
        return l10n.equipmentMage1;
      case CharacterClass.druid:
        return l10n.equipmentDruid1;
      case CharacterClass.geode:
        return l10n.equipmentGeode1;
      case CharacterClass.cristalomant:
        return l10n.equipmentCristalomant1;
      case CharacterClass.shaman:
        return l10n.equipmentShaman1;
    }
  }

  String _equipmentLabel2(AppLocalizations l10n) {
    if (_character == null) return '';
    final cc = CharacterClass.values[_character!.characterClass];
    switch (cc) {
      case CharacterClass.mage:
        return l10n.equipmentMage2;
      case CharacterClass.druid:
        return l10n.equipmentDruid2;
      case CharacterClass.geode:
        return l10n.equipmentGeode2;
      case CharacterClass.cristalomant:
        return l10n.equipmentCristalomant2;
      case CharacterClass.shaman:
        return l10n.equipmentShaman2;
    }
  }

  bool _isOwnElement(DsaElement e) => e == _element;
  bool _isCounterElement(DsaElement e) => e == _element.counterElement;

  void _loadFromTemplate(ElementalTemplate t) {
    setState(() {
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

      // Decode demonic maps
      final resDem = jsonDecode(t.resistancesDemonicJson) as Map<String, dynamic>;
      for (final d in demonNames) {
        _resistancesDemonic[d] = (resDem[d] as bool?) ?? false;
      }
      final immDem = jsonDecode(t.immunitiesDemonicJson) as Map<String, dynamic>;
      for (final d in demonNames) {
        _immunitiesDemonic[d] = (immDem[d] as bool?) ?? false;
      }

      // Decode elemental maps
      final resElem = jsonDecode(t.resistancesElementalJson) as Map<String, dynamic>;
      for (final e in DsaElement.values) {
        _resistancesElemental[e] = (resElem[e.index.toString()] as bool?) ?? false;
      }
      final immElem = jsonDecode(t.immunitiesElementalJson) as Map<String, dynamic>;
      for (final e in DsaElement.values) {
        _immunitiesElemental[e] = (immElem[e.index.toString()] as bool?) ?? false;
      }
    });
  }

  Future<void> _showLoadTemplateSheet() async {
    final db = ref.read(databaseProvider);
    final templates = await db.getTemplatesForCharacter(widget.characterId);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noTemplates)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: templates.map((t) {
            final elem = DsaElement.values[t.element];
            final type = SummoningType.values[t.summoningType];
            return ListTile(
              title: Text(t.templateName),
              subtitle: Text('${type.localized(l10n)} - ${elem.localized(l10n)}'),
              onTap: () {
                Navigator.pop(ctx);
                _loadFromTemplate(t);
                _loadedTemplateName = t.templateName;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.templateLoaded)),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showSaveAsTemplateDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: _loadedTemplateName ?? '');
    final formKey = GlobalKey<FormState>();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.saveAsTemplate),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameCtrl,
            decoration: InputDecoration(labelText: l10n.templateName),
            autofocus: true,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.errorTemplateName : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, nameCtrl.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    final db = ref.read(databaseProvider);

    // Check if template with this name already exists
    final existingTemplates = await db.getTemplatesForCharacter(widget.characterId);
    final existing = existingTemplates.where((t) => t.templateName == name).firstOrNull;

    if (existing != null && mounted) {
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
    }

    String encodeDemonic(Map<String, bool> m) =>
        jsonEncode(m.map((k, v) => MapEntry(k, v)));
    String encodeElemental(Map<DsaElement, bool> m) =>
        jsonEncode(m.map((k, v) => MapEntry(k.index.toString(), v)));

    if (existing != null) {
      // Update existing template
      await db.updateTemplate(ElementalTemplate(
        id: existing.id,
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
        resistancesDemonicJson: encodeDemonic(_resistancesDemonic),
        resistancesElementalJson: encodeElemental(_resistancesElemental),
        immunitiesDemonicJson: encodeDemonic(_immunitiesDemonic),
        immunitiesElementalJson: encodeElemental(_immunitiesElemental),
      ));
    } else {
      // Insert new template
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
        resistancesDemonicJson: Value(encodeDemonic(_resistancesDemonic)),
        resistancesElementalJson: Value(encodeElemental(_resistancesElemental)),
        immunitiesDemonicJson: Value(encodeDemonic(_immunitiesDemonic)),
        immunitiesElementalJson: Value(encodeElemental(_immunitiesElemental)),
      ));
    }

    _loadedTemplateName = name;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.templateSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading || _character == null) {
      return Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.summoning),
      ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final config = _buildConfig();
    final result = SummoningCalculator.calculate(config);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.summoning),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: l10n.loadTemplate,
            onPressed: _showLoadTemplateSheet,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: l10n.saveAsTemplate,
            onPressed: _showSaveAsTemplateDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                // Section 1: Element & Type
                ExpansionTile(
                  title: Text(l10n.elementAndType),
                  initiallyExpanded: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<DsaElement>(
                        initialValue: _element,
                        decoration:
                            InputDecoration(labelText: l10n.element),
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
                        onSelectionChanged: (v) =>
                            setState(() => _summoningType = v.first),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(_equipmentLabel1(l10n)),
                      value: _equipment1,
                      onChanged: (v) =>
                          setState(() => _equipment1 = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(_equipmentLabel2(l10n)),
                      value: _equipment2,
                      onChanged: (v) =>
                          setState(() => _equipment2 = v ?? false),
                    ),
                  ],
                ),

                // Section 2: Circumstances
                ExpansionTile(
                  title: Text(l10n.circumstances),
                  children: [
                    _dropdownTile<int>(
                      label: l10n.materialPurity,
                      value: _materialPurityIndex,
                      items: List.generate(7, (i) => i),
                      labelFn: (i) => '${l10n.quality} ${i + 1}',
                      onChanged: (v) =>
                          setState(() => _materialPurityIndex = v ?? 3),
                    ),
                    _dropdownTile<int>(
                      label: l10n.trueName,
                      value: _trueNameIndex,
                      items: List.generate(8, (i) => i),
                      labelFn: (i) =>
                          i == 0 ? l10n.none : '${l10n.quality} $i',
                      onChanged: (v) =>
                          setState(() => _trueNameIndex = v ?? 0),
                    ),
                    _dropdownTile<int>(
                      label: l10n.place,
                      value: _placeIndex,
                      items: List.generate(14, (i) => i),
                      labelFn: (i) => placeLabel(i, l10n),
                      onChanged: (v) =>
                          setState(() => _placeIndex = v ?? 6),
                    ),
                    _dropdownTile<int>(
                      label: l10n.powernode,
                      value: _powernodeIndex,
                      items: List.generate(10, (i) => i),
                      labelFn: (i) => '${l10n.powernode} ${i + 1}',
                      onChanged: _character!.powerlineMagicI
                          ? (v) =>
                              setState(() => _powernodeIndex = v ?? 0)
                          : null,
                    ),
                    _dropdownTile<int>(
                      label: l10n.time,
                      value: _timeIndex,
                      items: List.generate(7, (i) => i),
                      labelFn: (i) => timeLabel(i, l10n),
                      onChanged: (v) =>
                          setState(() => _timeIndex = v ?? 3),
                    ),
                    _dropdownTile<int>(
                      label: l10n.gift,
                      value: _giftIndex,
                      items: List.generate(15, (i) => i),
                      labelFn: (i) => giftLabel(i, l10n),
                      onChanged: (v) =>
                          setState(() => _giftIndex = v ?? 7),
                    ),
                    _dropdownTile<int>(
                      label: l10n.deed,
                      value: _deedIndex,
                      items: List.generate(15, (i) => i),
                      labelFn: (i) => deedLabel(i, l10n),
                      onChanged: (v) =>
                          setState(() => _deedIndex = v ?? 7),
                    ),
                  ],
                ),

                // Section 3: Abilities
                ExpansionTile(
                  title: Text(l10n.abilities),
                  children: [
                    CheckboxListTile(
                      title: Text(l10n.astralSense),
                      value: _astralSense,
                      onChanged: (v) =>
                          setState(() => _astralSense = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.longArm),
                      value: _longArm,
                      onChanged: (v) =>
                          setState(() => _longArm = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.lifeSense),
                      value: _lifeSense,
                      onChanged: (v) =>
                          setState(() => _lifeSense = v ?? false),
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
                            onSelectionChanged: (v) =>
                                setState(() => _regenerationLevel = v.first),
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
                            onSelectionChanged: (v) => setState(
                                () => _additionalActionsLevel = v.first),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),

                // Section 4: Resistances
                ExpansionTile(
                  title: Text(l10n.resistances),
                  children: [
                    CheckboxListTile(
                      title: Text(l10n.resistanceMagic),
                      value: _resistanceMagic,
                      onChanged: _immunityMagic
                          ? null
                          : (v) => setState(
                              () => _resistanceMagic = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.resistanceTraitDamage),
                      value: _resistanceTraitDamage,
                      onChanged: (_resistanceMagic ||
                              _immunityMagic ||
                              _immunityTraitDamage)
                          ? null
                          : (v) => setState(
                              () => _resistanceTraitDamage = v ?? false),
                    ),
                    ...demonNames.map((name) => CheckboxListTile(
                          title: Text('${l10n.resistance} $name'),
                          value: _resistancesDemonic[name],
                          onChanged: (_immunitiesDemonic[name] == true)
                              ? null
                              : (v) => setState(
                                  () => _resistancesDemonic[name] = v ?? false),
                        )),
                    ...DsaElement.values.map((e) => CheckboxListTile(
                          title: Text('${l10n.resistance} ${e.localized(l10n)}'),
                          value: _resistancesElemental[e],
                          onChanged: (_isOwnElement(e) ||
                                  _isCounterElement(e) ||
                                  _immunitiesElemental[e] == true)
                              ? null
                              : (v) => setState(
                                  () => _resistancesElemental[e] = v ?? false),
                        )),
                  ],
                ),

                // Section 5: Immunities
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
                          : (v) => setState(
                              () => _immunityTraitDamage = v ?? false),
                    ),
                    ...demonNames.map((name) => CheckboxListTile(
                          title: Text('${l10n.immunity} $name'),
                          value: _immunitiesDemonic[name],
                          onChanged: (v) => setState(
                              () => _immunitiesDemonic[name] = v ?? false),
                        )),
                    ...DsaElement.values.map((e) => CheckboxListTile(
                          title: Text('${l10n.immunity} ${e.localized(l10n)}'),
                          value: _immunitiesElemental[e],
                          onChanged: (_isOwnElement(e) ||
                                  _isCounterElement(e))
                              ? null
                              : (v) => setState(
                                  () => _immunitiesElemental[e] = v ?? false),
                        )),
                  ],
                ),

                // Section 6: GM Modifiers
                ExpansionTile(
                  title: Text(l10n.gmModifiers),
                  children: [
                    CheckboxListTile(
                      title: Text(l10n.bloodMagicUsed),
                      value: _bloodMagicUsed,
                      onChanged: (v) =>
                          setState(() => _bloodMagicUsed = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.summonedLesserDemon),
                      value: _summonedLesserDemon,
                      onChanged: (v) =>
                          setState(() => _summonedLesserDemon = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.summonedHornedDemon),
                      value: _summonedHornedDemon,
                      onChanged: (v) =>
                          setState(() => _summonedHornedDemon = v ?? false),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _additionalSummonCtrl,
                        decoration: InputDecoration(
                            labelText: l10n.additionalSummonMod),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: _additionalControlCtrl,
                        decoration: InputDecoration(
                            labelText: l10n.additionalControlMod),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // Sticky bottom bar
          Material(
            elevation: 8,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.summonLabel}: ${result.summonDifficulty >= 0 ? '+' : ''}${result.summonDifficulty}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${l10n.controlLabel}: ${result.controlDifficulty >= 0 ? '+' : ''}${result.controlDifficulty}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        SummoningScreen.lastConfig = _buildConfig();
                        context.push('/result');
                      },
                      child: Text(l10n.calculate),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _dropdownTile<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelFn,
    required ValueChanged<T?>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((i) => DropdownMenuItem(value: i, child: Text(labelFn(i))))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

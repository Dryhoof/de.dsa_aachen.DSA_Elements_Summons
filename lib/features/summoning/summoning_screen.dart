import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_type.dart';
import 'package:dsa_elements_summons_flutter/core/models/summoning_config.dart';
import 'package:dsa_elements_summons_flutter/core/constants/element_data.dart';
import 'package:dsa_elements_summons_flutter/core/calculation/summoning_calculator.dart';
import 'package:dsa_elements_summons_flutter/core/l10n_helpers.dart';
import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:dsa_elements_summons_flutter/core/constants/predefined_summonings.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class SummoningScreen extends ConsumerStatefulWidget {
  final int characterId;
  final int? initialTemplateId;
  final String? initialPredefinedId;

  const SummoningScreen({super.key, required this.characterId, this.initialTemplateId, this.initialPredefinedId});

  static SummoningConfig? lastConfig;

  @override
  ConsumerState<SummoningScreen> createState() => _SummoningScreenState();
}

class _SummoningScreenState extends ConsumerState<SummoningScreen> {
  Character? _character;
  bool _isLoading = true;
  String? _loadedTemplateName;
  PredefinedSummoning? _activePredefined;

  DsaElement _element = DsaElement.fire;
  SummoningType _summoningType = SummoningType.servant;
  bool _properAttire = false;

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
    } else if (widget.initialPredefinedId != null) {
      final p = predefinedSummonings
          .where((s) => s.id == widget.initialPredefinedId)
          .firstOrNull;
      if (p != null) {
        _loadFromTemplate(p.toElementalTemplate());
        _activePredefined = p;
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          _loadedTemplateName = predefinedName(p.id, locale);
        }
      }
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
      properAttire: _properAttire,
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
      predefined: _activePredefined,
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

  bool get _isPredefined => _activePredefined != null;
  /// Whether a boolean ability is locked because the predefined creature has it.
  bool _lockedBool(bool Function(PredefinedSummoning p) getter) =>
      _isPredefined && getter(_activePredefined!);
  /// Minimum level for a level-based ability from predefined creature.
  int _predefinedMin(int Function(PredefinedSummoning p) getter) =>
      _isPredefined ? getter(_activePredefined!) : 0;
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
    });
  }

  Future<void> _showLoadTemplateSheet() async {
    final db = ref.read(databaseProvider);
    final templates = await db.getTemplatesForCharacter(widget.characterId);
    final hiddenIds = await db.getHiddenPredefinedIds(widget.characterId);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    final visiblePredefined = predefinedSummonings
        .where((p) => !hiddenIds.contains(p.id))
        .toList();

    if (templates.isEmpty && visiblePredefined.isEmpty) {
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
          children: [
            if (visiblePredefined.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  l10n.predefinedSummonings,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ...visiblePredefined.map((p) {
                final elem = p.element;
                final type = p.summoningType;
                return ListTile(
                  leading: const Icon(Icons.menu_book, size: 20),
                  title: Text(predefinedName(p.id, locale)),
                  subtitle: Text('${type.localized(l10n)} - ${elem.localized(l10n)}'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _loadFromTemplate(p.toElementalTemplate());
                    _activePredefined = p;
                    _loadedTemplateName = predefinedName(p.id, locale);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.templateLoaded)),
                    );
                  },
                );
              }),
            ],
            if (templates.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  l10n.elementalTemplates,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ...templates.map((t) {
                final elem = DsaElement.values[t.element];
                final type = SummoningType.values[t.summoningType];
                return ListTile(
                  title: Text(t.templateName),
                  subtitle: Text('${type.localized(l10n)} - ${elem.localized(l10n)}'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _loadFromTemplate(t);
                    _activePredefined = null;
                    _loadedTemplateName = t.templateName;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.templateLoaded)),
                    );
                  },
                );
              }),
            ],
          ],
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
                        onChanged: _isPredefined
                            ? null
                            : (v) {
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
                        onSelectionChanged: _isPredefined
                            ? null
                            : (v) => setState(() => _summoningType = v.first),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.properAttire),
                      value: _properAttire,
                      onChanged: (v) =>
                          setState(() => _properAttire = v ?? false),
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

                // Section 3: Abilities (merged with Special Properties)
                ExpansionTile(
                  title: Text(l10n.abilities),
                  children: [
                    // Original abilities with ZfP* costs
                    CheckboxListTile(
                      title: Text('${l10n.astralSense} (${l10n.astralSenseCost})'),
                      value: _astralSense,
                      onChanged: _lockedBool((p) => p.astralSense) ? null : (v) =>
                          setState(() => _astralSense = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.longArm} (${l10n.longArmCost})'),
                      value: _longArm,
                      onChanged: _lockedBool((p) => p.longArm) ? null : (v) =>
                          setState(() => _longArm = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.lifeSense} (${l10n.lifeSenseCost})'),
                      value: _lifeSense,
                      onChanged: _lockedBool((p) => p.lifeSense) ? null : (v) =>
                          setState(() => _lifeSense = v ?? false),
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
                        onSelectionChanged: (v) {
                          final min = _predefinedMin((p) => p.regenerationLevel);
                          if (v.first >= min) setState(() => _regenerationLevel = v.first);
                        },
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
                        onSelectionChanged: (v) {
                          final min = _predefinedMin((p) => p.additionalActionsLevel);
                          if (v.first >= min) setState(() => _additionalActionsLevel = v.first);
                        },
                      ),
                    ),
                    // Additional special properties
                    CheckboxListTile(
                      title: Text('${l10n.causeFear} (${l10n.causeFearCost})'),
                      value: _causeFear,
                      onChanged: _lockedBool((p) => p.causeFear) ? null : (v) => setState(() => _causeFear = v ?? false),
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
                        onSelectionChanged: (v) {
                          final min = _predefinedMin((p) => p.artifactAnimationLevel);
                          if (v.first >= min) setState(() => _artifactAnimationLevel = v.first);
                        },
                      ),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.aura} (${l10n.auraCost})'),
                      value: _aura,
                      onChanged: _lockedBool((p) => p.aura) ? null : (v) => setState(() => _aura = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.blinkingInvisibility} (${l10n.blinkingInvisibilityCost})'),
                      value: _blinkingInvisibility,
                      onChanged: _lockedBool((p) => p.blinkingInvisibility) ? null : (v) => setState(() => _blinkingInvisibility = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.elementalShackle} (${l10n.elementalShackleCost})'),
                      value: _elementalShackle,
                      onChanged: _lockedBool((p) => p.elementalShackle) ? null : (v) => setState(() => _elementalShackle = v ?? false),
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
                        onSelectionChanged: (v) {
                          final min = _predefinedMin((p) => p.elementalGripLevel);
                          if (v.first >= min) setState(() => _elementalGripLevel = v.first);
                        },
                      ),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.elementalInferno} (${l10n.elementalInfernoCost})'),
                      value: _elementalInferno,
                      onChanged: _lockedBool((p) => p.elementalInferno) ? null : (v) => setState(() => _elementalInferno = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.elementalGrowth} (${l10n.elementalGrowthCost})'),
                      value: _elementalGrowth,
                      onChanged: _lockedBool((p) => p.elementalGrowth) ? null : (v) => setState(() => _elementalGrowth = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.areaAttack} (${l10n.areaAttackCost})'),
                      value: _areaAttack,
                      onChanged: _lockedBool((p) => p.areaAttack) ? null : (v) => setState(() => _areaAttack = v ?? false),
                    ),
                    if (_element != DsaElement.stone)
                      CheckboxListTile(
                        title: Text('${l10n.flight} (${l10n.flightCost})'),
                        value: _flight,
                        onChanged: _lockedBool((p) => p.flight) ? null : (v) => setState(() => _flight = v ?? false),
                      ),
                    CheckboxListTile(
                      title: Text('${l10n.criticalImmunity} (${l10n.criticalImmunityCost})'),
                      value: _criticalImmunity,
                      onChanged: _lockedBool((p) => p.criticalImmunity) ? null : (v) => setState(() => _criticalImmunity = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.mergeWithElement} (${l10n.mergeWithElementCost})'),
                      value: _mergeWithElement,
                      onChanged: _lockedBool((p) => p.mergeWithElement) ? null : (v) => setState(() => _mergeWithElement = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text('${l10n.burst} (${l10n.burstCost})'),
                      value: _burst,
                      onChanged: _lockedBool((p) => p.burst) ? null : (v) => setState(() => _burst = v ?? false),
                    ),
                  ],
                ),

                // Section: Element-Specific Properties
                ExpansionTile(
                  title: Text(l10n.elementSpecificProperties),
                  children: [
                    if (_element == DsaElement.ice)
                      CheckboxListTile(
                        title: Text('${l10n.frost} (${l10n.frostCost})'),
                        value: _frost,
                        onChanged: _lockedBool((p) => p.frost) ? null : (v) => setState(() => _frost = v ?? false),
                      ),
                    if (_element == DsaElement.fire || _element == DsaElement.stone)
                      CheckboxListTile(
                        title: Text('${l10n.ember} (${l10n.emberCost})'),
                        value: _ember,
                        onChanged: _lockedBool((p) => p.ember) ? null : (v) => setState(() => _ember = v ?? false),
                      ),
                    if (_element == DsaElement.water || _element == DsaElement.air)
                      CheckboxListTile(
                        title: Text('${l10n.fog} (${l10n.fogCost})'),
                        value: _fog,
                        onChanged: _lockedBool((p) => p.fog) ? null : (v) => setState(() => _fog = v ?? false),
                      ),
                    if (_element == DsaElement.fire || _element == DsaElement.air)
                      CheckboxListTile(
                        title: Text('${l10n.smoke} (${l10n.smokeCost})'),
                        value: _smoke,
                        onChanged: _lockedBool((p) => p.smoke) ? null : (v) => setState(() => _smoke = v ?? false),
                      ),
                    if (_element == DsaElement.water)
                      CheckboxListTile(
                        title: Text('${l10n.drowning} (${l10n.drowningCost})'),
                        value: _drowning,
                        onChanged: _lockedBool((p) => p.drowning) ? null : (v) => setState(() => _drowning = v ?? false),
                      ),
                    if (_element == DsaElement.fire || _element == DsaElement.water)
                      CheckboxListTile(
                        title: Text('${l10n.boilingBlood} (${l10n.boilingBloodCost})'),
                        value: _boilingBlood,
                        onChanged: _lockedBool((p) => p.boilingBlood) ? null : (v) => setState(() => _boilingBlood = v ?? false),
                      ),
                    if (_element == DsaElement.stone || _element == DsaElement.ice || _element == DsaElement.life)
                      CheckboxListTile(
                        title: Text('${l10n.stasis} (${l10n.stasisCost})'),
                        value: _stasis,
                        onChanged: _lockedBool((p) => p.stasis) ? null : (v) => setState(() => _stasis = v ?? false),
                      ),
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
                          onSelectionChanged: (v) {
                            final min = _predefinedMin((p) => p.stoneEatingLevel);
                            if (v.first >= min) setState(() => _stoneEatingLevel = v.first);
                          },
                        ),
                      ),
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
                          onSelectionChanged: (v) {
                            final min = _predefinedMin((p) => p.stoneSkinLevel);
                            if (v.first >= min) setState(() => _stoneSkinLevel = v.first);
                          },
                        ),
                      ),
                    if (_element == DsaElement.life || _element == DsaElement.water)
                      CheckboxListTile(
                        title: Text('${l10n.sinking} (${l10n.sinkingCost})'),
                        value: _sinking,
                        onChanged: _lockedBool((p) => p.sinking) ? null : (v) => setState(() => _sinking = v ?? false),
                      ),
                    if (_element == DsaElement.life)
                      CheckboxListTile(
                        title: Text('${l10n.wildGrowth} (${l10n.wildGrowthCost})'),
                        value: _wildGrowth,
                        onChanged: _lockedBool((p) => p.wildGrowth) ? null : (v) => setState(() => _wildGrowth = v ?? false),
                      ),
                    if (_element == DsaElement.stone || _element == DsaElement.life ||
                        _element == DsaElement.fire || _element == DsaElement.ice)
                      CheckboxListTile(
                        title: Text('${l10n.shatteringArmor} (${l10n.shatteringArmorCost})'),
                        value: _shatteringArmor,
                        onChanged: _lockedBool((p) => p.shatteringArmor) ? null : (v) => setState(() => _shatteringArmor = v ?? false),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),

                // Section: Value Modifications
                ExpansionTile(
                  title: Text(l10n.valueModifications),
                  children: [
                    _buildModifierRow(l10n.modLeP, l10n.modLePCost, _modLeP, (v) => setState(() => _modLeP = v)),
                    _buildModifierRow(l10n.modINI, l10n.modINICost, _modINI, (v) => setState(() => _modINI = v)),
                    _buildModifierRow(l10n.modRS, l10n.modRSCost, _modRS, (v) => setState(() => _modRS = v)),
                    _buildModifierRow(l10n.modGS, l10n.modGSCost, _modGS, (v) => setState(() => _modGS = v)),
                    _buildModifierRow(l10n.modMR, l10n.modMRCost, _modMR, (v) => setState(() => _modMR = v)),
                    _buildModifierRow(l10n.modAT, l10n.modATCost, _modAT, (v) => setState(() => _modAT = v)),
                    _buildModifierRow(l10n.modPA, l10n.modPACost, _modPA, (v) => setState(() => _modPA = v)),
                    _buildModifierRow(l10n.modTP, l10n.modTPCost, _modTP, (v) => setState(() => _modTP = v)),
                    _buildModifierRow(l10n.modAttribute, l10n.modAttributeCost, _modAttribute, (v) => setState(() => _modAttribute = v)),
                    _buildModifierRow(l10n.modNewTalent, l10n.modNewTalentCost, _modNewTalent, (v) => setState(() => _modNewTalent = v)),
                    _buildModifierRow(l10n.modTaWZfW, l10n.modTaWZfWCost, _modTaWZfW, (v) => setState(() => _modTaWZfW = v)),
                    const SizedBox(height: 8),
                  ],
                ),

                // Section 4: Resistances
                ExpansionTile(
                  title: Text(l10n.resistances),
                  children: [
                    CheckboxListTile(
                      title: Text(l10n.resistanceMagic),
                      value: _resistanceMagic,
                      onChanged: (_lockedBool((p) => p.resistanceMagic) || _immunityMagic)
                          ? null
                          : (v) => setState(
                              () => _resistanceMagic = v ?? false),
                    ),
                    CheckboxListTile(
                      title: Text(l10n.resistanceTraitDamage),
                      value: _resistanceTraitDamage,
                      onChanged: (_lockedBool((p) => p.resistanceTraitDamage) || _resistanceMagic ||
                              _immunityMagic ||
                              _immunityTraitDamage)
                          ? null
                          : (v) => setState(
                              () => _resistanceTraitDamage = v ?? false),
                    ),
                    ...demonNames.map((name) => CheckboxListTile(
                          title: Text('${l10n.resistance} $name'),
                          value: _resistancesDemonic[name],
                          onChanged: (_lockedBool((p) => p.resistancesDemonic[name] == true) || _immunitiesDemonic[name] == true)
                              ? null
                              : (v) => setState(
                                  () => _resistancesDemonic[name] = v ?? false),
                        )),
                    ...DsaElement.values.map((e) => CheckboxListTile(
                          title: Text('${l10n.resistance} ${e.localized(l10n)}'),
                          value: _resistancesElemental[e],
                          onChanged: (_lockedBool((p) => p.resistancesElemental[e] == true) || _isOwnElement(e) ||
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
                      onChanged: _lockedBool((p) => p.immunityMagic) ? null : _onImmunityMagicChanged,
                    ),
                    CheckboxListTile(
                      title: Text(l10n.immunityTraitDamage),
                      value: _immunityTraitDamage,
                      onChanged: (_lockedBool((p) => p.immunityTraitDamage) || _immunityMagic)
                          ? null
                          : (v) => setState(
                              () => _immunityTraitDamage = v ?? false),
                    ),
                    ...demonNames.map((name) => CheckboxListTile(
                          title: Text('${l10n.immunity} $name'),
                          value: _immunitiesDemonic[name],
                          onChanged: _lockedBool((p) => p.immunitiesDemonic[name] == true) ? null : (v) => setState(
                              () => _immunitiesDemonic[name] = v ?? false),
                        )),
                    ...DsaElement.values.map((e) => CheckboxListTile(
                          title: Text('${l10n.immunity} ${e.localized(l10n)}'),
                          value: _immunitiesElemental[e],
                          onChanged: (_lockedBool((p) => p.immunitiesElemental[e] == true) || _isOwnElement(e) ||
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

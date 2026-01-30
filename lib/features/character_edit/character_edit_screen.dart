import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';

import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/models/character_class.dart';
import 'package:dsa_elements_summons_flutter/core/models/element.dart';
import 'package:dsa_elements_summons_flutter/features/home/providers.dart';

class CharacterEditScreen extends ConsumerStatefulWidget {
  final int? characterId;

  const CharacterEditScreen({super.key, this.characterId});

  @override
  ConsumerState<CharacterEditScreen> createState() =>
      _CharacterEditScreenState();
}

class _CharacterEditScreenState extends ConsumerState<CharacterEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  CharacterClass _characterClass = CharacterClass.mage;
  late TextEditingController _courageCtrl;
  late TextEditingController _wisdomCtrl;
  late TextEditingController _charismaCtrl;
  late TextEditingController _intuitionCtrl;
  late TextEditingController _talentServantCtrl;
  late TextEditingController _talentDjinnCtrl;
  late TextEditingController _talentMasterCtrl;
  late TextEditingController _talentedDemonicCtrl;
  late TextEditingController _knowledgeDemonicCtrl;

  final Map<DsaElement, bool> _talented = {
    for (final e in DsaElement.values) e: false,
  };
  final Map<DsaElement, bool> _knowledge = {
    for (final e in DsaElement.values) e: false,
  };

  bool _affinityToElementals = false;
  bool _demonicCovenant = false;
  bool _cloakedAura = false;
  bool _powerlineMagicI = false;
  int _weakPresence = 0;
  int _strengthOfStigma = 0;

  bool _isLoading = false;
  bool get _isEditing => widget.characterId != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _courageCtrl = TextEditingController(text: '0');
    _wisdomCtrl = TextEditingController(text: '0');
    _charismaCtrl = TextEditingController(text: '0');
    _intuitionCtrl = TextEditingController(text: '0');
    _talentServantCtrl = TextEditingController(text: '0');
    _talentDjinnCtrl = TextEditingController(text: '0');
    _talentMasterCtrl = TextEditingController(text: '0');
    _talentedDemonicCtrl = TextEditingController(text: '0');
    _knowledgeDemonicCtrl = TextEditingController(text: '0');

    if (_isEditing) {
      _loadCharacter();
    }
  }

  Future<void> _loadCharacter() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final c = await db.getCharacterById(widget.characterId!);
    setState(() {
      _nameCtrl.text = c.characterName;
      _characterClass = CharacterClass.values[c.characterClass];
      _courageCtrl.text = c.statCourage.toString();
      _wisdomCtrl.text = c.statWisdom.toString();
      _charismaCtrl.text = c.statCharisma.toString();
      _intuitionCtrl.text = c.statIntuition.toString();
      _talentServantCtrl.text = c.talentCallElementalServant.toString();
      _talentDjinnCtrl.text = c.talentCallDjinn.toString();
      _talentMasterCtrl.text = c.talentCallMasterOfElement.toString();
      _talented[DsaElement.fire] = c.talentedFire;
      _talented[DsaElement.water] = c.talentedWater;
      _talented[DsaElement.life] = c.talentedLife;
      _talented[DsaElement.ice] = c.talentedIce;
      _talented[DsaElement.stone] = c.talentedStone;
      _talented[DsaElement.air] = c.talentedAir;
      _talentedDemonicCtrl.text = c.talentedDemonic.toString();
      _knowledge[DsaElement.fire] = c.knowledgeFire;
      _knowledge[DsaElement.water] = c.knowledgeWater;
      _knowledge[DsaElement.life] = c.knowledgeLife;
      _knowledge[DsaElement.ice] = c.knowledgeIce;
      _knowledge[DsaElement.stone] = c.knowledgeStone;
      _knowledge[DsaElement.air] = c.knowledgeAir;
      _knowledgeDemonicCtrl.text = c.knowledgeDemonic.toString();
      _affinityToElementals = c.affinityToElementals;
      _demonicCovenant = c.demonicCovenant;
      _cloakedAura = c.cloakedAura;
      _powerlineMagicI = c.powerlineMagicI;
      _weakPresence = c.weakPresence;
      _strengthOfStigma = c.strengthOfStigma;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courageCtrl.dispose();
    _wisdomCtrl.dispose();
    _charismaCtrl.dispose();
    _intuitionCtrl.dispose();
    _talentServantCtrl.dispose();
    _talentDjinnCtrl.dispose();
    _talentMasterCtrl.dispose();
    _talentedDemonicCtrl.dispose();
    _knowledgeDemonicCtrl.dispose();
    super.dispose();
  }

  int _intFromCtrl(TextEditingController ctrl) =>
      int.tryParse(ctrl.text) ?? 0;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);

    if (_isEditing) {
      await db.updateCharacter(Character(
        id: widget.characterId!,
        characterName: _nameCtrl.text,
        characterClass: _characterClass.index,
        statCourage: _intFromCtrl(_courageCtrl),
        statWisdom: _intFromCtrl(_wisdomCtrl),
        statCharisma: _intFromCtrl(_charismaCtrl),
        statIntuition: _intFromCtrl(_intuitionCtrl),
        talentCallElementalServant: _intFromCtrl(_talentServantCtrl),
        talentCallDjinn: _intFromCtrl(_talentDjinnCtrl),
        talentCallMasterOfElement: _intFromCtrl(_talentMasterCtrl),
        talentedFire: _talented[DsaElement.fire]!,
        talentedWater: _talented[DsaElement.water]!,
        talentedLife: _talented[DsaElement.life]!,
        talentedIce: _talented[DsaElement.ice]!,
        talentedStone: _talented[DsaElement.stone]!,
        talentedAir: _talented[DsaElement.air]!,
        talentedDemonic: _intFromCtrl(_talentedDemonicCtrl),
        knowledgeFire: _knowledge[DsaElement.fire]!,
        knowledgeWater: _knowledge[DsaElement.water]!,
        knowledgeLife: _knowledge[DsaElement.life]!,
        knowledgeIce: _knowledge[DsaElement.ice]!,
        knowledgeStone: _knowledge[DsaElement.stone]!,
        knowledgeAir: _knowledge[DsaElement.air]!,
        knowledgeDemonic: _intFromCtrl(_knowledgeDemonicCtrl),
        affinityToElementals: _affinityToElementals,
        demonicCovenant: _demonicCovenant,
        cloakedAura: _cloakedAura,
        weakPresence: _weakPresence,
        strengthOfStigma: _strengthOfStigma,
        powerlineMagicI: _powerlineMagicI,
      ));
    } else {
      await db.insertCharacter(CharactersCompanion(
        characterName: drift.Value(_nameCtrl.text),
        characterClass: drift.Value(_characterClass.index),
        statCourage: drift.Value(_intFromCtrl(_courageCtrl)),
        statWisdom: drift.Value(_intFromCtrl(_wisdomCtrl)),
        statCharisma: drift.Value(_intFromCtrl(_charismaCtrl)),
        statIntuition: drift.Value(_intFromCtrl(_intuitionCtrl)),
        talentCallElementalServant:
            drift.Value(_intFromCtrl(_talentServantCtrl)),
        talentCallDjinn: drift.Value(_intFromCtrl(_talentDjinnCtrl)),
        talentCallMasterOfElement:
            drift.Value(_intFromCtrl(_talentMasterCtrl)),
        talentedFire: drift.Value(_talented[DsaElement.fire]!),
        talentedWater: drift.Value(_talented[DsaElement.water]!),
        talentedLife: drift.Value(_talented[DsaElement.life]!),
        talentedIce: drift.Value(_talented[DsaElement.ice]!),
        talentedStone: drift.Value(_talented[DsaElement.stone]!),
        talentedAir: drift.Value(_talented[DsaElement.air]!),
        talentedDemonic: drift.Value(_intFromCtrl(_talentedDemonicCtrl)),
        knowledgeFire: drift.Value(_knowledge[DsaElement.fire]!),
        knowledgeWater: drift.Value(_knowledge[DsaElement.water]!),
        knowledgeLife: drift.Value(_knowledge[DsaElement.life]!),
        knowledgeIce: drift.Value(_knowledge[DsaElement.ice]!),
        knowledgeStone: drift.Value(_knowledge[DsaElement.stone]!),
        knowledgeAir: drift.Value(_knowledge[DsaElement.air]!),
        knowledgeDemonic: drift.Value(_intFromCtrl(_knowledgeDemonicCtrl)),
        affinityToElementals: drift.Value(_affinityToElementals),
        demonicCovenant: drift.Value(_demonicCovenant),
        cloakedAura: drift.Value(_cloakedAura),
        weakPresence: drift.Value(_weakPresence),
        strengthOfStigma: drift.Value(_strengthOfStigma),
        powerlineMagicI: drift.Value(_powerlineMagicI),
      ));
    }

    if (mounted) context.go('/');
  }

  Future<void> _delete() async {
    final db = ref.read(databaseProvider);
    await db.deleteCharacter(widget.characterId!);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEditing ? l10n.editCharacter : l10n.newCharacter)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
        title: Text(_isEditing ? l10n.editCharacter : l10n.newCharacter),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.characterName),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l10n.nameRequired : null,
              ),
              const SizedBox(height: 16),

              // Class
              DropdownButtonFormField<CharacterClass>(
                initialValue: _characterClass,
                decoration: InputDecoration(labelText: l10n.characterClass),
                items: CharacterClass.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _characterClass = v!),
              ),
              const SizedBox(height: 16),

              // Stats
              _sectionHeader(l10n.stats),
              _numberField(_courageCtrl, l10n.statCourage),
              _numberField(_wisdomCtrl, l10n.statWisdom),
              _numberField(_charismaCtrl, l10n.statCharisma),
              _numberField(_intuitionCtrl, l10n.statIntuition),
              const SizedBox(height: 16),

              // Talents
              _sectionHeader(l10n.talents),
              _numberField(_talentServantCtrl, l10n.talentCallElementalServant),
              _numberField(_talentDjinnCtrl, l10n.talentCallDjinn),
              _numberField(_talentMasterCtrl, l10n.talentCallMasterOfElement),
              const SizedBox(height: 16),

              // Talented for elements
              _sectionHeader(l10n.talentedFor),
              ...DsaElement.values.map((e) => CheckboxListTile(
                    title: Text(e.name),
                    value: _talented[e],
                    onChanged: (v) =>
                        setState(() => _talented[e] = v ?? false),
                  )),
              _numberField(_talentedDemonicCtrl, l10n.talentedDemonic),
              const SizedBox(height: 16),

              // Knowledge of attribute
              _sectionHeader(l10n.knowledgeOfAttribute),
              ...DsaElement.values.map((e) => CheckboxListTile(
                    title: Text(e.name),
                    value: _knowledge[e],
                    onChanged: (v) =>
                        setState(() => _knowledge[e] = v ?? false),
                  )),
              _numberField(_knowledgeDemonicCtrl, l10n.knowledgeDemonic),
              const SizedBox(height: 16),

              // Special characteristics
              _sectionHeader(l10n.specialCharacteristics),
              CheckboxListTile(
                title: Text(l10n.affinityToElementals),
                value: _affinityToElementals,
                onChanged: (v) =>
                    setState(() => _affinityToElementals = v ?? false),
              ),
              CheckboxListTile(
                title: Text(l10n.demonicCovenant),
                value: _demonicCovenant,
                onChanged: (v) =>
                    setState(() => _demonicCovenant = v ?? false),
              ),
              CheckboxListTile(
                title: Text(l10n.cloakedAura),
                value: _cloakedAura,
                onChanged: (v) =>
                    setState(() => _cloakedAura = v ?? false),
              ),
              CheckboxListTile(
                title: Text(l10n.powerlineMagicI),
                value: _powerlineMagicI,
                onChanged: (v) =>
                    setState(() => _powerlineMagicI = v ?? false),
              ),
              DropdownButtonFormField<int>(
                initialValue: _weakPresence,
                decoration: InputDecoration(labelText: l10n.weakPresence),
                items: List.generate(
                    6,
                    (i) => DropdownMenuItem(
                          value: i,
                          child: Text('$i'),
                        )),
                onChanged: (v) => setState(() => _weakPresence = v ?? 0),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _strengthOfStigma,
                decoration:
                    InputDecoration(labelText: l10n.strengthOfStigma),
                items: List.generate(
                    4,
                    (i) => DropdownMenuItem(
                          value: i,
                          child: Text('$i'),
                        )),
                onChanged: (v) =>
                    setState(() => _strengthOfStigma = v ?? 0),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _numberField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
      ),
    );
  }
}

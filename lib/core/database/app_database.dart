import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Characters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get characterName => text()();
  IntColumn get characterClass => integer().withDefault(const Constant(0))();
  IntColumn get statCourage => integer().withDefault(const Constant(0))();
  IntColumn get statWisdom => integer().withDefault(const Constant(0))();
  IntColumn get statCharisma => integer().withDefault(const Constant(0))();
  IntColumn get statIntuition => integer().withDefault(const Constant(0))();
  IntColumn get talentCallElementalServant => integer().withDefault(const Constant(0))();
  IntColumn get talentCallDjinn => integer().withDefault(const Constant(0))();
  IntColumn get talentCallMasterOfElement => integer().withDefault(const Constant(0))();
  BoolColumn get talentedFire => boolean().withDefault(const Constant(false))();
  BoolColumn get talentedWater => boolean().withDefault(const Constant(false))();
  BoolColumn get talentedLife => boolean().withDefault(const Constant(false))();
  BoolColumn get talentedIce => boolean().withDefault(const Constant(false))();
  BoolColumn get talentedStone => boolean().withDefault(const Constant(false))();
  BoolColumn get talentedAir => boolean().withDefault(const Constant(false))();
  IntColumn get talentedDemonic => integer().withDefault(const Constant(0))();
  BoolColumn get knowledgeFire => boolean().withDefault(const Constant(false))();
  BoolColumn get knowledgeWater => boolean().withDefault(const Constant(false))();
  BoolColumn get knowledgeLife => boolean().withDefault(const Constant(false))();
  BoolColumn get knowledgeIce => boolean().withDefault(const Constant(false))();
  BoolColumn get knowledgeStone => boolean().withDefault(const Constant(false))();
  BoolColumn get knowledgeAir => boolean().withDefault(const Constant(false))();
  IntColumn get knowledgeDemonic => integer().withDefault(const Constant(0))();
  BoolColumn get affinityToElementals => boolean().withDefault(const Constant(false))();
  BoolColumn get demonicCovenant => boolean().withDefault(const Constant(false))();
  BoolColumn get cloakedAura => boolean().withDefault(const Constant(false))();
  IntColumn get weakPresence => integer().withDefault(const Constant(0))();
  IntColumn get strengthOfStigma => integer().withDefault(const Constant(0))();
  BoolColumn get powerlineMagicI => boolean().withDefault(const Constant(false))();
}

class ElementalTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer()();
  TextColumn get templateName => text()();
  IntColumn get element => integer().withDefault(const Constant(0))();
  IntColumn get summoningType => integer().withDefault(const Constant(0))();

  // Existing abilities
  BoolColumn get astralSense => boolean().withDefault(const Constant(false))();
  BoolColumn get longArm => boolean().withDefault(const Constant(false))();
  BoolColumn get lifeSense => boolean().withDefault(const Constant(false))();
  IntColumn get regenerationLevel => integer().withDefault(const Constant(0))();
  IntColumn get additionalActionsLevel => integer().withDefault(const Constant(0))();
  BoolColumn get resistanceMagic => boolean().withDefault(const Constant(false))();
  BoolColumn get resistanceTraitDamage => boolean().withDefault(const Constant(false))();
  BoolColumn get immunityMagic => boolean().withDefault(const Constant(false))();
  BoolColumn get immunityTraitDamage => boolean().withDefault(const Constant(false))();
  TextColumn get resistancesDemonicJson => text().withDefault(const Constant('{}'))();
  TextColumn get resistancesElementalJson => text().withDefault(const Constant('{}'))();
  TextColumn get immunitiesDemonicJson => text().withDefault(const Constant('{}'))();
  TextColumn get immunitiesElementalJson => text().withDefault(const Constant('{}'))();

  // New general properties (S. 140)
  BoolColumn get causeFear => boolean().withDefault(const Constant(false))();           // Ängste auslösen - 5 ZfP*
  IntColumn get artifactAnimationLevel => integer().withDefault(const Constant(0))();   // Artefaktbeseelung Stufe 0-3 - 3 ZfP* pro Stufe
  BoolColumn get aura => boolean().withDefault(const Constant(false))();               // Aura - 5 ZfP*
  BoolColumn get blinkingInvisibility => boolean().withDefault(const Constant(false))(); // Blinkende Unsichtbarkeit - 6 ZfP*
  BoolColumn get elementalShackle => boolean().withDefault(const Constant(false))();   // Elementare Fessel - 5 ZfP*
  IntColumn get elementalGripLevel => integer().withDefault(const Constant(0))();      // Elementarer Griff Stufe 0-3 - 7 ZfP* pro Stufe
  BoolColumn get elementalInferno => boolean().withDefault(const Constant(false))();   // Elementares Inferno - 8 ZfP*
  BoolColumn get elementalGrowth => boolean().withDefault(const Constant(false))();    // Elementares Wachstum - 7 ZfP*
  BoolColumn get drowning => boolean().withDefault(const Constant(false))();           // Ersäufen - 4 ZfP* (nur Wasser)
  BoolColumn get areaAttack => boolean().withDefault(const Constant(false))();         // Flächenangriff - 7 ZfP*
  BoolColumn get flight => boolean().withDefault(const Constant(false))();             // Flugfähigkeit - 5 ZfP* (nicht Erz)
  BoolColumn get frost => boolean().withDefault(const Constant(false))();              // Frost - 3 ZfP* (nur Eis)
  BoolColumn get ember => boolean().withDefault(const Constant(false))();              // Glut - 3 ZfP* (Feuer, Erz)
  BoolColumn get criticalImmunity => boolean().withDefault(const Constant(false))();   // Immunität gg. Krit. Treffer - 2 ZfP*
  BoolColumn get boilingBlood => boolean().withDefault(const Constant(false))();       // Kochendes Blut - 5 ZfP* (Feuer, Wasser)
  BoolColumn get fog => boolean().withDefault(const Constant(false))();                // Nebel - 2 ZfP* (Wasser, Luft)
  BoolColumn get smoke => boolean().withDefault(const Constant(false))();              // Rauch - 4 ZfP* (Feuer, Luft)
  BoolColumn get stasis => boolean().withDefault(const Constant(false))();             // Starre - 5 ZfP* (Erz, Eis, Humus)
  IntColumn get stoneEatingLevel => integer().withDefault(const Constant(0))();        // Steinfraß Stufe - 2 ZfP* pro Stufe (Erz, Eis)
  IntColumn get stoneSkinLevel => integer().withDefault(const Constant(0))();          // Steinhaut Stufe 0-6 - 2 ZfP* pro Stufe (Erz, Humus)
  BoolColumn get mergeWithElement => boolean().withDefault(const Constant(false))();   // Verschmelzen - 7 ZfP*
  BoolColumn get sinking => boolean().withDefault(const Constant(false))();            // Versinken - 6 ZfP* (Humus, Wasser)
  BoolColumn get wildGrowth => boolean().withDefault(const Constant(false))();         // Wildwuchs - 7 ZfP* (nur Humus)
  BoolColumn get burst => boolean().withDefault(const Constant(false))();              // Zerbersten - 4 ZfP*
  BoolColumn get shatteringArmor => boolean().withDefault(const Constant(false))();    // Zerschellender Panzer - 3 ZfP* (Erz, Humus, Feuer, Eis)

  // Value modifications (S. 141)
  IntColumn get modLeP => integer().withDefault(const Constant(0))();                  // LeP +5 pro Anwendung - 2 ZfP*
  IntColumn get modINI => integer().withDefault(const Constant(0))();                  // INI +1 - 3 ZfP*
  IntColumn get modRS => integer().withDefault(const Constant(0))();                   // RS +1 - 3 ZfP*
  IntColumn get modGS => integer().withDefault(const Constant(0))();                   // GS +1 - 3 ZfP*
  IntColumn get modMR => integer().withDefault(const Constant(0))();                   // MR +1 - 3 ZfP*
  IntColumn get modAT => integer().withDefault(const Constant(0))();                   // AT +1 - 4 ZfP*
  IntColumn get modPA => integer().withDefault(const Constant(0))();                   // PA +1 - 4 ZfP*
  IntColumn get modTP => integer().withDefault(const Constant(0))();                   // TP +1 - 4 ZfP*
  IntColumn get modAttribute => integer().withDefault(const Constant(0))();            // Eigenschaft +1 - 5 ZfP*
  IntColumn get modNewTalent => integer().withDefault(const Constant(0))();            // Neues Talent - 4 ZfP*
  IntColumn get modTaWZfW => integer().withDefault(const Constant(0))();               // TaW/ZfW +2 - 1 ZfP*
}

class HiddenPredefinedSummonings extends Table {
  IntColumn get characterId => integer()();
  TextColumn get predefinedId => text()();

  @override
  Set<Column> get primaryKey => {characterId, predefinedId};
}

@DriftDatabase(tables: [Characters, ElementalTemplates, HiddenPredefinedSummonings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(elementalTemplates);
          }
          if (from < 3) {
            // Add new property columns to elemental_templates using raw SQL
            final newBoolColumns = [
              'cause_fear', 'artifact_animation', 'aura', 'blinking_invisibility',
              'elemental_shackle', 'elemental_inferno', 'elemental_growth',
              'drowning', 'area_attack', 'flight', 'frost', 'ember',
              'critical_immunity', 'boiling_blood', 'fog', 'smoke', 'stasis',
              'merge_with_element', 'sinking', 'wild_growth', 'burst', 'shattering_armor',
            ];
            final newIntColumns = [
              'elemental_grip_level', 'stone_eating_level', 'stone_skin_level',
              'mod_le_p', 'mod_i_n_i', 'mod_r_s', 'mod_g_s', 'mod_m_r',
              'mod_a_t', 'mod_p_a', 'mod_t_p', 'mod_attribute', 'mod_new_talent', 'mod_ta_w_zf_w',
            ];
            for (final col in newBoolColumns) {
              await customStatement('ALTER TABLE elemental_templates ADD COLUMN $col INTEGER NOT NULL DEFAULT 0');
            }
            for (final col in newIntColumns) {
              await customStatement('ALTER TABLE elemental_templates ADD COLUMN $col INTEGER NOT NULL DEFAULT 0');
            }
          }
          if (from < 4) {
            // Convert artifact_animation bool to artifact_animation_level int
            await customStatement('ALTER TABLE elemental_templates ADD COLUMN artifact_animation_level INTEGER NOT NULL DEFAULT 0');
            await customStatement('UPDATE elemental_templates SET artifact_animation_level = artifact_animation');
          }
          if (from < 5) {
            await m.createTable(hiddenPredefinedSummonings);
          }
        },
      );

  // Character CRUD
  Future<List<Character>> getAllCharacters() => select(characters).get();
  Stream<List<Character>> watchAllCharacters() => select(characters).watch();
  Future<Character> getCharacterById(int id) =>
      (select(characters)..where((c) => c.id.equals(id))).getSingle();
  Future<int> insertCharacter(CharactersCompanion entry) =>
      into(characters).insert(entry);
  Future<bool> updateCharacter(Character entry) =>
      update(characters).replace(entry);
  Future<int> deleteCharacter(int id) =>
      (delete(characters)..where((c) => c.id.equals(id))).go();

  // ElementalTemplate CRUD
  Stream<List<ElementalTemplate>> watchTemplatesForCharacter(int charId) =>
      (select(elementalTemplates)..where((t) => t.characterId.equals(charId)))
          .watch();
  Future<List<ElementalTemplate>> getTemplatesForCharacter(int charId) =>
      (select(elementalTemplates)..where((t) => t.characterId.equals(charId)))
          .get();
  Future<ElementalTemplate> getTemplateById(int id) =>
      (select(elementalTemplates)..where((t) => t.id.equals(id))).getSingle();
  Future<int> insertTemplate(ElementalTemplatesCompanion entry) =>
      into(elementalTemplates).insert(entry);
  Future<bool> updateTemplate(ElementalTemplate entry) =>
      update(elementalTemplates).replace(entry);
  Future<int> deleteTemplate(int id) =>
      (delete(elementalTemplates)..where((t) => t.id.equals(id))).go();

  // HiddenPredefinedSummonings CRUD
  Future<void> hidePredefined(int characterId, String predefinedId) =>
      into(hiddenPredefinedSummonings).insertOnConflictUpdate(
        HiddenPredefinedSummoningsCompanion.insert(
          characterId: characterId,
          predefinedId: predefinedId,
        ),
      );
  Future<int> unhidePredefined(int characterId, String predefinedId) =>
      (delete(hiddenPredefinedSummonings)
            ..where((h) =>
                h.characterId.equals(characterId) &
                h.predefinedId.equals(predefinedId)))
          .go();
  Stream<List<String>> watchHiddenPredefinedIds(int characterId) =>
      (select(hiddenPredefinedSummonings)
            ..where((h) => h.characterId.equals(characterId)))
          .watch()
          .map((rows) => rows.map((r) => r.predefinedId).toList());
  Future<List<String>> getHiddenPredefinedIds(int characterId) async {
    final rows = await (select(hiddenPredefinedSummonings)
          ..where((h) => h.characterId.equals(characterId)))
        .get();
    return rows.map((r) => r.predefinedId).toList();
  }
  Future<int> deleteHiddenForCharacter(int characterId) =>
      (delete(hiddenPredefinedSummonings)
            ..where((h) => h.characterId.equals(characterId)))
          .go();
}

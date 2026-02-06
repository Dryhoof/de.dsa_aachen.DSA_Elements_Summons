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
}

@DriftDatabase(tables: [Characters, ElementalTemplates])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(elementalTemplates);
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
}

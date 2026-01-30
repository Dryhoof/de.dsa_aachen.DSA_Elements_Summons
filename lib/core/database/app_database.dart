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

@DriftDatabase(tables: [Characters])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  // CRUD operations
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
}

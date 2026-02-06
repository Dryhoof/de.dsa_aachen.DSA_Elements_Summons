import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dsa_elements_summons_flutter/core/database/app_database.dart';
import 'package:dsa_elements_summons_flutter/core/database/connection.dart'
    if (dart.library.html) 'package:dsa_elements_summons_flutter/core/database/connection_web.dart'
    if (dart.library.js_interop) 'package:dsa_elements_summons_flutter/core/database/connection_web.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return constructDb();
});

final characterListProvider = StreamProvider<List<Character>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllCharacters();
});

final elementalTemplatesProvider =
    StreamProvider.family<List<ElementalTemplate>, int>((ref, characterId) {
  final db = ref.watch(databaseProvider);
  return db.watchTemplatesForCharacter(characterId);
});

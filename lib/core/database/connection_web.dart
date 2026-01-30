import 'package:drift/drift.dart';
import 'package:drift/web.dart';

import 'app_database.dart';

AppDatabase constructDb() {
  final db = LazyDatabase(() async {
    return WebDatabase('dsa_summons');
  });
  return AppDatabase(db);
}

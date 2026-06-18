import 'package:isar/isar.dart';
import '../models/goat.dart';
import '../models/health_record.dart';

class FarmRepository {
  final Isar isar;

  FarmRepository(this.isar);

  // Watch livestock records live
  Stream<List<Goat>> watchGoats() {
    return isar.goats.where().watch(fireImmediately: true);
  }

  // Create or update an animal profile
  Future<void> addOrUpdateGoat(Goat goat) async {
    await isar.writeTxn(() async {
      await isar.goats.put(goat);
    });
  }

  // Delete an animal profile from the ledger
  Future<bool> deleteGoat(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.goats.delete(id);
    });
  }

  // NEW: look up a goat by tag ID so we can check for duplicates before saving
  Future<Goat?> findGoatByTag(String tagId) async {
    return await isar.goats.where().tagIdEqualTo(tagId).findFirst();
  }

  // =========================================================================
  // 🩺 SLIDING IN NEW HEALTH FEATURES RIGHT HERE:
  // =========================================================================

  // A channel to READ health logs for a specific goat from the database
  Stream<List<HealthRecord>> watchHealthRecords(int goatId) {
    return isar.healthRecords
        .filter()
        .goatIdEqualTo(goatId)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  // A channel to SAVE a new health log into the database
  Future<void> addHealthRecord(HealthRecord record) async {
    await isar.writeTxn(() async {
      await isar.healthRecords.put(record);
    });
  }

  // A channel to DELETE a health log if you made a mistake
  Future<bool> deleteHealthRecord(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.healthRecords.delete(id);
    });
  }

} // <-- THIS BRACKET IS NOW AT THE VERY BOTTOM SO IT KEEPS EVERYTHING CONNECTED!
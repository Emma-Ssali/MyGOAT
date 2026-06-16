import 'package:isar/isar.dart';
import '../models/goat.dart';

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
}
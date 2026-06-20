import 'package:isar/isar.dart';
import '../models/goat.dart';
import '../models/health_record.dart';
import '../models/transaction.dart';

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

  // Look up a goat by tag ID so we can check for duplicates before saving
  Future<Goat?> findGoatByTag(String tagId) async {
    return await isar.goats.where().tagIdEqualTo(tagId).findFirst();
  }

  // =========================================================================
  // 🩺 HEALTH FEATURES
  // =========================================================================

  // A channel to READ health logs for a specific goat from the database
  Stream<List<HealthRecord>> watchHealthRecords(int goatId) {
    return isar.healthRecords
        .filter()
        .goatIdEqualTo(goatId)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  // A channel to SAVE a new health log, and (if it has a cost) log a
  // matching expense in the financial ledger in the same transaction.
  Future<void> addHealthRecord(HealthRecord record, {bool logExpense = true}) async {
    await isar.writeTxn(() async {
      await isar.healthRecords.put(record);

      if (logExpense && record.cost > 0) {
        String? tagId;
        if (record.goatId != null) {
          final goat = await isar.goats.get(record.goatId!);
          tagId = goat?.tagId;
        }

        final transaction = FinancialTransaction()
          ..amount = record.cost
          ..category = 'Veterinary & Medicine'
          ..description = '${record.recordType}: ${record.title}'
          ..isIncome = false
          ..date = record.date
          ..lastSyncedAt = DateTime.now()
          ..linkedGoatTagId = tagId;

        await isar.financialTransactions.put(transaction);
      }
    });
  }

  // A channel to DELETE a health log if you made a mistake
  Future<bool> deleteHealthRecord(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.healthRecords.delete(id);
    });
  }
}
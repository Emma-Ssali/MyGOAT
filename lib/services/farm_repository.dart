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

  // Handles both creating a new record (id == null) and updating an
  // existing one (id set). Keeps the linked FinancialTransaction in sync:
  // creates it if needed, updates it if it already exists, or removes it
  // if the cost was zeroed out on an edit.
  Future<void> saveHealthRecord(HealthRecord record, {bool logExpense = true}) async {
    await isar.writeTxn(() async {
      String? tagId;
      if (record.goatId != null) {
        final goat = await isar.goats.get(record.goatId!);
        tagId = goat?.tagId;
      }

      final shouldHaveExpense = logExpense && record.cost > 0;

      if (shouldHaveExpense) {
        FinancialTransaction transaction;
        if (record.linkedTransactionId != null) {
          final existing = await isar.financialTransactions.get(record.linkedTransactionId!);
          transaction = existing ?? FinancialTransaction();
        } else {
          transaction = FinancialTransaction();
        }

        transaction
          ..amount = record.cost
          ..category = 'Veterinary & Medicine'
          ..description = '${record.recordType}: ${record.title}'
          ..isIncome = false
          ..date = record.date
          ..lastSyncedAt = DateTime.now()
          ..linkedGoatTagId = tagId;

        final transactionId = await isar.financialTransactions.put(transaction);
        record.linkedTransactionId = transactionId;
      } else if (record.linkedTransactionId != null) {
        await isar.financialTransactions.delete(record.linkedTransactionId!);
        record.linkedTransactionId = null;
      }

      await isar.healthRecords.put(record);
    });
  }

  // A channel to DELETE a health log, and its linked expense entry if present
  Future<bool> deleteHealthRecord(Id id) async {
    return await isar.writeTxn(() async {
      final record = await isar.healthRecords.get(id);
      if (record?.linkedTransactionId != null) {
        await isar.financialTransactions.delete(record!.linkedTransactionId!);
      }
      return await isar.healthRecords.delete(id);
    });
  }
}
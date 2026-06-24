import 'package:isar/isar.dart';
import '../models/goat.dart';
import '../models/health_record.dart';
import '../models/transaction.dart';
import '../models/weight_record.dart';
import '../models/breeding_record.dart';

class FarmRepository {
  final Isar isar;

  FarmRepository(this.isar);

  // =========================================================================
  // 🐐 GOAT FEATURES
  // =========================================================================

  Stream<List<Goat>> watchGoats() {
    return isar.goats.where().watch(fireImmediately: true);
  }

  Future<void> addOrUpdateGoat(Goat goat) async {
    await isar.writeTxn(() async {
      await isar.goats.put(goat);
    });
  }

  Future<bool> deleteGoat(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.goats.delete(id);
    });
  }

  Future<Goat?> findGoatByTag(String tagId) async {
    return await isar.goats.where().tagIdEqualTo(tagId).findFirst();
  }

  // =========================================================================
  // 💸 TRANSACTION FEATURES
  // =========================================================================

  Stream<List<FinancialTransaction>> watchTransactions() {
    return isar.financialTransactions
        .where()
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<void> saveTransaction(FinancialTransaction txn) async {
    await isar.writeTxn(() async {
      await isar.financialTransactions.put(txn);
    });
  }

  Future<bool> deleteTransaction(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.financialTransactions.delete(id);
    });
  }

  // =========================================================================
  // 🩺 HEALTH FEATURES
  // =========================================================================

  Stream<List<HealthRecord>> watchHealthRecords(int goatId) {
    return isar.healthRecords
        .filter()
        .goatIdEqualTo(goatId)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

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

  Future<bool> deleteHealthRecord(Id id) async {
    return await isar.writeTxn(() async {
      final record = await isar.healthRecords.get(id);
      if (record?.linkedTransactionId != null) {
        await isar.financialTransactions.delete(record!.linkedTransactionId!);
      }
      return await isar.healthRecords.delete(id);
    });
  }

  // =========================================================================
  // ⚖️ WEIGHT FEATURES
  // =========================================================================

  Stream<List<WeightRecord>> watchWeightRecords(int goatId) {
    return isar.weightRecords
        .filter()
        .goatIdEqualTo(goatId)
        .sortByDateDesc()
        .watch(fireImmediately: true);
  }

  Future<void> saveWeightRecord(WeightRecord record) async {
    await isar.writeTxn(() async {
      await isar.weightRecords.put(record);
    });
  }

  Future<bool> deleteWeightRecord(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.weightRecords.delete(id);
    });
  }

  // =========================================================================
  // 🐣 BREEDING FEATURES
  // =========================================================================

  Stream<List<BreedingRecord>> watchBreedingRecords(int goatId) {
    return isar.breedingRecords
        .filter()
        .goatIdEqualTo(goatId)
        .sortByMatingDateDesc()
        .watch(fireImmediately: true);
  }

  Future<void> saveBreedingRecord(BreedingRecord record) async {
    await isar.writeTxn(() async {
      await isar.breedingRecords.put(record);
    });
  }

  Future<bool> deleteBreedingRecord(Id id) async {
    return await isar.writeTxn(() async {
      return await isar.breedingRecords.delete(id);
    });
  }
}
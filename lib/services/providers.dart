import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mygoat/models/goat.dart';
import 'package:mygoat/models/transaction.dart';

class DatabaseService {
  final Isar isar;
  DatabaseService(this.isar);

  Future<void> addOrUpdateGoat(Goat goat) async {
    await isar.writeTxn(() async {
      await isar.goats.put(goat);
    });
  }

  Future<void> deleteGoat(int id) async {
    await isar.writeTxn(() async {
      await isar.goats.delete(id);
    });
  }

  Stream<List<Goat>> watchAllGoats() {
    // FIX: Removed invalid 'lazy: false' argument
    return isar.goats.where().sortByCreatedAtDesc().watch();
  }

  Future<void> saveTransaction(FinancialTransaction transaction) async {
    await isar.writeTxn(() async {
      await isar.financialTransactions.put(transaction);
    });
  }

  Future<void> deleteTransaction(int id) async {
    await isar.writeTxn(() async {
      await isar.financialTransactions.delete(id);
    });
  }

  Stream<List<FinancialTransaction>> watchAllTransactions() {
    // FIX: Removed invalid 'lazy: false' argument
    return isar.financialTransactions.where().sortByDateDesc().watch();
  }
}

class FarmRepository {
  final DatabaseService _db;
  FarmRepository(this._db);

  Future<void> addOrUpdateGoat(Goat goat) async {
    await _db.addOrUpdateGoat(goat);
  }
}

final isarInstanceProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Initialize Isar in main() before accessing this provider');
});

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  return DatabaseService(isar);
});

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return FarmRepository(db);
});

final watchGoatsProvider = StreamProvider<List<Goat>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.watchAllGoats();
});

final watchTransactionsProvider = StreamProvider<List<FinancialTransaction>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.watchAllTransactions();
});
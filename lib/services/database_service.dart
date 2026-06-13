import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/goat.dart';
import '../models/transaction.dart';

class DatabaseService {
  Isar? _db;

  /// Open or initialize the offline Isar database safely
  Future<Isar> get db async {
    // Return existing active instance if already initialized
    if (_db != null) return _db!;

    // Find the safe local storage location on your Samsung Android device
    final dir = await getApplicationDocumentsDirectory();

    // Open the local database schemas for both tracking models
    _db = await Isar.open(
      [GoatSchema, FinancialTransactionSchema],
      directory: dir.path,
    );

    return _db!;
  }

  // ==========================================
  //            LIVESTOCK DATA STREAMS
  // ==========================================

  /// Stream to watch all goats and automatically update the UI list when changes happen
  Stream<List<Goat>> watchGoats() async* {
    final isar = await db;
    yield* isar.goats.where().watch(fireImmediately: true);
  }

  /// Delete a goat record directly out of storage using its unique ID index
  Future<void> deleteGoat(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goats.delete(id);
    });
  }

  // ==========================================
  //          FINANCIAL DATA STREAMS
  // ==========================================

  /// FIXED STEP: Streams financial rows safely using a universal property filter
  /// This bypasses missing code-generation extensions and eliminates the compiler crash.
  Stream<List<FinancialTransaction>> watchFinancialTransactions() async* {
    final isar = await db;
    yield* isar.financialTransactions.where().anyId().watch(fireImmediately: true);
  }

  /// Delete a transaction entry directly from the money ledger rows
  Future<void> deleteTransaction(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.financialTransactions.delete(id);
    });
  }
}
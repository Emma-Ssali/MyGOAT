import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/goat.dart';
import '../models/transaction.dart'; // Import your existing transaction model

class DatabaseService {
  // A Future that holds the initialized Isar database instance once open.
  late Future<Isar> db;

  DatabaseService() {
    // Automatically trigger database initialization when this service instance is spawned.
    db = openDB();
  }

  /// Handles finding the local device's application directory and spinning up Isar safely.
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      
      // We add FinancialTransactionSchema right next to GoatSchema inside the list
      return await Isar.open(
        [
          GoatSchema, 
          FinancialTransactionSchema
        ], 
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  /// Streams the collection of goats from local Isar disk storage in real-time.
  Stream<List<Goat>> watchGoats() async* {
    final isar = await db;
    yield* isar.goats.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  /// Removes a livestock entry completely out of the local mobile disk file.
  Future<void> deleteGoat(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goats.delete(id);
    });
  }

  // =========================================================================
  // FINANCIAL TRANSACTIONS DATABASE LOGERS
  // =========================================================================

  /// Listens to the local financial transaction ledger table dynamically.
  Stream<List<FinancialTransaction>> watchTransactions() async* {
    final isar = await db;
    // Pushes financial entries to the UI ordered by creation date (newest first).
    yield* isar.financialTransactions.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  /// Saves or updates a financial record inside local storage.
  Future<void> saveTransaction(FinancialTransaction txn) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.financialTransactions.put(txn);
    });
  }

  /// Removes a transaction entirely using its local database record reference ID.
  Future<void> deleteTransaction(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.financialTransactions.delete(id);
    });
  }
}
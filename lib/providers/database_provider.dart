import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mygoat/models/transaction.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          FinancialTransactionSchema,
        ],
        inspector: true,
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  // --- Live Stream Operation ---
  // This watches the Isar local collection and pushes updates to the UI automatically whenever a transaction changes
  Stream<List<FinancialTransaction>> watchTransactions() async* {
    final isar = await db;
    
    // Yield the initial collection state immediately on listen
    yield await isar.financialTransactions.where().findAll();
    
    // Listen for any local writes/deletes and yield the freshly updated list
    await for (final _ in isar.financialTransactions.watchLazy()) {
      yield await isar.financialTransactions.where().findAll();
    }
  }

  // --- Transaction Operations ---
  Future<void> saveTransaction(FinancialTransaction txn) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.financialTransactions.put(txn);
    });
  }

  Future<void> deleteTransaction(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.financialTransactions.delete(id);
    });
  }

  // --- Goat Operations ---
  Future<void> deleteGoat(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // Setup when goat collection is ready
    });
  }
}

// 1. The primary database service locator provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// 2. The missing live stream provider for transactions that your UI views can watch directly
final transactionsStreamProvider = StreamProvider<List<FinancialTransaction>>((ref) {
  final service = ref.watch(databaseServiceProvider);
  return service.watchTransactions();
});
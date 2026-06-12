import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mygoat/models/transaction.dart';
// If you have a goat model, make sure it's imported here too:
// import 'package:mygoat/models/goat.dart'; 

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
          // GoatSchema, // Uncomment and add your Goat schema here if applicable
        ],
        inspector: true,
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
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
      // Replace 'goats' with your actual collection name from your Goat model
      // await isar.goats.delete(id); 
    });
  }
}

// This is the provider your UI views are reading via ref.read(databaseServiceProvider)
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
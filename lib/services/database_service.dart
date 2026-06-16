import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/goat.dart';
import '../models/transaction.dart'; // NEW: import the transaction model

class DatabaseService {
  // Expose the raw Isar instance publicly so providers can read it
  late final Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    
    // Open the Isar database instance
    isar = await Isar.open(
      [GoatSchema, FinancialTransactionSchema], // NEW: include the transaction schema
      directory: dir.path,
    );
  }
}
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/goat.dart';
import '../models/transaction.dart'; // NEW: import the transaction model
import '../models/health_record.dart'; // WELCOMES YOUR NEW HEALTH NOTEBOOK
import '../models/weight_record.dart';
import '../models/breeding_record.dart';

class DatabaseService {
  // Expose the raw Isar instance publicly so providers can read it
  late final Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    
    // Open the Isar database instance
    isar = await Isar.open(
      [GoatSchema, FinancialTransactionSchema, HealthRecordSchema, WeightRecordSchema, BreedingRecordSchema], // NEW: include all schema
      directory: dir.path,
    );
  }
}
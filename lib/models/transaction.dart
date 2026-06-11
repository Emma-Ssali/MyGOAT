import 'package:isar/isar.dart';

// This will also show a target generation error for now, which is normal!
part 'transaction.g.dart';

@Collection()
class FinancialTransaction {
  Id id = Isar.autoIncrement; // Auto-incrementing local ID

  late String type;        // Must be 'Income' or 'Expense'
  late String category;    // e.g., 'Goat Sale', 'Feed Purchase', 'Veterinary Care'
  late double amount;      // Cash value of the transaction
  late DateTime date;      // When the transaction occurred
  
  String? description;     // Optional notes or details about the transaction
  String? associatedTag;   // Optional link to tie this cash flow to a specific goat's tagNumber

  // Timestamps for synchronization tracking
  late DateTime createdAt;
}
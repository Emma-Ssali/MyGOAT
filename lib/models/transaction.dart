import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class FinancialTransaction {
  Id? id; // Nullable auto-increment key

  late double amount;
  late String category;
  late String description;
  late bool isIncome; // Explicitly matching what the providers need!
  late DateTime date;
  late DateTime lastSyncedAt;

  // Added this field to allow transactions to be isolated to individual goats
  String? linkedGoatTagId; 
}
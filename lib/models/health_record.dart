import 'package:isar/isar.dart';

part 'health_record.g.dart';

@collection
class HealthRecord {
  Id? id;

  // null = not linked to a specific goat (general/farm-wide entry)
  int? goatId;

  late DateTime date;
  late String recordType;
  late String title;
  late String description;
  late double cost;

  // Tracks the FinancialTransaction generated from this record's cost,
  // so edits/deletes can keep the financial ledger in sync.
  int? linkedTransactionId;
}
import 'package:isar/isar.dart';

// This links this file to the generated code that Isar will produce in Step 4.
// It will show a red squiggly line for now, which is completely expected!
part 'goat.g.dart';

@Collection()
class Goat {
  Id id = Isar.autoIncrement; // Isar's local primary key auto-incrementing integer

  @Index(unique: true, replace: true)
  late String tagNumber; // Unique identifiers like a physical ear tag ID

  late String breed;       // e.g., Boer, Kalahari Red, Saanen, Anglo-Nubian
  late String gender;      // Male / Female
  late DateTime dateOfBirth;
  
  late String status;      // Active, Sold, Sick, Deceased
  String? weightKg;        // Optional tracking weight metric
  String? notes;           // General health or behavior notes

  // Standard metadata timestamps required for future cloud sync strategies
  late DateTime createdAt;
  late DateTime updatedAt;
}
import 'package:isar/isar.dart';

part 'health_record.g.dart';

@collection
class HealthRecord {
  Id? id; // The app automatically numbers each record (1, 2, 3...)

  // This links this health entry to the specific goat's database number
  late int goatId; 

  late DateTime date;         // The day you gave the treatment
  late String recordType;     // This will be: 'Vaccination', 'Treatment', 'Deworming', or 'Vet Visit'
  late String title;          // What medicine/service was given (e.g., "Brucellosis Vaccine")
  late String description;    // Your notes (e.g., "Given 2ml dose by Dr. Peter")
  late double cost;           // How much money this care cost you
}
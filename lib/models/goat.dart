import 'package:isar/isar.dart';

part 'goat.g.dart';

@collection
class Goat {
  Id? id;

  @Index(unique: true, replace: false)
  late String tagId;

  late String breed;
  late String gender;       // 'Male' or 'Female'
  late String status;       // 'Active', 'Sold', 'Dead', 'Missing'
  late double weight;
  late DateTime dateOfBirth;
  late DateTime dateOfAcquisition;  // NEW: separate from date of birth
  late String acquisitionSource;    // NEW: Purchased, Born on Farm, Donated, Gift, Other
  String? acquisitionNote;          // NEW: free text for when source is 'Other'
  late bool isTagged;
  late DateTime createdAt;
  late DateTime lastSyncedAt;
  String? photoPath;
}
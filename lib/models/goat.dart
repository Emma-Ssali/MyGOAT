import 'package:isar/isar.dart';

part 'goat.g.dart';

@collection
class Goat {
  Id? id; // Nullable so Isar handles auto-increment automatically

  @Index(unique: true, replace: true)
  late String tagId;

  late String breed;
  late String gender;
  late String status;
  late double weight;
  late DateTime dateOfBirth;
  late bool isTagged;
  late DateTime createdAt;
  late DateTime lastSyncedAt;
}
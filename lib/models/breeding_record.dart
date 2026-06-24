import 'package:isar/isar.dart';

part 'breeding_record.g.dart';

@collection
class BreedingRecord {
  Id? id;

  late int goatId;           // The doe (female) being bred
  late DateTime matingDate;
  String? sireTagId;         // Buck's tag — optional, could be external
  DateTime? expectedKiddingDate;
  late String outcome;       // 'Pending', 'Pregnant', 'Kidded', 'Failed'
  int? numberOfKids;
  String? notes;
}
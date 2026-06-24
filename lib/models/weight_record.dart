import 'package:isar/isar.dart';

part 'weight_record.g.dart';

@collection
class WeightRecord {
  Id? id;

  late int goatId;
  late DateTime date;
  late double weightKg;
  String? notes;
}
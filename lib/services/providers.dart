import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';   // ✅ unlocks watch(), findAll(), etc.
import 'database_service.dart';
import 'farm_repository.dart';
import '../models/goat.dart';
import '../models/health_record.dart';

// 1. Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// 2. Repository provider
final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return FarmRepository(dbService.isar);
});

// 3. Goats stream provider
final watchGoatsProvider = StreamProvider.autoDispose<List<Goat>>((ref) {
  final repository = ref.watch(farmRepositoryProvider);
  return repository.watchGoats();
});

// 4. Direct database reference
final farmDatabaseProvider = Provider((ref) {
  return ref.watch(databaseServiceProvider);
});

// 5. Per-goat health records stream
final watchHealthRecordsProvider =
    StreamProvider.family.autoDispose<List<HealthRecord>, int>((ref, goatId) {
  final repository = ref.watch(farmRepositoryProvider);
  return repository.isar.healthRecords
      .filter()
      .goatIdEqualTo(goatId)
      .sortByDateDesc()
      .watch(fireImmediately: true);
});

// 6. Global health records stream
final watchAllHealthRecordsProvider =
    StreamProvider.autoDispose<List<HealthRecord>>((ref) {
  final repo = ref.watch(farmRepositoryProvider);
  return repo.isar.healthRecords
      .where()
      .sortByDateDesc()
      .watch(fireImmediately: true);
});

// 7. Per-goat health summary provider
final goatHealthSummaryProvider =
    FutureProvider.family.autoDispose<Map<String, dynamic>, int>((ref, goatId) async {
  final repository = ref.watch(farmRepositoryProvider);
  final records = await repository.isar.healthRecords
      .filter()
      .goatIdEqualTo(goatId)
      .findAll();

  final totalTreatments = records.length;
  final totalCost = records.fold<double>(0.0, (sum, r) => sum + (r.cost ?? 0.0));

  return {
    'totalTreatments': totalTreatments,
    'totalCost': totalCost,
  };
});

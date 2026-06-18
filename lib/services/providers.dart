import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';
import 'farm_repository.dart';
import '../models/goat.dart';
import '../models/health_record.dart';

// 1. Spawns one single, permanent instance of your local database engine wrapper
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// 2. Spawns the repository clerk, extracting the EXACT inner Isar instance it needs
final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return FarmRepository(dbService.isar);
});

// 3. The live stream provider that watches your local storage and auto-refreshes your UI list
// FIX: We explicitly declare the AutoDispose StreamProvider type to eliminate compilation lookup drops
final watchGoatsProvider = StreamProvider.autoDispose<List<Goat>>((ref) {
  final repository = ref.watch(farmRepositoryProvider);
  return repository.watchGoats();
});

// 4. Provides a clean reference to your core database service for financial layers
final farmDatabaseProvider = Provider((ref) {
  return ref.watch(databaseServiceProvider);
});

// 5. This provider acts as a direct line to stream health entries into your UI screens
final watchHealthRecordsProvider = StreamProvider.family.autoDispose<List<HealthRecord>, int>((ref, goatId) {
  final repository = ref.watch(farmRepositoryProvider);
  return repository.watchHealthRecords(goatId);
});
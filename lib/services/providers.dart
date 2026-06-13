import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';
import 'farm_repository.dart';
import '../models/goat.dart';

// 1. Spawns one single, permanent instance of your local database engine
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// 2. Spawns the repository clerk, injecting the database engine straight into it
final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return FarmRepository(dbService);
});

// 3. The live stream provider that watches your local storage and auto-refreshes your UI list
final watchGoatsProvider = StreamProvider<List<Goat>>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return dbService.watchGoats();
});
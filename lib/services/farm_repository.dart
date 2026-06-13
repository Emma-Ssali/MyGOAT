import 'package:isar/isar.dart';
import 'database_service.dart';
import '../models/goat.dart';

class FarmRepository {
  final DatabaseService _dbService;

  FarmRepository(this._dbService);

  /// Saves or updates an animal profile instantly to offline storage
  Future<void> addOrUpdateGoat(Goat goat) async {
    final isar = await _dbService.db;
    
    // Isar completely requires database changes to happen within a write transaction block
    await isar.writeTxn(() async {
      await isar.goats.put(goat); // .put automatically adds new rows or rewrites duplicates safely
    });
    
    _triggerBackgroundSync(goat);
  }

  /// Temporary placeholder for your future cloud integration phase
  void _triggerBackgroundSync(Goat goat) {
    // For now, it logs safely to the console and retains a pure offline profile state
    print('Local Storage Confirmed! Tag ID: ${goat.tagId} is securely saved on-device.');
  }
}
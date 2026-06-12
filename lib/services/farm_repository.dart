import 'package:isar/isar.dart';
import 'database_service.dart';
import '../models/goat.dart';

class FarmRepository {
  // Reference to our base local storage engines.
  final DatabaseService _dbService;

  FarmRepository(this._dbService);

  /// Central endpoint used by screens to write or update goat information.
  /// This ensures data is written to local storage immediately, regardless of network status.
  Future<void> addOrUpdateGoat(Goat goat) async {
    final isar = await _dbService.db;
    
    // 1. Force save the data record inside our local offline storage thread first
    await isar.writeTxn(() async {
      await isar.goats.put(goat); // .put updates existing IDs or increments new ones cleanly.
    });
    
    // 2. Queue up the cloud task immediately after local storage confirms success.
    // If there is no network, this will quietly catch or manage background retries!
    _triggerBackgroundSync(goat);
  }

  /// Placeholder function pointing directly toward your upcoming cloud pipeline.
  /// This handles background mirroring to external cloud databases like Supabase.
  void _triggerBackgroundSync(Goat goat) {
    // PHASE 3 OFFLINE SYNC PIPELINE HOOK:
    // This allows network calls to be handled quietly in the background, 
    // ensuring the user's interface remains completely unfreezable in the field.
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goat.dart';
import '../services/providers.dart';

class GoatDashboardView extends ConsumerStatefulWidget {
  const GoatDashboardView({super.key});

  @override
  ConsumerState<GoatDashboardView> createState() => _GoatDashboardViewState();
}

class _GoatDashboardViewState extends ConsumerState<GoatDashboardView> {
  @override
  Widget build(BuildContext context) {
    final goatsAsyncValue = ref.watch(watchGoatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyGOAT Ledger', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 2,
      ),
      body: goatsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, stack) => Center(child: Text('Database Error: $err', style: const TextStyle(color: Colors.red))),
        data: (goatList) {
          final totalHerd = goatList.length;
          final taggedCount = goatList.where((g) => g.tagId.isNotEmpty).length;
          final untaggedCount = totalHerd - taggedCount;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _buildSummaryCard('Total Herd', totalHerd.toString(), Colors.green),
                    _buildSummaryCard('Tagged', taggedCount.toString(), Colors.blue),
                    _buildSummaryCard('No Tag', untaggedCount.toString(), Colors.orange),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: goatList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No livestock registered yet.', 
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: goatList.length,
                        itemBuilder: (context, index) {
                          final goat = goatList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: Icon(Icons.gavel, color: Colors.green.shade800),
                              ),
                              title: Text(
                                goat.tagId.isEmpty ? 'UNTAGGED ANIMAL' : 'Tag ID: ${goat.tagId}', 
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // FIXED HERE: Changed goat.weightKg to goat.weight
                              subtitle: Text('Breed: ${goat.breed} | Mass: ${goat.weight} kg'),
                              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoatModal(context),
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Goat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoatModal(BuildContext context) {
    final tagController = TextEditingController();
    final breedController = TextEditingController();
    final weightController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16, right: 16, top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Register New Goat Profile', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                ),
                const SizedBox(height: 16),
                TextField(controller: tagController, decoration: const InputDecoration(labelText: 'Ear Tag ID Number', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: breedController, decoration: const InputDecoration(labelText: 'Breed (e.g., Boer, Savanna)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () async {
                    final newGoat = Goat()
                      ..tagId = tagController.text.trim()
                      ..breed = breedController.text.trim()
                      // FIXED HERE: Changed weightKg to weight
                      ..weight = double.tryParse(weightController.text) ?? 0.0;

                    await ref.read(farmRepositoryProvider).addOrUpdateGoat(newGoat);

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Data Profile to Herd Ledger', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
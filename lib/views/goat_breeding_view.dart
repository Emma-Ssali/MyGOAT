import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/breeding_record.dart';
import '../services/providers.dart';

class GoatBreedingView extends ConsumerWidget {
  final int goatId;

  const GoatBreedingView({super.key, required this.goatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real-time breeding logs for this specific goat ID
    final breedingAsync = ref.watch(watchBreedingRecordsProvider(goatId));

    return Scaffold(
      body: breedingAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No breeding history logged for this animal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.child_care, color: Colors.purple),
                              const SizedBox(width: 8),
                              Text(
                                'Outcome: ${record.outcome}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // Display total offspring count if animal already kidded
                          if (record.numberOfKids != null && record.numberOfKids! > 0)
                            Chip(
                              label: Text('${record.numberOfKids} Kids'),
                              backgroundColor: Colors.purple.withOpacity(0.1),
                            ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        'Mating Date: ${record.matingDate.day}/${record.matingDate.month}/${record.matingDate.year}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (record.expectedKiddingDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Expected Kidding: ${record.expectedKiddingDate!.day}/${record.expectedKiddingDate!.month}/${record.expectedKiddingDate!.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: record.outcome == 'Pending' || record.outcome == 'Pregnant'
                                ? Colors.green.shade700
                                : Colors.grey,
                            fontWeight: record.outcome == 'Pregnant' ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                      if (record.sireTagId != null && record.sireTagId!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Sire (Sire Tag ID): ${record.sireTagId}',
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ],
                      if (record.notes != null && record.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Notes: ${record.notes}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.purple)),
        error: (err, stack) => Center(child: Text('Error loading history: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBreedingDialog(context, ref),
        label: const Text('Log Breeding'),
        icon: const Icon(Icons.add_circle_outline),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _showAddBreedingDialog(BuildContext context, WidgetRef ref) {
    final sireController = TextEditingController();
    final kidsController = TextEditingController();
    final notesController = TextEditingController();
    String selectedOutcome = 'Pending';
    DateTime selectedMatingDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Log Breeding Cycle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mating Date Selector
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mating Date'),
                      subtitle: Text(
                        '${selectedMatingDate.day}/${selectedMatingDate.month}/${selectedMatingDate.year}',
                      ),
                      trailing: const Icon(Icons.calendar_month, color: Colors.purple),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedMatingDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedMatingDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: sireController,
                      decoration: const InputDecoration(
                        labelText: 'Sire Tag ID (Optional)',
                        hintText: 'e.g. BUCK-092',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedOutcome,
                      items: ['Pending', 'Pregnant', 'Kidded', 'Failed']
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedOutcome = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Cycle Status/Outcome'),
                    ),
                    // Only show kid volume counts if status selection shows 'Kidded'
                    if (selectedOutcome == 'Kidded')
                      TextField(
                        controller: kidsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Number of Kids Born',
                        ),
                      ),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Cycle Notes'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () async {
                    // Approximate goat gestation period is roughly 150 days
                    final computedKiddingDate = selectedMatingDate.add(const Duration(days: 150));
                    final kidsBornCount = int.tryParse(kidsController.text);

                    final newRecord = BreedingRecord()
                      ..goatId = goatId
                      ..matingDate = selectedMatingDate
                      ..expectedKiddingDate = computedKiddingDate
                      ..sireTagId = sireController.text.trim().isEmpty ? null : sireController.text.trim()
                      ..outcome = selectedOutcome
                      ..numberOfKids = selectedOutcome == 'Kidded' ? kidsBornCount : null
                      ..notes = notesController.text.trim().isEmpty ? null : notesController.text.trim();

                    await ref.read(farmRepositoryProvider).saveBreedingRecord(newRecord);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Record', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
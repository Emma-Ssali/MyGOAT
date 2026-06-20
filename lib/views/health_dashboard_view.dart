import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_record.dart';
import '../models/goat.dart';
import '../services/providers.dart';

class HealthDashboardView extends ConsumerWidget {
  const HealthDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthRecordsAsync = ref.watch(watchAllHealthRecordsProvider);
    final goatsAsync = ref.watch(watchGoatsProvider);
    final goats = goatsAsync.value ?? [];
    final tagById = {for (final g in goats) if (g.id != null) g.id!: g.tagId};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        backgroundColor: Colors.redAccent,
      ),
      body: healthRecordsAsync.when(
        data: (records) {
          final totalRecords = records.length;
          final totalCost = records.fold(0.0, (sum, r) => sum + r.cost);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _summaryCard('Total Treatments', totalRecords.toString(), Colors.redAccent),
                    _summaryCard('Total Cost', 'UGX ${totalCost.toStringAsFixed(0)}', Colors.orange),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: records.isEmpty
                    ? const Center(child: Text('No health records logged yet.'))
                    : ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          final linkedTag = record.goatId != null ? tagById[record.goatId] : null;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: const Icon(Icons.medical_services, color: Colors.redAccent),
                              title: Text('${record.recordType}: ${record.title}'),
                              subtitle: Text(
                                '${record.description}\n'
                                'Cost: UGX ${record.cost.toStringAsFixed(0)} • '
                                '${record.date.day}/${record.date.month}/${record.date.year}'
                                '${linkedTag != null ? '\nGoat: $linkedTag' : ''}',
                              ),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showAddHealthRecordDialog(
                                      context,
                                      ref,
                                      goats,
                                      existingRecord: record,
                                    );
                                  } else if (value == 'delete') {
                                    _confirmDelete(context, ref, record);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add),
        label: const Text('Log New Care'),
        onPressed: () => _showAddHealthRecordDialog(context, ref, goats),
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, HealthRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record?'),
        content: Text(
          'Delete "${record.recordType}: ${record.title}"? '
          'This will also remove its linked expense entry, if any.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              if (record.id != null) {
                await ref.read(farmRepositoryProvider).deleteHealthRecord(record.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddHealthRecordDialog(
    BuildContext context,
    WidgetRef ref,
    List<Goat> goats, {
    HealthRecord? existingRecord,
  }) {
    final isEditing = existingRecord != null;
    final titleController = TextEditingController(text: existingRecord?.title ?? '');
    final notesController = TextEditingController(text: existingRecord?.description ?? '');
    final costController = TextEditingController(
      text: existingRecord != null ? existingRecord.cost.toStringAsFixed(0) : '',
    );
    String chosenType = existingRecord?.recordType ?? 'Vaccination';
    int? selectedGoatId = existingRecord?.goatId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Medical Care' : 'Log New Medical Care'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: chosenType,
                      items: ['Vaccination', 'Treatment', 'Deworming', 'Vet Visit']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            chosenType = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Care Type'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int?>(
                      value: selectedGoatId,
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('General (no specific goat)'),
                        ),
                        ...goats.map(
                          (g) => DropdownMenuItem<int?>(
                            value: g.id,
                            child: Text('Tag: ${g.tagId} • ${g.breed}'),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedGoatId = val;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Link to Goat (optional)'),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Treatment Name'),
                    ),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Notes / Details'),
                    ),
                    TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cost (UGX)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    final recordCost = double.tryParse(costController.text) ?? 0.0;

                    final record = existingRecord ?? HealthRecord();
                    record
                      ..goatId = selectedGoatId
                      ..date = existingRecord?.date ?? DateTime.now()
                      ..recordType = chosenType
                      ..title = titleController.text.trim()
                      ..description = notesController.text.trim()
                      ..cost = recordCost;

                    await ref.read(farmRepositoryProvider).saveHealthRecord(record);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Update Record' : 'Save Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
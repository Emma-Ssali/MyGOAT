import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygoat/models/transaction.dart';
import 'package:mygoat/models/health_record.dart'; 
import 'package:mygoat/providers/database_provider.dart';
import 'package:mygoat/services/providers.dart' hide databaseServiceProvider; 

class GoatDetailView extends ConsumerWidget {
  final dynamic goat; 
  
  const GoatDetailView({super.key, required this.goat});

  void _showAddHealthRecordDialog(BuildContext context, WidgetRef ref, int goatId) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    final costController = TextEditingController();
    String chosenType = 'Vaccination'; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Log New Medical Care'),
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
                        if (val != null) setState(() => chosenType = val);
                      },
                      decoration: const InputDecoration(labelText: 'Care Type'),
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final recordCost = double.tryParse(costController.text) ?? 0.0;
                    final cleanTitle = titleController.text.trim().isEmpty ? 'General Care' : titleController.text.trim();

                    // Saving this also creates/updates the linked financial
                    // expense entry automatically (see FarmRepository.saveHealthRecord).
                    final newLog = HealthRecord()
                      ..goatId = goatId
                      ..date = DateTime.now()
                      ..recordType = chosenType
                      ..title = cleanTitle
                      ..description = notesController.text.trim()
                      ..cost = recordCost;

                    final repo = ref.read(farmRepositoryProvider);
                    await repo.saveHealthRecord(newLog);

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Goat ${goat.tagId ?? ""} Details')),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            // =========================================================================
            // 💸 SECTION 1: LIVE FINANCIAL TRANSACTIONS LIST
            // =========================================================================
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Financial Ledger",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Manual Expense Amount (UGX)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            ref.watch(transactionsStreamProvider).when(
              data: (txns) {
                final filtered = txns.where((t) => t.linkedGoatTagId == goat.tagId).toList();

                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No financial transactions linked to this goat.", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final t = filtered[index];
                    final isInc = t.isIncome; 

                    return ListTile(
                      title: Text(t.category),
                      subtitle: Text(t.description),
                      trailing: Text(
                        '${isInc ? "+" : "-"}${t.amount} UGX', 
                        style: TextStyle(color: isInc ? Colors.green : Colors.red),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Error loading transactions: $err"),
              ),
            ),
            
            const SizedBox(height: 12),
            
            ElevatedButton(
              onPressed: () async {
                final manualAmount = double.tryParse(amountController.text) ?? 0.0;
                if (manualAmount > 0) {
                  final performanceTxn = FinancialTransaction()
                    ..amount = manualAmount
                    ..category = 'Goat Expenses'
                    ..description = 'Linked to Goat Tag: ${goat.tagId}'
                    ..isIncome = false 
                    ..linkedGoatTagId = goat.tagId
                    ..date = DateTime.now()
                    ..lastSyncedAt = DateTime.now();

                  await ref.read(databaseServiceProvider).saveTransaction(performanceTxn);
                  amountController.clear(); 
                }
              },
              child: const Text('Add Expense for this Goat'),
            ),

            const Divider(height: 40, thickness: 2),

            // =========================================================================
            // 🩺 SECTION 2: LIVE MEDICAL & HEALTH HISTORY BOX
            // =========================================================================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Medical & Health History",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddHealthRecordDialog(context, ref, goat.id!);
                        },
                        icon: const Icon(Icons.medical_services),
                        label: const Text("Log Care"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  ref.watch(watchHealthRecordsProvider(goat.id!)).when(
                    data: (records) {
                      if (records.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text("No health treatments recorded yet.", style: TextStyle(color: Colors.grey)),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: const Icon(Icons.healing, color: Colors.redAccent),
                              title: Text("${record.recordType}: ${record.title}"),
                              subtitle: Text("${record.description}\nCost: ${record.cost.toString()} UGX"), 
                              trailing: Text("${record.date.day}/${record.date.month}/${record.date.year}"),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Text("Error loading logs: $err"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mygoat/models/transaction.dart';
import 'package:mygoat/providers/database_provider.dart';

class FinancialDashboardView extends ConsumerWidget {
  const FinancialDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Fetch your active database provider directly from Riverpod
    final databaseService = ref.watch(databaseServiceProvider);

    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'General';
    String selectedType = 'Expense';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber.shade800,
      ),
      // 2. We use a dynamic FutureBuilder to get the Isar database instance from your provider setup
      body: FutureBuilder<Isar>(
        future: databaseService.db,
        builder: (context, databaseSnapshot) {
          if (databaseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
          if (databaseSnapshot.hasError || !databaseSnapshot.hasData) {
            return Center(child: Text('Database Error: ${databaseSnapshot.error}', style: const TextStyle(color: Colors.red)));
          }

          final isarInstance = databaseSnapshot.data!;

          // 3. Listen directly to your financial transactions table stream from the Isar instance
          return StreamBuilder<List<FinancialTransaction>>(
            stream: isarInstance.financialTransactions.where().anyId().watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.amber));
              }

              final transactions = snapshot.data ?? [];

              if (transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('No transactions logged yet.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final txn = transactions[index];
                  final isIncome = txn.isIncome;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text('${isIncome ? "+" : "-"} UGX ${txn.amount.toStringAsFixed(0)}'),
                      subtitle: Text('${txn.category} • ${txn.description}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (txn.id != null) {
                            // Run transaction block to perform a delete operation
                            await isarInstance.writeTxn(() async {
                              await isarInstance.financialTransactions.delete(txn.id as Id);
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return AlertDialog(
                    title: const Text('Log Transaction'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Center(child: Text('Expense')),
                                selected: selectedType == 'Expense',
                                onSelected: (val) => setModalState(() => selectedType = 'Expense'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Center(child: Text('Income')),
                                selected: selectedType == 'Income',
                                onSelected: (val) => setModalState(() => selectedType = 'Income'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Amount (UGX)', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(labelText: 'Description / Memo', border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final enteredAmount = double.tryParse(amountController.text) ?? 0.0;
                          if (enteredAmount <= 0) return;

                          final newTransaction = FinancialTransaction()
                            ..amount = enteredAmount
                            ..category = selectedCategory
                            ..description = descriptionController.text.trim()
                            ..isIncome = (selectedType == 'Income')
                            ..date = DateTime.now()
                            ..lastSyncedAt = DateTime.now();

                          // Get the active Isar instance from the service layer context
                          final isarInstance = await databaseService.db;
                          await isarInstance.writeTxn(() async {
                            await isarInstance.financialTransactions.put(newTransaction);
                          });

                          amountController.clear();
                          descriptionController.clear();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
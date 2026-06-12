import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygoat/models/transaction.dart';
import 'package:mygoat/providers/database_provider.dart';

class FinancialDashboardView extends ConsumerWidget {
  const FinancialDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder list. Ensure this connects to your active stream or watcher providers
    final List<FinancialTransaction> transactions = []; 
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'General';
    String selectedType = 'Expense'; 

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Dashboard')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          final isIncome = txn.isIncome; 

          return ListTile(
            title: Text('${isIncome ? "+" : "-"}\$${txn.amount.toStringAsFixed(2)}'),
            subtitle: Text(txn.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (txn.id != null) {
                  ref.read(databaseServiceProvider).deleteTransaction(txn.id!);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newTransaction = FinancialTransaction()
            ..amount = double.tryParse(amountController.text) ?? 0.0
            ..category = selectedCategory
            ..description = descriptionController.text
            ..isIncome = (selectedType == 'Income') 
            ..date = DateTime.now()
            ..lastSyncedAt = DateTime.now();

          ref.read(databaseServiceProvider).saveTransaction(newTransaction);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
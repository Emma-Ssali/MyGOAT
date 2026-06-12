import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygoat/models/transaction.dart';
import 'package:mygoat/providers/database_provider.dart';

class GoatDetailView extends ConsumerWidget {
  final dynamic goat; 
  
  const GoatDetailView({super.key, required this.goat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FinancialTransaction> txns = []; 
    final amountController = TextEditingController();

    final filtered = txns.where((t) => t.linkedGoatTagId == goat.tagId).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Goat ${goat.tagId ?? ""} Details')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];
                final isInc = t.isIncome; 

                return ListTile(
                  title: Text(t.category),
                  subtitle: Text(t.description),
                  trailing: Text(
                    '${isInc ? "+" : "-"}\$${t.amount}',
                    style: TextStyle(color: isInc ? Colors.green : Colors.red),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final performanceTxn = FinancialTransaction()
                ..amount = double.tryParse(amountController.text) ?? 0.0
                ..category = 'Goat Expenses'
                ..description = 'Linked to Goat Tag: ${goat.tagId}'
                ..isIncome = false 
                ..linkedGoatTagId = goat.tagId
                ..date = DateTime.now()
                ..lastSyncedAt = DateTime.now();

              ref.read(databaseServiceProvider).saveTransaction(performanceTxn);
            },
            child: const Text('Add Expense for this Goat'),
          )
        ],
      ),
    );
  }
}
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goat.dart';
import '../models/transaction.dart';
import '../services/providers.dart';

class FinancialDashboardView extends ConsumerStatefulWidget {
  const FinancialDashboardView({super.key});

  @override
  ConsumerState<FinancialDashboardView> createState() => _FinancialDashboardViewState();
}

class _FinancialDashboardViewState extends ConsumerState<FinancialDashboardView> {

  // The fixed category list — 'Other' triggers a free text field
  static const List<String> _categories = [
    'Feed & Nutrition',
    'Veterinary & Medicine',
    'Sales (Goat Sold)',
    'Purchases (Goat Bought)',
    'Labour & Wages',
    'Equipment',
    'Other',
  ];

  // Active filter — null means show all
  String? _activeFilter;

  @override
  Widget build(BuildContext context) {
    final goatsAsync = ref.watch(watchGoatsProvider);
    final isar = ref.watch(databaseServiceProvider).isar;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Financial Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber.shade800,
      ),
      body: StreamBuilder<List<FinancialTransaction>>(
        stream: isar.financialTransactions.where().anyId().watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          final allTransactions = snapshot.data ?? [];

          // Filter by active category if one is selected
          final transactions = _activeFilter == null
              ? allTransactions
              : allTransactions.where((t) => t.category == _activeFilter).toList();

          // Summary calculations from ALL transactions (not filtered)
          final totalIncome = allTransactions
              .where((t) => t.isIncome)
              .fold(0.0, (sum, t) => sum + t.amount);
          final totalExpenses = allTransactions
              .where((t) => !t.isIncome)
              .fold(0.0, (sum, t) => sum + t.amount);
          final balance = totalIncome - totalExpenses;

          return Column(
            children: [

              // ── Summary Cards ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Running balance
                    Card(
                      color: balance >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Running Balance',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              'UGX ${balance.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: balance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Income and Expense totals side by side
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.green.shade50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Text('Total Income', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'UGX ${totalIncome.toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.red.shade50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Text('Total Expenses', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'UGX ${totalExpenses.toStringAsFixed(0)}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Category Filter Chips ──────────────────────────────
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    // "All" chip
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _activeFilter == null,
                        onSelected: (_) => setState(() => _activeFilter = null),
                        selectedColor: Colors.amber.shade100,
                      ),
                    ),
                    // One chip per category
                    ..._categories.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: _activeFilter == cat,
                        onSelected: (_) => setState(() {
                          _activeFilter = _activeFilter == cat ? null : cat;
                        }),
                        selectedColor: Colors.amber.shade100,
                      ),
                    )),
                  ],
                ),
              ),

              const Divider(height: 1),

              // ── Transaction List ───────────────────────────────────
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              _activeFilter == null
                                  ? 'No transactions logged yet.'
                                  : 'No transactions in "$_activeFilter".',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final txn = transactions[index];
                          final isIncome = txn.isIncome;
                          final formattedDate = "${txn.date.toLocal()}".split(' ')[0];

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                                child: Icon(
                                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                              title: Text(
                                '${isIncome ? "+" : "-"} UGX ${txn.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${txn.category} • $formattedDate'),
                                  if (txn.description.isNotEmpty)
                                    Text(txn.description, style: TextStyle(color: Colors.grey.shade600)),
                                  // Show linked goat tag if present
                                  if (txn.linkedGoatTagId != null && txn.linkedGoatTagId!.isNotEmpty)
                                    Text(
                                      'Goat: ${txn.linkedGoatTagId}',
                                      style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500),
                                    ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  if (txn.id != null) {
                                    await isar.writeTxn(() async {
                                      await isar.financialTransactions.delete(txn.id as Id);
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      // ── Add Transaction Button ─────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Transaction', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _showTransactionModal(context, goatsAsync),
      ),
    );
  }

  void _showTransactionModal(BuildContext context, AsyncValue<List<Goat>> goatsAsync) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryNoteController = TextEditingController();

    String selectedType = 'Expense';
    String selectedCategory = 'Feed & Nutrition';
    String? selectedGoatTagId;

    final isar = ref.read(databaseServiceProvider).isar;
    final goatList = goatsAsync.value ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                      'Log Transaction',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber.shade800),
                    ),
                    const SizedBox(height: 16),

                    // Income / Expense toggle
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Expense')),
                            selected: selectedType == 'Expense',
                            selectedColor: Colors.red.shade100,
                            onSelected: (_) => setModalState(() => selectedType = 'Expense'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Income')),
                            selected: selectedType == 'Income',
                            selectedColor: Colors.green.shade100,
                            onSelected: (_) => setModalState(() => selectedType = 'Income'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount (UGX)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description / Memo', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      items: _categories
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) => setModalState(() => selectedCategory = val!),
                    ),
                    const SizedBox(height: 12),

                    // Free text — only shown when Other is selected
                    if (selectedCategory == 'Other') ...[
                      TextField(
                        controller: categoryNoteController,
                        decoration: const InputDecoration(
                          labelText: 'Please specify category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Link to a goat — dropdown of all tag IDs
                    DropdownButtonFormField<String>(
                      value: selectedGoatTagId,
                      decoration: const InputDecoration(
                        labelText: 'Link to Goat (optional)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('None')),
                        ...goatList.map((g) => DropdownMenuItem(
                          value: g.tagId,
                          child: Text(g.tagId.isEmpty ? 'UNTAGGED' : g.tagId),
                        )),
                      ],
                      onChanged: (val) => setModalState(() => selectedGoatTagId = val),
                    ),
                    const SizedBox(height: 20),

                    // Save button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final enteredAmount = double.tryParse(amountController.text) ?? 0.0;
                        if (enteredAmount <= 0) return;

                        final newTransaction = FinancialTransaction()
                          ..amount = enteredAmount
                          ..category = selectedCategory == 'Other'
                              ? categoryNoteController.text.trim()
                              : selectedCategory
                          ..description = descriptionController.text.trim()
                          ..isIncome = (selectedType == 'Income')
                          ..linkedGoatTagId = selectedGoatTagId
                          ..date = DateTime.now()
                          ..lastSyncedAt = DateTime.now();

                        await isar.writeTxn(() async {
                          await isar.financialTransactions.put(newTransaction);
                        });

                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        'Save Transaction',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygoat/models/transaction.dart';
import 'package:mygoat/models/health_record.dart';
import 'package:mygoat/models/weight_record.dart';
import 'package:mygoat/models/breeding_record.dart';
import 'package:mygoat/services/providers.dart';

class GoatDetailView extends ConsumerWidget {
  final dynamic goat;

  const GoatDetailView({super.key, required this.goat});

  // =========================================================================
  // 🐐 PROFILE HEADER
  // =========================================================================
  Widget _buildProfileHeader(BuildContext context) {
    final dob = goat.dateOfBirth as DateTime;
    final now = DateTime.now();
    final ageMonths = (now.year - dob.year) * 12 + now.month - dob.month;
    final ageText = ageMonths >= 12
        ? '${(ageMonths / 12).floor()} yr ${ageMonths % 12} mo'
        : '$ageMonths months';

    final statusColor = {
          'Active': Colors.green,
          'Sold': Colors.orange,
          'Dead': Colors.red,
          'Missing': Colors.grey,
        }[goat.status] ??
        Colors.green;

    return Container(
      width: double.infinity,
      color: Colors.green.shade700,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          // Photo
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.green.shade300,
            backgroundImage: goat.photoPath != null
                ? FileImage(File(goat.photoPath!))
                : null,
            child: goat.photoPath == null
                ? const Icon(Icons.pets, size: 48, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 12),

          // Tag ID
          Text(
            goat.tagId?.isNotEmpty == true ? goat.tagId : 'Untagged',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          const SizedBox(height: 4),

          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              border: Border.all(color: statusColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              goat.status ?? 'Unknown',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),

          // Info grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _infoTile('Breed', goat.breed ?? '-'),
                _infoTile('Gender', goat.gender ?? '-'),
                _infoTile('Weight', '${goat.weight ?? 0} kg'),
                _infoTile('Age', ageText),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _infoTile('DoB',
                    '${dob.day}/${dob.month}/${dob.year}'),
                _infoTile(
                    'Acquired',
                    goat.dateOfAcquisition != null
                        ? '${(goat.dateOfAcquisition as DateTime).day}/${(goat.dateOfAcquisition as DateTime).month}/${(goat.dateOfAcquisition as DateTime).year}'
                        : '-'),
                _infoTile(
                    'Source', goat.acquisitionSource ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // =========================================================================
  // 🩺 HEALTH DIALOG
  // =========================================================================
  void _showHealthDialog(BuildContext context, WidgetRef ref,
      {HealthRecord? existing}) {
    final isEditing = existing != null;
    final titleController =
        TextEditingController(text: existing?.title ?? '');
    final notesController =
        TextEditingController(text: existing?.description ?? '');
    final costController = TextEditingController(
        text: existing != null ? existing.cost.toStringAsFixed(0) : '');
    String chosenType = existing?.recordType ?? 'Vaccination';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title:
              Text(isEditing ? 'Edit Medical Care' : 'Log New Medical Care'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: chosenType,
                  items: [
                    'Vaccination',
                    'Treatment',
                    'Deworming',
                    'Vet Visit'
                  ]
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => chosenType = val);
                  },
                  decoration:
                      const InputDecoration(labelText: 'Care Type'),
                ),
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(labelText: 'Treatment Name'),
                ),
                TextField(
                  controller: notesController,
                  decoration:
                      const InputDecoration(labelText: 'Notes / Details'),
                ),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Cost (UGX)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final recordCost =
                    double.tryParse(costController.text) ?? 0.0;
                final cleanTitle =
                    titleController.text.trim().isEmpty
                        ? 'General Care'
                        : titleController.text.trim();
                final record = existing ?? HealthRecord();
                record
                  ..goatId = goat.id
                  ..date = existing?.date ?? DateTime.now()
                  ..recordType = chosenType
                  ..title = cleanTitle
                  ..description = notesController.text.trim()
                  ..cost = recordCost;
                await ref
                    .read(farmRepositoryProvider)
                    .saveHealthRecord(record);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // ⚖️ WEIGHT DIALOG
  // =========================================================================
  void _showWeightDialog(BuildContext context, WidgetRef ref,
      {WeightRecord? existing}) {
    final isEditing = existing != null;
    final weightController = TextEditingController(
        text: existing != null ? existing.weightKg.toString() : '');
    final notesController =
        TextEditingController(text: existing?.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Weight' : 'Log Weight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            TextField(
              controller: notesController,
              decoration:
                  const InputDecoration(labelText: 'Notes (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final kg = double.tryParse(weightController.text);
              if (kg == null || kg <= 0) return;
              final record = existing ?? WeightRecord();
              record
                ..goatId = goat.id
                ..date = existing?.date ?? DateTime.now()
                ..weightKg = kg
                ..notes = notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim();
              await ref
                  .read(farmRepositoryProvider)
                  .saveWeightRecord(record);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 🐣 BREEDING DIALOG
  // =========================================================================
  void _showBreedingDialog(BuildContext context, WidgetRef ref,
      {BreedingRecord? existing}) {
    final isEditing = existing != null;
    final sireController =
        TextEditingController(text: existing?.sireTagId ?? '');
    final kidsController = TextEditingController(
        text: existing?.numberOfKids?.toString() ?? '');
    final notesController =
        TextEditingController(text: existing?.notes ?? '');
    String chosenOutcome = existing?.outcome ?? 'Pending';
    DateTime matingDate = existing?.matingDate ?? DateTime.now();
    DateTime? expectedKidding = existing?.expectedKiddingDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
              isEditing ? 'Edit Breeding Record' : 'Log Breeding Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mating Date'),
                  subtitle: Text(
                      '${matingDate.day}/${matingDate.month}/${matingDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: matingDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => matingDate = picked);
                  },
                ),
                TextField(
                  controller: sireController,
                  decoration: const InputDecoration(
                      labelText: 'Buck Tag ID (optional)'),
                ),
                DropdownButtonFormField<String>(
                  value: chosenOutcome,
                  items: ['Pending', 'Pregnant', 'Kidded', 'Failed']
                      .map((o) =>
                          DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => chosenOutcome = val);
                  },
                  decoration: const InputDecoration(labelText: 'Outcome'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Expected Kidding Date (optional)'),
                  subtitle: expectedKidding != null
                      ? Text(
                          '${expectedKidding!.day}/${expectedKidding!.month}/${expectedKidding!.year}')
                      : const Text('Not set',
                          style: TextStyle(color: Colors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today),
                      if (expectedKidding != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () =>
                              setState(() => expectedKidding = null),
                        ),
                    ],
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: expectedKidding ??
                          matingDate.add(const Duration(days: 150)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => expectedKidding = picked);
                    }
                  },
                ),
                if (chosenOutcome == 'Kidded')
                  TextField(
                    controller: kidsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Number of Kids Born'),
                  ),
                TextField(
                  controller: notesController,
                  decoration:
                      const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final record = existing ?? BreedingRecord();
                record
                  ..goatId = goat.id
                  ..matingDate = matingDate
                  ..sireTagId = sireController.text.trim().isEmpty
                      ? null
                      : sireController.text.trim()
                  ..expectedKiddingDate = expectedKidding
                  ..outcome = chosenOutcome
                  ..numberOfKids = chosenOutcome == 'Kidded'
                      ? int.tryParse(kidsController.text)
                      : null
                  ..notes = notesController.text.trim().isEmpty
                      ? null
                      : notesController.text.trim();
                await ref
                    .read(farmRepositoryProvider)
                    .saveBreedingRecord(record);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DELETE HELPERS
  // =========================================================================
  void _confirmDeleteHealth(
      BuildContext context, WidgetRef ref, HealthRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Health Record?'),
        content: Text(
            'Delete "${record.recordType}: ${record.title}"? This will also remove its linked expense.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              if (record.id != null) {
                await ref
                    .read(farmRepositoryProvider)
                    .deleteHealthRecord(record.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteWeight(
      BuildContext context, WidgetRef ref, WeightRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Weight Record?'),
        content: Text(
            'Delete the ${record.weightKg}kg entry from ${record.date.day}/${record.date.month}/${record.date.year}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              if (record.id != null) {
                await ref
                    .read(farmRepositoryProvider)
                    .deleteWeightRecord(record.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBreeding(
      BuildContext context, WidgetRef ref, BreedingRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Breeding Record?'),
        content: const Text('Delete this breeding event?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              if (record.id != null) {
                await ref
                    .read(farmRepositoryProvider)
                    .deleteBreedingRecord(record.id!);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION HEADER WIDGET
  // =========================================================================
  Widget _sectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          if (onAdd != null)
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // BUILD
  // =========================================================================
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Goat ${goat.tagId ?? ""} Details'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================================================================
            // 🐐 PROFILE HEADER
            // ================================================================
            _buildProfileHeader(context),

            // ================================================================
            // 💸 SECTION 1: FINANCIAL LEDGER
            // ================================================================
            _sectionHeader(
              title: 'Financial Ledger',
              icon: Icons.monetization_on,
              color: Colors.orange,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 4.0),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Manual Expense Amount (UGX)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final manualAmount =
                        double.tryParse(amountController.text) ?? 0.0;
                    if (manualAmount > 0) {
                      final txn = FinancialTransaction()
                        ..amount = manualAmount
                        ..category = 'Goat Expenses'
                        ..description =
                            'Linked to Goat Tag: ${goat.tagId}'
                        ..isIncome = false
                        ..linkedGoatTagId = goat.tagId
                        ..date = DateTime.now()
                        ..lastSyncedAt = DateTime.now();
                      await ref
                          .read(farmRepositoryProvider)
                          .saveTransaction(txn);
                      amountController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Expense for this Goat',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ref.watch(transactionsStreamProvider).when(
              data: (txns) {
                final filtered = txns
                    .where((t) => t.linkedGoatTagId == goat.tagId)
                    .toList();
                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        'No financial transactions linked to this goat.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final t = filtered[index];
                    return ListTile(
                      leading: Icon(
                        t.isIncome
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: t.isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(t.category),
                      subtitle: Text(t.description),
                      trailing: Text(
                        '${t.isIncome ? "+" : "-"} UGX ${t.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: t.isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $err'),
              ),
            ),

            const Divider(height: 32, thickness: 1),

            // ================================================================
            // 🩺 SECTION 2: HEALTH RECORDS
            // ================================================================
            _sectionHeader(
              title: 'Medical & Health History',
              icon: Icons.medical_services,
              color: Colors.redAccent,
              onAdd: () => _showHealthDialog(context, ref),
            ),
            ref.watch(watchHealthRecordsProvider(goat.id!)).when(
              data: (records) {
                if (records.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No health treatments recorded yet.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final r = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.healing,
                            color: Colors.redAccent),
                        title: Text('${r.recordType}: ${r.title}'),
                        subtitle: Text(
                            '${r.description}\nCost: UGX ${r.cost.toStringAsFixed(0)}'),
                        isThreeLine: true,
                        trailing: Text(
                            '${r.date.day}/${r.date.month}/${r.date.year}'),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showHealthDialog(context, ref,
                                        existing: r);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete,
                                      color: Colors.red),
                                  title: const Text('Delete',
                                      style:
                                          TextStyle(color: Colors.red)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _confirmDeleteHealth(
                                        context, ref, r);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Text('Error loading health logs: $err'),
            ),

            const Divider(height: 32, thickness: 1),

            // ================================================================
            // ⚖️ SECTION 3: WEIGHT RECORDS
            // ================================================================
            _sectionHeader(
              title: 'Weight History',
              icon: Icons.monitor_weight,
              color: Colors.teal,
              onAdd: () => _showWeightDialog(context, ref),
            ),
            ref.watch(watchWeightRecordsProvider(goat.id!)).when(
              data: (records) {
                if (records.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No weight records logged yet.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final r = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading:
                            const Icon(Icons.scale, color: Colors.teal),
                        title: Text('${r.weightKg} kg'),
                        subtitle:
                            r.notes != null ? Text(r.notes!) : null,
                        trailing: Text(
                            '${r.date.day}/${r.date.month}/${r.date.year}'),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showWeightDialog(context, ref,
                                        existing: r);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete,
                                      color: Colors.red),
                                  title: const Text('Delete',
                                      style:
                                          TextStyle(color: Colors.red)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _confirmDeleteWeight(
                                        context, ref, r);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Text('Error loading weight records: $err'),
            ),

            const Divider(height: 32, thickness: 1),

            // ================================================================
            // 🐣 SECTION 4: BREEDING RECORDS
            // ================================================================
            _sectionHeader(
              title: 'Breeding History',
              icon: Icons.favorite,
              color: Colors.pink,
              onAdd: () => _showBreedingDialog(context, ref),
            ),
            ref.watch(watchBreedingRecordsProvider(goat.id!)).when(
              data: (records) {
                if (records.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No breeding events recorded yet.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final r = records[index];
                    final kidding = r.expectedKiddingDate;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.favorite,
                            color: Colors.pink),
                        title: Text(
                          'Mated ${r.matingDate.day}/${r.matingDate.month}/${r.matingDate.year}'
                          '${r.sireTagId != null ? " • Buck: ${r.sireTagId}" : ""}',
                        ),
                        subtitle: Text(
                          'Outcome: ${r.outcome}'
                          '${kidding != null ? "\nExpected Kidding: ${kidding.day}/${kidding.month}/${kidding.year}" : ""}'
                          '${r.numberOfKids != null ? "\nKids Born: ${r.numberOfKids}" : ""}'
                          '${r.notes != null ? "\n${r.notes}" : ""}',
                        ),
                        isThreeLine: true,
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showBreedingDialog(context, ref,
                                        existing: r);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete,
                                      color: Colors.red),
                                  title: const Text('Delete',
                                      style:
                                          TextStyle(color: Colors.red)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _confirmDeleteBreeding(
                                        context, ref, r);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Text('Error loading breeding records: $err'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
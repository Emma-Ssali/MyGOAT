import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/goat.dart';
import '../services/providers.dart';
import 'goat_detail_view.dart';

class GoatDashboardView extends ConsumerStatefulWidget {
  const GoatDashboardView({super.key});

  @override
  ConsumerState<GoatDashboardView> createState() => _GoatDashboardViewState();
}

class _GoatDashboardViewState extends ConsumerState<GoatDashboardView> {

  Future<void> _handleRefresh() async {
    ref.invalidate(watchGoatsProvider);
    await Future.delayed(const Duration(milliseconds: 800));
  }

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
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: Colors.green.shade700,
                  backgroundColor: Colors.white,
                  child: goatList.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Center(
                              child: Text(
                                'No livestock registered yet.\nPull down to refresh page layout.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: goatList.length,
                          itemBuilder: (context, index) {
                            final goat = goatList[index];
                            final formattedDob = "${goat.dateOfBirth.toLocal()}".split(' ')[0];

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                // TAP card → open GoatDetailView with all sections
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GoatDetailView(goat: goat),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green.shade100,
                                  backgroundImage: goat.photoPath != null
                                      ? FileImage(File(goat.photoPath!))
                                      : null,
                                  child: goat.photoPath == null
                                      ? Icon(Icons.gavel, color: Colors.green.shade800)
                                      : null,
                                ),
                                title: Text(
                                  goat.tagId.isEmpty ? 'UNTAGGED ANIMAL' : 'Tag ID: ${goat.tagId}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Breed: ${goat.breed} | ${goat.gender} | DoB: $formattedDob\nMass: ${goat.weight} kg | Status: ${goat.status}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // EDIT icon → open the edit modal only
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 20, color: Colors.green.shade700),
                                      onPressed: () => _showGoatModal(context, existingGoat: goat),
                                    ),
                                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoatModal(context),
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

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: const Text('Are you sure you want to permanently delete this animal from your registry ledger?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  void _showGoatModal(BuildContext context, {Goat? existingGoat}) {
    final isEditing = existingGoat != null;

    final tagController = TextEditingController(text: existingGoat?.tagId ?? '');
    final breedController = TextEditingController(text: existingGoat?.breed ?? '');
    final weightController = TextEditingController(
        text: existingGoat?.weight != null ? existingGoat!.weight.toString() : '');
    final acquisitionNoteController =
        TextEditingController(text: existingGoat?.acquisitionNote ?? '');

    String selectedGender = existingGoat?.gender ?? 'Male';
    String selectedStatus = existingGoat?.status ?? 'Active';
    String selectedAcquisitionSource = existingGoat?.acquisitionSource ?? 'Purchased';

    DateTime selectedBirthDate = existingGoat?.dateOfBirth ?? DateTime.now();
    DateTime selectedAcquisitionDate = existingGoat?.dateOfAcquisition ?? DateTime.now();

    final dobController = TextEditingController(
        text: "${selectedBirthDate.toLocal()}".split(' ')[0]);
    final acquisitionDateController = TextEditingController(
        text: "${selectedAcquisitionDate.toLocal()}".split(' ')[0]);

    File? selectedImage =
        existingGoat?.photoPath != null ? File(existingGoat!.photoPath!) : null;

    Future<void> pickImage(ImageSource source, StateSetter setModalState) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image =
          await picker.pickImage(source: source, imageQuality: 85);
      if (image != null) {
        setModalState(() {
          selectedImage = File(image.path);
        });
      }
    }

    void showImageSourceOptions(
        BuildContext context, StateSetter setModalState) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo with Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, setModalState);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose Photo from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery, setModalState);
                },
              ),
            ],
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isEditing ? 'Modify Goat Profile' : 'Register New Goat Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800),
                    ),
                    const SizedBox(height: 16),

                    // Photo picker
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            showImageSourceOptions(context, setModalState),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Colors.green.shade700, width: 2),
                            image: selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: selectedImage == null
                              ? Icon(Icons.add_a_photo,
                                  size: 32, color: Colors.green.shade700)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: tagController,
                      decoration: const InputDecoration(
                          labelText: 'Ear Tag ID Number',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: breedController,
                      decoration: const InputDecoration(
                          labelText: 'Breed (e.g., Boer, Savanna)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: const InputDecoration(
                          labelText: 'Sex', border: OutlineInputBorder()),
                      items: ['Male', 'Female']
                          .map((g) =>
                              DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedGender = val!),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                          labelText: 'Status', border: OutlineInputBorder()),
                      items: ['Active', 'Sold', 'Dead', 'Missing']
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedStatus = val!),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: dobController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedBirthDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setModalState(() {
                            selectedBirthDate = pickedDate;
                            dobController.text =
                                "${pickedDate.toLocal()}".split(' ')[0];
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: acquisitionDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Acquisition',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedAcquisitionDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setModalState(() {
                            selectedAcquisitionDate = pickedDate;
                            acquisitionDateController.text =
                                "${pickedDate.toLocal()}".split(' ')[0];
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedAcquisitionSource,
                      decoration: const InputDecoration(
                          labelText: 'Source of Acquisition',
                          border: OutlineInputBorder()),
                      items: ['Purchased', 'Born on Farm', 'Donated', 'Gift', 'Other']
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => selectedAcquisitionSource = val!),
                    ),
                    const SizedBox(height: 12),

                    if (selectedAcquisitionSource == 'Other') ...[
                      TextField(
                        controller: acquisitionNoteController,
                        decoration: const InputDecoration(
                          labelText: 'Please specify source',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 8),

                    Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            final tagText = tagController.text.trim();

                            if (tagText.isNotEmpty) {
                              final existing = await ref
                                  .read(farmRepositoryProvider)
                                  .findGoatByTag(tagText);
                              final isDuplicate = existing != null &&
                                  existing.id != existingGoat?.id;
                              if (isDuplicate && context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Duplicate Tag Number'),
                                    content: Text(
                                        'Tag "$tagText" is already assigned to another animal. Please use a different tag number.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK',
                                            style: TextStyle(
                                                color: Colors.green)),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                            }

                            final goatToSave =
                                isEditing ? existingGoat! : Goat();

                            goatToSave
                              ..tagId = tagText
                              ..breed = breedController.text.trim()
                              ..weight =
                                  double.tryParse(weightController.text) ?? 0.0
                              ..gender = selectedGender
                              ..status = selectedStatus
                              ..dateOfBirth = selectedBirthDate
                              ..dateOfAcquisition = selectedAcquisitionDate
                              ..acquisitionSource = selectedAcquisitionSource
                              ..acquisitionNote =
                                  selectedAcquisitionSource == 'Other'
                                      ? acquisitionNoteController.text.trim()
                                      : null
                              ..isTagged = tagText.isNotEmpty
                              ..createdAt =
                                  existingGoat?.createdAt ?? DateTime.now()
                              ..lastSyncedAt = DateTime.now().toUtc()
                              ..photoPath = selectedImage?.path ??
                                  existingGoat?.photoPath;

                            await ref
                                .read(farmRepositoryProvider)
                                .addOrUpdateGoat(goatToSave);

                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Text(
                            isEditing
                                ? 'Apply Changes to Profile'
                                : 'Save Data Profile to Herd Ledger',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),

                    if (isEditing) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          final confirmed =
                              await _showDeleteConfirmation(context);
                          if (confirmed == true && existingGoat.id != null) {
                            await ref
                                .read(farmRepositoryProvider)
                                .deleteGoat(existingGoat.id!);
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Livestock profile removed from ledger')),
                              );
                            }
                          }
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete Goat Profile',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
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
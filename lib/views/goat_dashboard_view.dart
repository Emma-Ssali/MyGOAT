import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mygoat/providers/database_provider.dart'; 
import 'package:mygoat/views/goat_detail_view.dart';

class GoatDashboardView extends ConsumerWidget {
  const GoatDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder list. Ensure this maps to your actual Goat state/models
    final List<dynamic> goatsList = []; 

    return Scaffold(
      appBar: AppBar(title: const Text('Goat Dashboard')),
      body: ListView.builder(
        itemCount: goatsList.length,
        itemBuilder: (context, index) {
          final goat = goatsList[index];
          return ListTile(
            title: Text('Tag ID: ${goat.tagId ?? "Unknown"}'),
            subtitle: Text('Breed: ${goat.breed ?? "Unknown"}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoatDetailView(goat: goat)),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (goat.id != null) {
                  ref.read(databaseServiceProvider).deleteGoat(goat.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot delete unsaved Goat')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
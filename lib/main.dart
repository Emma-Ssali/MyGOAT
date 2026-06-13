import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/goat_dashboard_view.dart';

void main() {
  runApp(
    // ProviderScope is the engine that keeps track of all your data streams
    const ProviderScope(
      child: MyGoatApp(),
    ),
  );
}

class MyGoatApp extends StatelessWidget {
  const MyGoatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGOAT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const GoatDashboardView(), // Automatically boots up straight into your live herd list
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/home_navigation_view.dart'; // Pointing to the new controller

void main() {
  runApp(
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
      title: 'My Goat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeNavigationView(), // This loads our bottom bar hub!
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/goat_dashboard_view.dart';
import 'views/financial_dashboard_view.dart';

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
      title: 'MyGOAT Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Crucial fix: Loading the Navigation Shell instead of just the single Herd screen
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // The view panels our navigation items switch between
  final List<Widget> _screens = [
    const GoatDashboardView(),
    const FinancialDashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.gavel), 
            label: 'Herd',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet), 
            label: 'Finances',
          ),
        ],
      ),
    );
  }
}
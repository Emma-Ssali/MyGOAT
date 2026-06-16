import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/goat_dashboard_view.dart';
import 'views/financial_dashboard_view.dart';
import 'services/database_service.dart'; // NEW: so we can call DatabaseService()
import 'services/providers.dart';        // NEW: so we can override databaseServiceProvider

// CHANGED: added 'async' so we can use 'await' inside main
void main() async {
  
  // NEW: must be called before any async work when using Flutter plugins
  WidgetsFlutterBinding.ensureInitialized();

  // NEW: create the database and fully open it BEFORE the app starts
  final dbService = DatabaseService();
  await dbService.init();

  // CHANGED: removed 'const' (can't use const with dynamic overrides)
  // CHANGED: added overrides to inject our ready database into the provider system
  runApp(
    ProviderScope(
      overrides: [
        databaseServiceProvider.overrideWithValue(dbService),
      ],
      child: const MyGoatApp(),
    ),
  );
}

// Everything below this line is UNCHANGED
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
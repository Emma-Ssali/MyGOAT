import 'package:flutter/material.dart';
import 'goat_dashboard_view.dart';
import 'financial_dashboard_view.dart';

class HomeNavigationView extends StatefulWidget {
  const HomeNavigationView({super.key});

  @override
  State<HomeNavigationView> createState() => _HomeNavigationViewState();
}

class _HomeNavigationViewState extends State<HomeNavigationView> {
  int _currentIndex = 0;

  // This holds our two actual dashboard screens in order
  final List<Widget> _screens = [
    const GoatDashboardView(),       // Tab 0
    const FinancialDashboardView(),  // Tab 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Herd Ledger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}
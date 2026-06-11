// 1. IMPORTS LAYER
// This brings in Google's pre-made visual blocks (widgets) called Material Design.
// It gives us access to elements like Cards, Icons, text styles, and layout builders.
import 'package:flutter/material.dart';

// 2. ENTRY POINT
// The main() function is the absolute starting trigger of the entire application.
// When your phone boots up the app, it runs this function first.
// 'runApp' tells the device to inflate and draw our root widget ('MyGoatApp') on the screen.
void main() {
  runApp(const MyGoatApp());
}

// 3. THE APPLICATION ROOT LAYER
// MyGoatApp is a 'StatelessWidget'. This means its overall configurations 
// (like the app's overall name or color theme) don't dynamically shift while running.
class MyGoatApp extends StatelessWidget {
  const MyGoatApp({super.key});

  @override
  Widget build(BuildContext WidgetContext) {
    // MaterialApp acts as the manager for the whole app. It sets up foundational settings 
    // like the title bar text, removes the "Debug" banner, and defines global colors.
    return MaterialApp(
      title: 'MY GOAT APP',
      debugShowCheckedModeBanner: false, // Hides the red development banner on the top-right
      theme: ThemeData(
        // Seed color dynamically builds matching shades of teal for cards, borders, and accents
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true, // Activates Google's latest modern UI rendering standards
      ),
      // This tells the app which screen to display immediately when it opens.
      home: const FarmDashboard(), 
    );
  }
}

// 4. THE HOME SCREEN INITIALIZATION
// FarmDashboard is a 'StatefulWidget'. This means this specific screen *will* hold 
// data that changes dynamically later (e.g., goat numbers updating, lists expanding).
class FarmDashboard extends StatefulWidget {
  const FarmDashboard({super.key});

  // Stateful widgets use a twin class (the State class below) to hold and manage changing data.
  @override
  State<FarmDashboard> createState() => _FarmDashboardState();
}

// 5. THE VISUAL LAYOUT & DESIGN LAYER
// This is where the actual code architecture of your dashboard grid lives.
class _FarmDashboardState extends State<FarmDashboard> {
  @override
  Widget build(BuildContext context) {
    // Scaffold provides a blank, standardized material canvas with space 
    // for a top title bar, background color controls, and body spacing blocks.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🐐 MY GOAT APP',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal, // Sets the top header background to your deep farm teal
        centerTitle: true, // Locks your app title right in the middle of the screen
      ),
      // SingleChildScrollView ensures that if you view this on a small phone screen, 
      // the user can scroll up and down instead of the text crashing or cutting off.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Adds a clean 16-pixel breathing room around the edges
        // Column stacks your interface widgets one by one from top to bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns all content cleanly to the left edge
          children: [
            // Welcome Header Text
            const Text(
              'Farm Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Acts as an invisible spacer pushing the next item down 16 pixels

            // SECTION A: QUICK STATS ROW
            // 'Row' positions visual containers horizontally side-by-side.
            Row(
              children: [
                // 'Expanded' forces the cards to perfectly stretch and share the horizontal space 50/50
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Goats',
                    value: '0',
                    icon: Icons.pets, // Dog/Animal paw print icon
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(width: 12), // Spacer between the left and right card
                Expanded(
                  child: _buildStatCard(
                    title: 'Tagged',
                    value: '0',
                    icon: Icons.bookmark, // Ribbon/Tag sticker icon
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // SECTION B: FINANCIAL QUICK VIEW CARD
            // 'Card' creates an elevated, shadowed surface container that stands out beautifully.
            Card(
              elevation: 2, // Controls how dramatic the shadow drop under the card container is
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Smooths the card edges
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Spaces out text inside the box away from its borders
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Financial Summary (UGX)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20), // Draws a clean horizontal gray line to split sections
                    // Side-by-side presentation of metrics
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes Incomes to left, Expenses to right
                      children: [
                        _buildFinancialIndicator('Incomes', '0 /=', Colors.green),
                        _buildFinancialIndicator('Expenses', '0 /=', Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION C: NAVIGATION INTERACTION OPTIONS
            const Text(
              'Management Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Reusable navigation buttons created below
            _buildActionButton(
              label: 'Manage Herd & Breeds',
              icon: Icons.list_alt, // Document list sheet icon
              onPressed: () {
                // Future Step: This empty function block is where we code screen transitions!
              },
            ),
            _buildActionButton(
              label: 'Record Income / Expense',
              icon: Icons.account_balance_wallet, // Wallet icon
              onPressed: () {
                // Future Step: This empty function block is where we code the record sheet overlay!
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 6. MODULAR COMPONENT BUILDERS (REUSABILITY)
  // Instead of copy-pasting code lines repeatedly, we create custom macro-builders below.
  // ==========================================

  // Macro 1: Creates individual statistic status boxes cleanly
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      color: color, // Dynamically applies the specific card background shade passed above
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Macro 2: Formats the separate colored cash trackers (UGX display rows)
  Widget _buildFinancialIndicator(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Macro 3: Constructs the clickable action rows spanning across the bottom of the dashboard
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity, // Tells the button to stretch perfectly matching the width of the phone screen
        height: 56, // Fixed vertical thickness for optimal finger tapping size
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade50, // Subtle light teal button color tint
            foregroundColor: Colors.teal.shade900, // Very dark teal text color for high visual reading contrast
            alignment: Alignment.centerLeft, // Left-aligns the icon text combo like an institutional list menu
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onPressed, // The link mapping what logic fires when clicked
          icon: Icon(icon),
          label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
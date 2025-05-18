import 'package:flutter/material.dart';
import '../pages/history_page.dart';
import '../pages/setup_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Color.fromARGB(255, 105, 50, 201)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Taboo Game',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuButton(context, 'Start Game', Icons.play_arrow, () {
                // Will be implemented by other team
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Game starting soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetupPage()),
                );
              }),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Instructions',
                Icons.help_outline,
                () => _showInstructionsDialog(context),
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'View History',
                Icons.history,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontSize: 18)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('How to Play', textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '1. Split into two teams\n'
                    '2. One player gives clues to help their team guess the main word\n'
                    '3. Avoid using any of the forbidden "taboo" words\n'
                    '4. Each correct guess = +1 point\n'
                    '5. Using a taboo word = -1 point\n'
                    '6. The team with most points after all rounds wins!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Have fun!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got It!'),
                ),
              ),
            ],
          ),
    );
  }
}

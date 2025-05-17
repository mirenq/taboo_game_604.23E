import 'package:flutter/material.dart';
import '../models/word_card.dart';
import '../widgets/word_card_widget.dart';

class GamePage extends StatelessWidget {
  final List<String> teamA;
  final List<String> teamB;
  final int totalRounds;

  const GamePage({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    final currentRound = 1; // Placeholder
    final isTeamATurn = true;
    final roundScore = 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Taboo Game')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Color.fromARGB(255, 105, 50, 201)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //  Round number and team indicator
            Column(
              children: [
                Text(
                  'Round $currentRound / $totalRounds',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  isTeamATurn ? 'Team A\'s Turn' : 'Team B\'s Turn',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),

            const WordCardWidget(),

            // Next / Skip, Correct, Taboo buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Skip')),
                ElevatedButton(onPressed: () {}, child: const Text('Correct')),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Taboo'),
                ),
              ],
            ),

            Text(
              'Score: $roundScore',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

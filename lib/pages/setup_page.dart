import 'package:flutter/material.dart';
import 'game_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController _nameController = TextEditingController();
  List<String> teamA = [];
  List<String> teamB = [];
  String selectedTeam = 'A';
  int roundCount = 3;

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        if (selectedTeam == 'A') {
          teamA.add(name);
        } else {
          teamB.add(name);
        }
        _nameController.clear();
      });
    }
  }

  void _startGame() {
    if (teamA.isNotEmpty && teamB.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  GamePage(teamA: teamA, teamB: teamB, totalRounds: roundCount),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add players to both teams.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Game')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Color.fromARGB(255, 105, 50, 201)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Add Players',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Player Name',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              'Team:',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedTeam,
                              dropdownColor: Colors.deepPurple[300],
                              items:
                                  ['A', 'B'].map((team) {
                                    return DropdownMenuItem(
                                      value: team,
                                      child: Text(
                                        'Team $team',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => selectedTeam = value!),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                              onPressed: _addPlayer,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildTeamList('Team A', teamA),
                        const SizedBox(height: 12),
                        _buildTeamList('Team B', teamB),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Rounds:',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            DropdownButton<int>(
                              value: roundCount,
                              dropdownColor: Colors.deepPurple[300],
                              items:
                                  [1, 3, 5, 7].map((n) {
                                    return DropdownMenuItem(
                                      value: n,
                                      child: Text(
                                        '$n',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged:
                                  (value) =>
                                      setState(() => roundCount = value!),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow),
                            label: const Text(
                              'Start Game',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: _startGame,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTeamList(String teamName, List<String> players) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$teamName (${players.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (players.isEmpty)
            const Text(
              'No players yet',
              style: TextStyle(color: Colors.white70),
            )
          else
            ...players.map(
              (name) =>
                  Text('• $name', style: const TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

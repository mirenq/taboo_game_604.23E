import 'package:flutter/material.dart';
import 'game_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teamANameController = TextEditingController();
  final TextEditingController _teamBNameController = TextEditingController();
  List<String> teamA = [];
  List<String> teamB = [];
  String selectedTeam = 'A';
  int roundCount = 3;
  String teamAName = 'Team A';
  String teamBName = 'Team B';
  bool teamNamesConfirmed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _teamANameController.dispose();
    _teamBNameController.dispose();
    super.dispose();
  }

  void _confirmTeamNames() {
    final nameA = _teamANameController.text.trim();
    final nameB = _teamBNameController.text.trim();

    if (nameA.isNotEmpty && nameB.isNotEmpty) {
      setState(() {
        teamAName = nameA;
        teamBName = nameB;
        teamNamesConfirmed = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter names for both teams.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
              (context) => GamePage(
                teamA: teamA,
                teamB: teamB,
                totalRounds: roundCount,
                teamAName: teamAName,
                teamBName: teamBName,
              ),
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
      appBar: AppBar(title: const Text('Game Setup'), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Color.fromARGB(255, 105, 50, 201)],
          ),
        ),
        child: teamNamesConfirmed ? _buildPlayerSetup() : _buildTeamNameSetup(),
      ),
    );
  }

  Widget _buildTeamNameSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Enter Team Names',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _teamANameController,
          decoration: InputDecoration(
            labelText: 'Team A Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _teamBNameController,
          decoration: InputDecoration(
            labelText: 'Team B Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _confirmTeamNames,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Confirm Team Names',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Player addition section
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Players',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Player Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedTeam,
                      onChanged: (value) {
                        setState(() {
                          selectedTeam = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(value: 'A', child: Text(teamAName)),
                        DropdownMenuItem(value: 'B', child: Text(teamBName)),
                      ],
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      color: Colors.blue,
                      onPressed: _addPlayer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Team display section
        Expanded(
          child: Row(
            children: [
              // Team A
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          teamAName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamA.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(teamA[index]),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    teamA.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Team B
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          teamBName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teamB.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(teamB[index]),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    teamB.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Round selection
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Rounds:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: roundCount,
                  onChanged: (value) {
                    setState(() {
                      roundCount = value!;
                    });
                  },
                  items: List.generate(
                    5,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Start game button
        ElevatedButton(
          onPressed: _startGame,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Start Game', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/word_card_widget.dart';
//import '../services/local_storage_service.dart';
import '../widgets/score_model.dart';

class GamePage extends StatefulWidget {
  final List<String> teamA;
  final List<String> teamB;
  final int totalRounds;
  final String teamAName;
  final String teamBName;

  const GamePage({
    super.key,
    required this.teamA,
    required this.teamB,
    required this.totalRounds,
    this.teamAName = 'Team A',
    this.teamBName = 'Team B',
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentRound = 1;
  bool isTeamATurn = true;
  int roundScore = 0;
  int teamAScore = 0;
  int teamBScore = 0;
  int currentPlayerIndex = 0;
  //final WordCardWidget wordCardWidget = const WordCardWidget();
  final GlobalKey<WordCardWidgetState> _wordCardKey = GlobalKey<WordCardWidgetState>();
  
  List<String> get currentTeam => isTeamATurn ? widget.teamA : widget.teamB;
  String get currentPlayer => currentTeam[currentPlayerIndex];
  
  @override
  void initState() {
    super.initState();
    // Initialize with the first player of Team A
    currentPlayerIndex = 0;
  }


  void _skipCard() {
    // Skip current card
    if (_wordCardKey.currentState != null) {
      _wordCardKey.currentState!.nextCard();
    }
  }

  void _correctAnswer() {
    // Handle correct answer
    setState(() {
      roundScore++;

      if (isTeamATurn) {
        teamAScore++;
      } else {
        teamBScore++;
      }
    });

    if (_wordCardKey.currentState != null) {
      _wordCardKey.currentState!.nextCard();
    }
  }

  void _tabooViolation() {
    // Handle taboo violation
    setState(() {
      roundScore--;

      if (isTeamATurn) {
        teamAScore--;
      } else {
        teamBScore--;
      }
    });

    if (_wordCardKey.currentState != null) {
      _wordCardKey.currentState!.nextCard();
    }
  }

  void _handleTimeUp() {
    // Move to the next player when time runs out
    setState(() {
      // Move to next player
      currentPlayerIndex++;
      
      // If we've gone through all players in the current team
      if (currentPlayerIndex >= currentTeam.length) {
        currentPlayerIndex = 0;
        // Switch teams
        isTeamATurn = !isTeamATurn;
        
        // If we've gone through both teams, increment the round
        if (isTeamATurn) {
          // Only increment round when switching from Team B to Team A
          currentRound++;
          
          // Check if we've completed all rounds
          if (currentRound > widget.totalRounds) {
            // Game over - show final results
            _showFinalResults();
            return;
          }
        }
      }
      
      // Show the team change notification
      _showTeamChangeDialog();
      
      // Reset score for the new player
      roundScore = 0;
    });
    
    // Reset the timer for the new player's turn
    if (_wordCardKey.currentState != null) {
      _wordCardKey.currentState!.resetTimer();
    }
  }

  void _showTeamChangeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${isTeamATurn ? widget.teamAName : widget.teamBName}\'s Turn'),
          content: Text('It\'s $currentPlayer\'s turn to play!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalResults() {
  // Create a RoundResults object with the final scores
    final result = RoundResults(
      teamA: widget.teamAName,
      teamB: widget.teamBName,
      scoreA: teamAScore,
      scoreB: teamBScore,
      round: widget.totalRounds
    );
  
  // Show the final score dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Final Scores after ${widget.totalRounds} rounds:'),
              const SizedBox(height: 16),
              Text('${widget.teamAName}: $teamAScore points'),
              Text('${widget.teamBName}: $teamBScore points'),
              const SizedBox(height: 16),
              Text(
                teamAScore > teamBScore 
                  ? '${widget.teamAName} wins!' 
                  : teamBScore > teamAScore 
                    ? '${widget.teamBName} wins!' 
                    : 'It\'s a tie!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate back to home page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Return to Home'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Round number and team indicator
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Text(
                    'Round $currentRound / ${widget.totalRounds}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isTeamATurn ? '${widget.teamAName}\'s Turn' : '${widget.teamBName}\'s Turn',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // The WordCardWidget takes most of the screen
            Expanded(
              child: Center(child: WordCardWidget(key: _wordCardKey, onTimeUp: _handleTimeUp,)),
            ),

            // Next / Skip, Correct, Taboo buttons
            Column(
              children: [
                Text(
                  'Score: $roundScore',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _skipCard,
                      child: const Text('Skip'),
                    ),
                    ElevatedButton(
                      onPressed: _correctAnswer,
                      child: const Text('Correct'),
                    ),
                    ElevatedButton(
                      onPressed: _tabooViolation,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Taboo'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

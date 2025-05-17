// widgets/score_modal.dart

import 'package:flutter/material.dart';

class RoundResults {
  final int? id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final int round;

  const RoundResults({
    this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.round,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'round': round,
    };
  }

  factory RoundResults.fromMap(Map<String, dynamic> map) {
    return RoundResults(
      id: map['id'],
      teamA: map['teamA'],
      teamB: map['teamB'],
      scoreA: map['scoreA'],
      scoreB: map['scoreB'],
      round: map['round'],
    );
  }

  @override
  String toString() {
    return 'Match{id: $id, teamA: $teamA, teamB: $teamB, scoreA: $scoreA, scoreB: $scoreB, round: $round}';
  }
}

class ScoreModal extends StatelessWidget {
  final RoundResults round;
  final VoidCallback? onNextRound;

  const ScoreModal({super.key, required this.round, required this.onNextRound});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Round ${round.round} Summary'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${round.teamA}: ${round.scoreA} points'),
          SizedBox(height: 8),
          Text('${round.teamB}: ${round.scoreB} points'),
        ],
      ),
      actions: [TextButton(onPressed: onNextRound, child: Text('Next Round'))],
    );
  }
}

//To use this class:
/*
showDialog(
  context: context,
  builder: (context) => ScoreModal(
    teamAScore: 5,
    teamBScore: 3,
    round: 2,
    onNextRound: () {
      Navigator.of(context).pop();
      // logic to go to the next round
    },
  ),
);
*/

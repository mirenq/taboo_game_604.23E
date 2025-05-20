import 'package:flutter/material.dart';

class RoundResults {
  final int? id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final int round;
  final DateTime timestamp;

  const RoundResults({
    this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.round,
    required this.timestamp,
  });

  String get winner {
    if (scoreA > scoreB) {
      return teamA;
    } else if (scoreB > scoreA) {
      return teamB;
    } else {
      return "Tie";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'round': round,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  static RoundResults fromMap(Map<String, dynamic> map) {
    //print('Converting map to RoundResults: $map');
    return RoundResults(
      id: map['id'],
      teamA: map['teamA'] ?? 'Unknown',
      teamB: map['teamB'] ?? 'Unknown',
      scoreA: map['scoreA'] ?? 0,
      scoreB: map['scoreB'] ?? 0,
      round: map['round'] ?? 0,
      timestamp: map['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp']) 
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Match{id: $id, teamA: $teamA, teamB: $teamB, scoreA: $scoreA, scoreB: $scoreB, round: $round, timestamp: $timestamp}';
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

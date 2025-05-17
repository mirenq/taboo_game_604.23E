// widgets/score_modal.dart

import 'package:flutter/material.dart';

class ScoreModal extends StatelessWidget {
  final int teamAScore;
  final int teamBScore;
  final int round;
  final VoidCallback onNextRound;

  const ScoreModal({
    Key? key,
    required this.teamAScore,
    required this.teamBScore,
    required this.round,
    required this.onNextRound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Round $round Summary'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Team A: $teamAScore points'),
          SizedBox(height: 8),
          Text('Team B: $teamBScore points'),
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

import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String mainWord;
  final List<String> forbiddenWords;

  const WordCard({
    super.key,
    required this.mainWord,
    required this.forbiddenWords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Main Word',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          color: Colors.purple[100],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Text(
              mainWord,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Text(
          'Forbidden Words',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...forbiddenWords.map(
          (word) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text('• $word', style: const TextStyle(fontSize: 24)),
          ),
        ),
      ],
    );
  }
}

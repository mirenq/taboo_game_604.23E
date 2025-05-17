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
      children: [
        Text(
          'Main Word',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Card(
          color: Colors.purple[100],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              mainWord,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Text(
          'Forbidden Words',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...forbiddenWords.map(
          (word) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('• $word', style: const TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}

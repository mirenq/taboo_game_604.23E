import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/word_card.dart';

class TabooCard {
  final String mainWord;
  final List<String> forbiddenWords;

  TabooCard({required this.mainWord, required this.forbiddenWords});
}

class WordCardWidget extends StatefulWidget {
  const WordCardWidget({super.key});

  @override
  _WordCardWidgetState createState() => _WordCardWidgetState();
}

class _WordCardWidgetState extends State<WordCardWidget> {
  final List<TabooCard> cards = [
    TabooCard(
      mainWord: 'Apple',
      forbiddenWords: ['Fruit', 'Red', 'iPhone', 'Tree', 'Juice'],
    ),
    TabooCard(
      mainWord: 'Sun',
      forbiddenWords: ['Hot', 'Sky', 'Day', 'Shine', 'Yellow'],
    ),
    TabooCard(
      mainWord: 'Football',
      forbiddenWords: ['Goal', 'Ball', 'Kick', 'Team', 'Sport'],
    ),
    TabooCard(
      mainWord: 'Computer',
      forbiddenWords: ['Keyboard', 'Screen', 'Mouse', 'Laptop', 'Technology'],
    ),
    TabooCard(
      mainWord: 'Dinosaur',
      forbiddenWords: ['Big', 'Animal', 'Extinct', 'Long Ago', 'Reptile'],
    ),
    TabooCard(
      mainWord: 'Penguin',
      forbiddenWords: ['Bird', 'Fly', 'Animal', 'Black', 'White'],
    ),
    TabooCard(
      mainWord: 'Internet',
      forbiddenWords: ['Computer', 'Web', 'Surf', 'Net', 'Technology'],
    ),
    TabooCard(
      mainWord: 'Ice Cream',
      forbiddenWords: ['Cold', 'Summer', 'Sweet', 'Snack', 'Cone'],
    ),
    TabooCard(
      mainWord: 'Midterm',
      forbiddenWords: ['Test', 'Exam', 'Half', 'Final', 'School'],
    ),
  ];

  int currentIndex = 0;
  int timeLeft = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void _nextCard() {
    setState(() {
      currentIndex = Random().nextInt(cards.length);
      timeLeft = 60;
    });
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taboo Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                '⏱ $timeLeft s',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WordCard(
                mainWord: currentCard.mainWord,
                forbiddenWords: currentCard.forbiddenWords,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _nextCard,
                icon: const Icon(Icons.skip_next),
                label: const Text('Next Card'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

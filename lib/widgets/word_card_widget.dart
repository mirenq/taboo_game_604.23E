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
  final Function()? onSkip;
  final Function()? onTimeUp;

  const WordCardWidget({super.key, this.onSkip, this.onTimeUp});

  @override
  WordCardWidgetState createState() => WordCardWidgetState();
}

class WordCardWidgetState extends State<WordCardWidget> {
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
  int timeLeft = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void resetTimer() {
    setState(() {
      timeLeft = 10;
    });
    startTimer();
  }

  void nextCard() {
    setState(() {
      currentIndex = Random().nextInt(cards.length);
    });
    startTimer();

    if (widget.onSkip != null) {
      widget.onSkip!();
    }
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

        if (widget.onTimeUp != null) {
          widget.onTimeUp!();
        }
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Word Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '⏱ $timeLeft s',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: WordCard(
              mainWord: currentCard.mainWord,
              forbiddenWords: currentCard.forbiddenWords,
            ),
          ),
        ],
      ),
    );
  }
}

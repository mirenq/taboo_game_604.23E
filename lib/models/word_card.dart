import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import '../widgets/word_card_widget.dart';

void main() {
  runApp(TabooGameApp());
}

class TabooGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taboo Game',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: TabooHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TabooCard {
  final String mainWord;
  final List<String> forbiddenWords;

  TabooCard({required this.mainWord, required this.forbiddenWords});
}

class TabooHomePage extends StatefulWidget {
  @override
  _TabooHomePageState createState() => _TabooHomePageState();
}

class _TabooHomePageState extends State<TabooHomePage> {
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
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
        title: Text('Taboo Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                '⏱ $timeLeft s',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              WordCardWidget(
                mainWord: currentCard.mainWord,
                forbiddenWords: currentCard.forbiddenWords,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _nextCard,
                icon: Icon(Icons.skip_next),
                label: Text('Next Card'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

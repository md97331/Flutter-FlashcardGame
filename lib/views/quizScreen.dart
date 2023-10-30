import 'package:flutter/material.dart';
import '../models/decks_cards.dart';
import '../utils/dbhelper.dart';

class QuizScreen extends StatefulWidget {
  final Deck deck;

  QuizScreen({required this.deck});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Fcards> shuffledFlashcards = [];
  int currentIndex = 0;
  bool showAnswer = false;
  int peekedCards = 0;
  List<bool> peekedCardsList = [];
  Set<int> uniqueCardSeen = {};

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    final db = DBHelper();
    final flashcards =
        await db.query('fcards', where: 'decks_id = ${widget.deck.id}');

    setState(() {
      shuffledFlashcards = flashcards.map((flashcard) {
        return Fcards(
          id: flashcard['id'],
          decksId: flashcard['decks_id'],
          description: flashcard['description'],
          answer: flashcard['answer'],
          addTime: flashcard['add_time'],
        );
      }).toList()
        ..shuffle();

      peekedCardsList =
          List.generate(shuffledFlashcards.length, (index) => false);
    });
  }

  void goToCard(int step) {
    setState(() {
      if (shuffledFlashcards.isEmpty) {
        return;
      }
      int newIndex = currentIndex + step;
      if(newIndex<0){
        newIndex = shuffledFlashcards.length+newIndex;
      }
      if (newIndex >= shuffledFlashcards.length) {
        newIndex = newIndex % shuffledFlashcards.length;
      }
      currentIndex = newIndex;
      showAnswer = false;
      uniqueCardSeen.add(currentIndex);
      updateStats();
    });
  }

  void flipCard() {
    setState(() {
      showAnswer = !showAnswer;
      if (!peekedCardsList[currentIndex]) {
        peekedCardsList[currentIndex] = true;
        peekedCards++;
      }
      updateStats();
    });
  }

  void updateStats() {
    int uniqueCards = uniqueCardSeen.length;
    int totalCards = shuffledFlashcards.length;
    setState(() {
      // Only update the stats without changing currentIndex
      uniqueCards = uniqueCardSeen.length;
      totalCards = shuffledFlashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shuffledFlashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Mode - No flashcards available'),
        ),
        body: Center(
          child: Text('No flashcards available in this deck.'),
        ),
      );
    }

    final flashcard = shuffledFlashcards[currentIndex];
    final question = flashcard.description;
    final answer = flashcard.answer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.deck.name} - $currentIndex of ${shuffledFlashcards.length} cards'),
        backgroundColor: Color.fromARGB(255, 158, 153, 182),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.75,
              child: Card(
                color: peekedCardsList[currentIndex]
                    ? Color.fromARGB(199, 148, 172, 200)
                    : Color.fromARGB(255, 158, 153, 182),
                child: Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          // Handle tapping the flashcard
                        },
                      ),
                      Center(
                        child: Text(
                          showAnswer ? answer : question,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => goToCard(-1),
                  icon: Icon(Icons.arrow_left),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: flipCard,
                  icon: Icon(Icons.copy),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () => goToCard(1),
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Seen ${uniqueCardSeen.length} of ${shuffledFlashcards.length} cards',
              style: TextStyle(fontSize: 10),
            ),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
              'Peeked at $peekedCards of ${uniqueCardSeen.length} answers',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

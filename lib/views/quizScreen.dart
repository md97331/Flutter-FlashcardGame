import 'package:flutter/material.dart';
import '../models/decks_cards.dart';
import '../utils/dbhelper.dart';

class QuizScreen extends StatefulWidget {
  final Deck deck;

  const QuizScreen({super.key, required this.deck});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
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
    setState(() {
      // Only update the stats without changing currentIndex
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shuffledFlashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Mode - No flashcards available'),
        ),
        body: const Center(
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
        backgroundColor: const Color.fromARGB(255, 158, 153, 182),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.75;
            final cardHeight = constraints.maxHeight*0.55; // Maximum card height

           

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: Card(
                    color: peekedCardsList[currentIndex]
                        ? const Color.fromARGB(199, 148, 172, 200)
                        : const Color.fromARGB(255, 158, 153, 182),
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
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
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => goToCard(-1),
                      icon: const Icon(Icons.arrow_left),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: flipCard,
                      icon: const Icon(Icons.copy),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => goToCard(1),
                      icon: const Icon(Icons.arrow_right),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Seen ${uniqueCardSeen.length} of ${shuffledFlashcards.length} cards',
                  style: const TextStyle(fontSize: 10),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Text(
                  'Peeked at $peekedCards of ${uniqueCardSeen.length} answers',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mp3/models/decks_cards.dart';
import 'package:provider/provider.dart';
import '../utils/dbhelper.dart';

class CardListTest extends StatelessWidget {
  const CardListTest({Key? key}) : super(key: key);

  Future<List<Flashcard>> _loadFlashcards() async {
    final data = await DatabaseProvider().query('flashcards');
    return data
        .map((e) => Flashcard(
            id: e['id'] as int,
            question: e['question'] as String,
            answer: e['answer'] as String))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureProvider<List<Flashcard>?>(
          create: (_) => _loadFlashcards(),
          initialData: null,
          child: const FlashCardList()),
    );
  }
}

class FlashCardList extends StatefulWidget {
  const FlashCardList({Key? key}) : super(key: key);

  @override
  State<FlashCardList> createState() => _FlashCardListState();
}

class _FlashCardListState extends State<FlashCardList> {
  @override
  Widget build(BuildContext context) {
    final flashcards = Provider.of<List<Flashcard>?>(context);

    if (flashcards == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(4),
        children: List.generate(3, (index) => 
          Card(
            color: Colors.purple[100],
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  InkWell(onTap: () {
                    print('Flashcard ${index + 1} tapped');
                  }),
                  Center(child: Text('Deck ${index + 1}')),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        print('FlashCard ${index + 1} edited');
                      },
                    ),
                  ),
                ],
              )
            )
          )
        )
      )
    );
  }
}

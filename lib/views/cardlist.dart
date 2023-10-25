import 'package:flutter/material.dart';
import 'package:mp3/models/decks_cards.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import '../utils/dbhelper.dart';

class CardList extends StatefulWidget {
  final int deckId;

  CardList({Key? key, required this.deckId}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late Future<List<Map<String, dynamic>>> flashcards;

  @override
  void initState() {
    FutureProvider<List<Map<String, dynamic>>>(
      create: (_) => _loadFlashcards(),
    );
    super.initState();
    (_) = _loadFlashcards();
  }

  Future<List<Flashcard>> _loadFlashcards() async {
    final data = await DatabaseProvider().query('flashcards');
    return data.map((e) => Flashcard(id: e['id'] as int, question: e['question'] as String, answer: e['answer'] as String)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards for Deck ${widget.deckId}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: flashcards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final flashcardList = snapshot.data!;

            if (flashcardList.isEmpty) {
              return Center(child: Text('No flashcards available.'));
            }

            return ListView.builder(
              itemCount: flashcardList.length,
              itemBuilder: (context, index) {
                final flashcard = flashcardList[index];
                return FlashcardItem(flashcard);
              },
            );
          }
        },
      ),
    );
  }
}

class FlashcardItem extends StatelessWidget {
  final Map<String, dynamic> flashcard;

  FlashcardItem(this.flashcard);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(flashcard['question']),
      subtitle: Text(flashcard['answer']),
      // Add Edit and Delete actions here
    );
  }
}

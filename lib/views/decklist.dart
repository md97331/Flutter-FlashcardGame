import 'package:flutter/material.dart';
import 'package:mp3/models/decks_cards.dart';
import 'package:mp3/views/cardlist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../utils/dbhelper.dart'; // Import your DatabaseProvider

class DeckList extends StatefulWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  late Future<List<Map<String, dynamic>>> decks;

  @override
  void initState() {
    super.initState();
    (_) = _loadDecks();
  
  }

  Future<List<Deck>> _loadDecks() async {
    final data = await DatabaseProvider().query('decks');
    return data.map((e) => Deck(id: e['id'] as int, title: e['title'] as String, flashcards: e['flashcards'] as List<Flashcard>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: decks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final deckList = snapshot.data!;

            if (deckList.isEmpty) {
              return Center(child: Text('No decks available.'));
            }

            return ListView.builder(
              itemCount: deckList.length,
              itemBuilder: (context, index) {
                final deck = deckList[index];
                return ListTile(
                  title: Text(deck['title']),
                  onTap: () {
                    // Navigate to the card list for the selected deck
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CardList(deckId: deck['id']),
                    ));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

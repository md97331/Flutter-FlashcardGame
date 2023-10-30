import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/decks_cards.dart';
import '../utils/dbhelper.dart';
import '../views/addDeck.dart';
import '../views/addFlashcard.dart';
import '../views/editDeck.dart';
import '../views/editFlashcard.dart';

class DeckListG extends StatelessWidget {
  const DeckListG({super.key});

  Future<List<Deck>> _loadData() async {
    final data = await DBHelper().query('decks');
    return data
        .map((e) => Deck(
              id: e['id'] as int,
              name: e['name'] as String,
              description: e['description'] as String,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureProvider<List<Deck>?>(
          create: (_) => _loadData(),
          initialData: null,
          child: const DeckList()),
    );
  }
}

class DeckList extends StatefulWidget {
  const DeckList({super.key});

  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  @override
  Widget build(BuildContext context) {
    final listOfDecks = Provider.of<List<Deck>?>(context);

    void addDeck(Deck deck) {
      setState(() {
        listOfDecks?.add(deck);
      });
    }

    if (listOfDecks == null) {
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
        children: List.generate(
          listOfDecks.length,
          (index) {
            final deck = listOfDecks[index];
            return Card(
              color: Colors.purple[100],
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FcardsList(deck: deck);
                            },
                          ),
                        );
                        // Here, you can navigate to the flashcards screen or perform other actions.
                      },
                    ),
                    Center(child: Text(deck.name)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditDeck(
                                  deck: deck,
                                  updateDeckList: (editedDeck) {
                                    setState(() {
                                      // Update the deck list with the edited deck
                                      listOfDecks[listOfDecks.indexWhere(
                                              (d) => d.id == editedDeck.id)] =
                                          editedDeck;
                                    });
                                    editedDeck.dbUpdate();
                                  },
                                  deleteDeck: (deletedDeck) {
                                    setState(() {
                                      // Delete the deck from the deck list
                                      listOfDecks.removeWhere(
                                          (d) => d.id == deletedDeck.id);
                                    });
                                    deletedDeck.dbDelete();
                                  },
                                );
                              },
                            ),
                          );

                          // Here, you can handle the edit action.
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) {
                return AddDeckScreen(
                  addDeckCallback: addDeck, // Pass the callback function
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FcardsList extends StatefulWidget {
  final Deck deck;
  const FcardsList({required this.deck, super.key});

  @override
  State<FcardsList> createState() => _FcardsListState();
}

class _FcardsListState extends State<FcardsList> {
  late Future<List<Fcards>> _fcards;
  bool isSortedAlphabetically = false;

  Future<List<Fcards>> _loadData() async {
    final data = await DBHelper()
        .query('fcards', where: 'decks_id = ${widget.deck.id!}');
    return data
        .map((e) => Fcards(
              id: e['id'] as int,
              decksId: e['decks_id'] as int,
              description: e['description'] as String,
              answer: e['answer'] as String,
              addTime: e['add_time'] as int,
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fcards = _loadData();
  }

  List<Fcards> fcards = [];

  List<Fcards> sortFlashcards(List<Fcards> flashcards) {
    flashcards.sort((a, b) {
      if (isSortedAlphabetically) {
        int nameComparison = a.description.compareTo(b.description);
        if (nameComparison != 0) {
          return nameComparison;
        }
      } else {
        int addedTimeComparison = a.addTime.compareTo(b.addTime);
        if (addedTimeComparison != 0) {
          return addedTimeComparison;
        }
      }
      return 0;
    });
    return flashcards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(isSortedAlphabetically
                ? Icons.sort_by_alpha
                : Icons.access_time),
            onPressed: () {
              setState(() {
                isSortedAlphabetically = !isSortedAlphabetically;
                fcards = sortFlashcards(fcards); // Sort the flashcards
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fcards,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            fcards = snapshot.data as List<Fcards>;
            fcards = sortFlashcards(fcards); // Sort the flashcards
            return Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(4),
                    children: List.generate(
                      fcards.length,
                      (index) {
                        final fcard = fcards[index];
                        return Card(
                          color: Colors.purple[100],
                          child: Container(
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditFlashcard(
                                          flashcard: fcard,
                                          updateFlashcardList:
                                              (editedFlashcard) {
                                            setState(() {
                                              fcards[index] = editedFlashcard;
                                            });
                                            editedFlashcard.dbUpdate();
                                          },
                                          deleteFlashcard: (flashcard) {
                                            setState(() {
                                              fcards.removeAt(index);
                                            });
                                            flashcard.dbDelete();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Center(
                                    child: Text(fcard
                                        .description)), // Display the description.
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFlashcardScreen(deck: widget.deck, addFlashcardCallback: (flashcard) {
                setState(() {
                  fcards.add(flashcard);
                });
              }),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}





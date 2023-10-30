import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/decks_cards.dart';

Future<void> loadAndInsertJsonData() async {
  // Load the JSON data from an asset file (replace 'your_json_file.json' with the actual file name)
  final jsonString = await rootBundle.loadString('assets/flashcards.json');
  final jsonData = json.decode(jsonString);

  // Iterate through the JSON data and insert it into the database
  for (final entry in jsonData) {
    final deckName = entry['title'] as String;
    final deck = Deck(name: deckName, description: '');

    // Save the deck to the database
    await deck.dbSave();

    final flashcards = entry['flashcards'] as List;
    for (final flashcard in flashcards) {
      final question = flashcard['question'] as String;
      final answer = flashcard['answer'] as String;
      final addedTime = DateTime.now().millisecondsSinceEpoch;

      final fcard = Fcards(decksId: deck.id!, description: question, answer: answer, addTime: addedTime);

      // Save the flashcard to the database
      await fcard.dbSave();
    }
  }
}

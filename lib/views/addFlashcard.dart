import 'package:flutter/material.dart';
import '../models/decks_cards.dart';

class AddFlashcardScreen extends StatefulWidget {
  final Deck deck;
  final Function(Fcards) addFlashcardCallback;

  const AddFlashcardScreen({required this.deck, required this.addFlashcardCallback});

  @override
  AddFlashcardScreenState createState() => AddFlashcardScreenState();
}

class AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final newFlashcard = Fcards(
                      decksId: widget.deck.id!,
                      description: questionController.text,
                      answer: answerController.text,
                      addTime: DateTime.now().millisecondsSinceEpoch,
                    );

                    newFlashcard.dbSave(); 
                    widget.addFlashcardCallback(newFlashcard);
                    // Save the new flashcard to the database
                    Navigator.pop(context);
                  },
                  child: const Text('Add Flashcard'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

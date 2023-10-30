import 'package:flutter/material.dart';
import '../models/decks_cards.dart';

class EditFlashcard extends StatefulWidget {
  final Fcards flashcard;
  final Function(Fcards editedFlashcard) updateFlashcardList;
  final Function(Fcards) deleteFlashcard;

  const EditFlashcard(
      {required this.flashcard,
      required this.updateFlashcardList,
      required this.deleteFlashcard,
      super.key});

  @override
  EditFlashcardState createState() => EditFlashcardState();
}

class EditFlashcardState extends State<EditFlashcard> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.flashcard.description;
    answerController.text = widget.flashcard.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final editedFlashcard = Fcards(
                      id: widget.flashcard.id,
                      description: descriptionController.text,
                      answer: answerController.text,
                      decksId: widget.flashcard.decksId,
                      addTime: widget.flashcard.addTime,
                    );

                    widget.updateFlashcardList(editedFlashcard);
                    Navigator.pop(context, editedFlashcard);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.deleteFlashcard(widget.flashcard);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

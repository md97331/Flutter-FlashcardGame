import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/dbhelper.dart';


class CardListPage extends StatelessWidget {
  final int deckIndex;

  CardListPage(this.deckIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deck $deckIndex - Card List')),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of flashcards in the deck
        itemBuilder: (context, index) {
          return CardItem(
            deckIndex: deckIndex,
            cardIndex: index + 1,
          );
        },
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final int deckIndex;
  final int cardIndex;

  CardItem({required this.deckIndex, required this.cardIndex});

  @override
  Widget build(BuildContext context) {
    // Fetch flashcard data (replace with actual data retrieval logic)
    final question = "Question $cardIndex"; // Replace with actual data
    final answer = "Answer $cardIndex";     // Replace with actual data

    return FlashcardItem(
      question: question,
      answer: answer,
      onEdit: () {
        // Handle the edit action for the flashcard
        // You can navigate to the Card Editor or show a dialog for editing
      },
      onDelete: () {
        // Handle the delete action for the flashcard
        // You can show a confirmation dialog and delete the flashcard
      },
    );
  }
}

class FlashcardItem extends StatelessWidget {
  final String question;
  final String answer;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  FlashcardItem({
    required this.question,
    required this.answer,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(question),
        subtitle: Text(answer),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}



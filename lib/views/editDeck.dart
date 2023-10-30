import 'package:flutter/material.dart';
import '../models/decks_cards.dart';

class EditDeck extends StatefulWidget {
  final Deck deck;
  final Function(Deck editedDeck) updateDeckList;
  final Function(Deck) deleteDeck;

  const EditDeck({
    required this.deck,
    required this.updateDeckList,
    required this.deleteDeck,
    super.key,
  });

  @override
  EditDeckState createState() => EditDeckState();
}

class EditDeckState extends State<EditDeck> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.deck.name;
    descriptionController.text = widget.deck.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Deck Name'),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final editedDeck = Deck(
                      id: widget.deck.id,
                      name: nameController.text,
                      description: "",
                    );

                    widget.updateDeckList(editedDeck);
                    editedDeck.dbUpdate();
                    Navigator.pop(context, editedDeck);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.deleteDeck(widget.deck);
                    Navigator.pop(context);
                    widget.deck.dbDelete();
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

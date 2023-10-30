import 'package:flutter/material.dart';
import '../models/decks_cards.dart';

class AddDeckScreen extends StatefulWidget {
  final Function(Deck) addDeckCallback;

  const AddDeckScreen({super.key, required this.addDeckCallback});

  @override
  AddDeckScreenState createState() => AddDeckScreenState();
}

class AddDeckScreenState extends State<AddDeckScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Deck'),
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
                    final newDeck = Deck(
                      name: nameController.text,
                      description: "",
                    );

                    widget.addDeckCallback(newDeck); // Add the new deck to the list
                    newDeck.dbSave(); // Save the new deck to the database

                    Navigator.pop(context);
                  },
                  child: const Text('Add Deck'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


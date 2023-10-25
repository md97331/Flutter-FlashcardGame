import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/dbhelper.dart';

class CardEditorPage extends StatelessWidget {
  final int deckIndex;
  final int cardIndex;

  CardEditorPage(this.deckIndex, this.cardIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Card $cardIndex - Deck $deckIndex')),
      body: Center(
        child: Text('Card Editor Content'),
      ),
    );
  }
}
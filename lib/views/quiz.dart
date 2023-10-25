import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/dbhelper.dart';

class QuizPage extends StatelessWidget {
  final int deckIndex;

  QuizPage(this.deckIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz - Deck $deckIndex')),
      body: Center(
        child: Text('Quiz Content'),
      ),
    );
  }
}

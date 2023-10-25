import 'package:flutter/material.dart';
import '../views/decklist.dart'; 
import 'utils/dbhelper.dart'; 

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DeckList(),
  ));
}
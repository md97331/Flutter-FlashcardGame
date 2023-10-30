import 'package:flutter/material.dart';
import 'views/decklist1.dart';
import '../utils/loadData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAndInsertJsonData();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DeckListG(),
  ));
}

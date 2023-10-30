import '../utils/dbhelper.dart';

//A deck contains a list of cards
class Deck {
  int? id;

  final String name;
  final String description;

  Deck({
    this.id,
    required this.name,
    required this.description,
  });

  // know how to save ourself to the database
  Future<void> dbSave() async {
    final db = DBHelper();
    final existingDeck = await db.query('decks', where: 'name = "$name"');

    if (existingDeck.isEmpty) {
      id = await db.insert('decks', {
        'name': name,
        'description': description,
      });
    } else {
      id = existingDeck.first['id'] as int;
    }
  }

  Future<void> dbUpdate() async {
    if (id != null) {
      await DBHelper().update('decks', {
        'id': id,
        'name': name,
        'description': description,
      });
    }
  }

  Future<void> dbDelete() async {
    if (id != null) {
      await DBHelper().delete('decks', id!);
    }
  }
}

class Fcards {
  int? id;
  final int decksId;
  final String description;
  final String answer;
  final int addTime;

  Fcards({
    this.id,
    required this.decksId,
    required this.description,
    required this.answer,
    required this.addTime,
  });

  Future<void> dbSave() async {
    final db = DBHelper();
    final existingFlashcard = await db.query('fcards',
        where: 'description = "$description" AND decks_Id = $decksId');

    if (existingFlashcard.isEmpty) {
      id = await db.insert('fcards', {
        'description': description,
        'answer': answer,
        'decks_Id': decksId,
        'add_time': addTime,
      });
    } else {
      id = existingFlashcard.first['id'] as int;
    }
  }

  // delete this record from the database
  Future<void> dbDelete() async {
    if (id != null) {
      await DBHelper().delete('fcards', id!);
    }
  }

  Future<void> dbUpdate() async {
    if (id != null) {
      await DBHelper().update('fcards', {
        'id': id,
        'description': description,
        'answer': answer,
        'decks_Id': decksId,
        'add_time': addTime,
      });
    }
  }
}

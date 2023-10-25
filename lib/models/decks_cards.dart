class Deck {
  int id;
  String title;
  List<Flashcard> flashcards;

  Deck({required this.id, required this.title, required this.flashcards});
}

class Flashcard {
  int id;
  String question;
  String answer;

  Flashcard({required this.id, required this.question, required this.answer});
}

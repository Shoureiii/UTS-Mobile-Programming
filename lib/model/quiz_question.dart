import 'dart:math';

import 'game.dart';

class QuizQuestion {
  final Game answer;
  final List<Game> choices;
  final String? imageUrl;

  const QuizQuestion({
    required this.answer,
    required this.choices,
    this.imageUrl,
  });

  static List<QuizQuestion> createFromGames(List<Game> games) {
    if (games.length < 20) {
      throw Exception('Data game dari API tidak cukup untuk membuat kuis.');
    }

    final random = Random();
    final shuffledGames = List<Game>.from(games)..shuffle(random);
    final answers = shuffledGames.take(5).toList();
    final questions = <QuizQuestion>[];

    for (final answer in answers) {
      final distractors =
          shuffledGames.where((game) => game.id != answer.id).toList()
            ..shuffle(random);

      final choices = <Game>[answer, ...distractors.take(3)]..shuffle(random);

      questions.add(QuizQuestion(answer: answer, choices: choices));
    }

    return questions;
  }
}

import 'package:flutter/material.dart';

import '../model/game.dart';
import '../model/quiz_question.dart';
import '../service/game_api.dart';
import '../widget/choice_button.dart';
import '../widget/error_view.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GameApi _gameApi = GameApi();

  late Future<List<QuizQuestion>> _questionsFuture;

  int _questionIndex = 0;
  int _score = 0;
  Game? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<QuizQuestion>> _loadQuestions() async {
    final games = await _gameApi.fetchGames();
    final questions = QuizQuestion.createFromGames(games);

    return Future.wait(
      questions.map((question) async {
        try {
          final screenshot = await _gameApi.fetchGameScreenshot(
            question.answer.id,
          );

          final imageUrl = (screenshot != null && screenshot.isNotEmpty)
              ? screenshot
              : question.answer.thumbnail;

          return QuizQuestion(
            answer: question.answer,
            choices: question.choices,
            imageUrl: imageUrl,
          );
        } catch (_) {
          return QuizQuestion(
            answer: question.answer,
            choices: question.choices,
            imageUrl: question.answer.thumbnail,
          );
        }
      }),
    );
  }

  void _retry() {
    setState(() {
      _questionsFuture = _loadQuestions();
      _questionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
    });
  }

  void _selectAnswer(Game choice, QuizQuestion question) {
    if (_selectedAnswer != null) return;

    setState(() {
      _selectedAnswer = choice;

      if (choice.id == question.answer.id) {
        _score++;
      }
    });
  }

  void _nextQuestion(List<QuizQuestion> questions) {
    if (_questionIndex == questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              ResultPage(score: _score, totalQuestions: questions.length),
        ),
      );
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TEBAK GAME',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menyiapkan pertanyaan...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          final questions = snapshot.data;

          if (questions == null || questions.isEmpty) {
            return ErrorView(
              message: 'Pertanyaan belum tersedia.',
              onRetry: _retry,
            );
          }

          final question = questions[_questionIndex];
          final hasAnswered = _selectedAnswer != null;
          final isCorrect = _selectedAnswer?.id == question.answer.id;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'SOAL ${_questionIndex + 1} DARI ${questions.length}',
                  style: const TextStyle(
                    color: Color(0xFFB9A9FF),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_questionIndex + 1) / questions.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 22),

                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      question.imageUrl ?? question.answer.thumbnail,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const ColoredBox(
                          color: Color(0xFF242430),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const _ImagePlaceholder();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                Text(
                  'Game apakah ini?',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Genre: ${question.answer.genre}\n'
                  'Platform: ${question.answer.platform}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                for (final choice in question.choices)
                  ChoiceButton(
                    title: choice.title,
                    hasAnswered: hasAnswered,
                    isCorrectAnswer: choice.id == question.answer.id,
                    isSelected: _selectedAnswer?.id == choice.id,
                    onPressed: () => _selectAnswer(choice, question),
                  ),

                if (hasAnswered) ...[
                  const SizedBox(height: 8),
                  Text(
                    isCorrect
                        ? 'Benar! Jawabanmu tepat.'
                        : 'Salah. Jawabannya ${question.answer.title}.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => _nextQuestion(questions),
                    child: Text(
                      _questionIndex == questions.length - 1
                          ? 'Lihat skor akhir'
                          : 'Pertanyaan berikutnya',
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF242430),
      child: Center(child: Icon(Icons.videogame_asset, size: 56)),
    );
  }
}

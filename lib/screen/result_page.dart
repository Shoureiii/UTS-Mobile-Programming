import 'package:flutter/material.dart';

import 'quiz_page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  void _playAgain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const QuizPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 84,
                color: Color(0xFFFFD166),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kuis selesai!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Skor: $score / $totalQuestions',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _playAgain(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Main lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
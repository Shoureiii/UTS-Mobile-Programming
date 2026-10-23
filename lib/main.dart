import 'package:flutter/material.dart';
import 'screen/quiz_page.dart';

void main() {
  runApp(const TebakGameApp());
}

class TebakGameApp extends StatelessWidget {
  const TebakGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tebak Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7456F1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121A),
      ),
      home: const QuizPage(),
    );
  }
}
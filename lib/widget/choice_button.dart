import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String title;
  final bool hasAnswered;
  final bool isCorrectAnswer;
  final bool isSelected;
  final VoidCallback onPressed;

  const ChoiceButton({
    super.key,
    required this.title,
    required this.hasAnswered,
    required this.isCorrectAnswer,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFF242430);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: hasAnswered ? null : onPressed,
          child: Text(title),
        ),
      ),
    );
  }
}
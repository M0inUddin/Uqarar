import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  final String text;
  const SectionHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[900],
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

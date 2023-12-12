import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String heading, text;
  const CustomText({
    super.key,
    required this.heading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$heading\t\t",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

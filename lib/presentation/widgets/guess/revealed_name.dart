import 'package:flutter/material.dart';

class RevealedName extends StatelessWidget {
  final String name;

  const RevealedName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        name.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

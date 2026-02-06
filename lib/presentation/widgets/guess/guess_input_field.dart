import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';

class GuessInputField extends StatelessWidget {
  final TextEditingController controller;

  const GuessInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Guess the name',
        hintText: 'e.g. Pikachu',
        filled: true,
        prefixIcon: const Icon(Icons.edit),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          context.read<GameBloc>().add(SubmitGuess(value.trim()));
          controller.clear();
        }
      },
    );
  }
}

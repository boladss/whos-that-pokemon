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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'Guess the pokemon!',
        hintText: 'e.g. Pikachu',
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: const Icon(Icons.catching_pokemon, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
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

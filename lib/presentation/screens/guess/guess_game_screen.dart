import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/core/di/injection.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';
import 'guess_game_view.dart';

class GuessGameScreen extends StatelessWidget {
  const GuessGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GameBloc>()..add(LoadNewPokemon()),
      child: const GuessGameView(),
    );
  }
}

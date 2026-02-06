import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/guess/pokemon_image_display.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/guess/guess_input_field.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/guess/revealed_name.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/guess/error_view.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/guess/game_actions.dart';

class GuessGameView extends StatefulWidget {
  const GuessGameView({super.key});

  @override
  State<GuessGameView> createState() => _GuessGameViewState();
}

class _GuessGameViewState extends State<GuessGameView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Who's That Pokémon?"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state.guessStatus == GuessStatus.correct) {
            _showSnackBar(context, 'Correct!', Colors.green);
          } else if (state.guessStatus == GuessStatus.wrong) {
            _showSnackBar(context, 'Try again!', Colors.red);
          }
        },
        builder: (context, state) {
          if (state.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (state.error != null) return ErrorView(error: state.error!);
          if (state.pokemon == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PokemonImageDisplay(
                  imageUrl: state.pokemon!.imageUrl,
                  isRevealed: state.isAnswerShown,
                ),
                const SizedBox(height: 30),
                if (!state.isAnswerShown)
                  GuessInputField(controller: _controller)
                else
                  RevealedName(name: state.pokemon!.name),
                const SizedBox(height: 24),
                GameActions(
                  isRevealed: state.isAnswerShown,
                  controller: _controller,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

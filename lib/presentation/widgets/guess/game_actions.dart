import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';

class GameActions extends StatelessWidget {
  final bool isRevealed;
  final TextEditingController controller;

  const GameActions({
    super.key,
    required this.isRevealed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (!isRevealed && !state.isHintShown)
                  ElevatedButton.icon(
                    onPressed: () => context.read<GameBloc>().add(ShowHint()),
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Hint'),
                  ),
                if (!isRevealed)
                  ElevatedButton.icon(
                    onPressed: () => context.read<GameBloc>().add(ShowAnswer()),
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Give Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.clear();
                    context.read<GameBloc>().add(LoadNewPokemon());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            if (state.isHintShown || isRevealed) ...[
              const SizedBox(height: 20),
              _HintCard(description: state.pokemon?.description),
            ],
          ],
        );
      },
    );
  }
}

class _HintCard extends StatelessWidget {
  final String? description;
  const _HintCard({this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[50],
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.yellow[700]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'POKÉDEX DATA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Text(
              description ?? 'No data available for this Pokémon.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

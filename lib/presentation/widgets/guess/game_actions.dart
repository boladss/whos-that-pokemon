import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';

class GameActions extends StatefulWidget {
  final bool isRevealed;
  final TextEditingController controller;

  const GameActions({
    super.key,
    required this.isRevealed,
    required this.controller,
  });

  @override
  State<GameActions> createState() => _GameActionsState();
}

class _GameActionsState extends State<GameActions> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bool hasInput = widget.controller.text.trim().isNotEmpty;

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Column(
          children: [
            if (!widget.isRevealed && !state.isHintShown)
              TextButton.icon(
                onPressed: () => context.read<GameBloc>().add(ShowHint()),
                icon: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Colors.amber,
                ),
                label: const Text(
                  'Need a clue?',
                  style: TextStyle(color: Colors.amber),
                ),
              ),

            if (state.isHintShown || widget.isRevealed) ...[
              const SizedBox(height: 12),
              _HintCard(description: state.pokemon?.description),
            ],

            const SizedBox(height: 24),

            // --- PRIMARY ACTION ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: _buildPrimaryButton(context, hasInput),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrimaryButton(BuildContext context, bool hasInput) {
    // 1. If revealed, show "Find Another"
    if (widget.isRevealed) {
      return ElevatedButton.icon(
        onPressed: () {
          widget.controller.clear();
          context.read<GameBloc>().add(LoadNewPokemon());
        },
        icon: const Icon(Icons.arrow_forward_rounded),
        label: const Text('FIND ANOTHER'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    if (hasInput) {
      return ElevatedButton.icon(
        onPressed: () {
          context.read<GameBloc>().add(
            SubmitGuess(widget.controller.text.trim()),
          );
          widget.controller.clear();
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('SUBMIT GUESS'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }

    // 3. Default: Show "Reveal"
    return OutlinedButton.icon(
      onPressed: () => context.read<GameBloc>().add(ShowAnswer()),
      icon: const Icon(Icons.visibility_outlined),
      label: const Text('REVEAL POKÉMON'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.grey[700],
        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
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

import 'dart:ui';
import 'package:flutter/material.dart';

class PokemonImageDisplay extends StatelessWidget {
  final String imageUrl;
  final bool isRevealed;

  const PokemonImageDisplay({
    super.key,
    required this.imageUrl,
    required this.isRevealed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        width: 250,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: isRevealed ? 0 : 6,
            sigmaY: isRevealed ? 0 : 6,
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, _, __) => const Icon(
              Icons.catching_pokemon,
              size: 100,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

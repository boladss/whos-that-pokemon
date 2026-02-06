import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const PokemonCard({
    super.key,
    required this.name,
    this.imageUrl = '', // Fallback
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: imageUrl.isEmpty
                  ? Icon(
                      Icons.catching_pokemon,
                      size: 80,
                      color: Colors.grey[300],
                    )
                  : Image.network(imageUrl),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_search_bar.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex'), centerTitle: true),
      body: Column(
        children: [
          // Search widget
          PokemonSearchBar(
            onChanged: (query) {
              print('Searching for: $query'); // Search
            },
          ),

          // Expanded list UI
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Columns
                childAspectRatio: 2 / 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 10, // Placeholder
              itemBuilder: (context, index) {
                return const PokemonCard(
                  name: 'Bulbasaur', // Temp
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

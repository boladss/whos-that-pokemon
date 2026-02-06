import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_search_bar.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_card.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/type_filter_picker.dart';
import 'package:maya_flutter_hackathon/logic/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const List<String> _pokemonTypes = [
    'All',
    'Grass',
    'Fire',
    'Water',
    'Electric',
    'Ghost',
    'Poison',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokédex'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Search Bar
            Builder(
              builder: (context) {
                return PokemonSearchBar(
                  onChanged: (query) {
                    context.read<SearchBloc>().add(FilterPokemonEvent(query));
                  },
                );
              },
            ),

            // Type Filter
            const TypeFilterPicker(types: _pokemonTypes),

            const SizedBox(height: 8),

            // Grid
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  // Empty state
                  if (state.filteredPokemon.isEmpty) {
                    return const Center(child: Text("No Pokémon found!"));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: state.filteredPokemon.length,
                    itemBuilder: (context, index) {
                      final pokemonData = state.filteredPokemon[index];
                      return PokemonCard(
                        name: pokemonData['name'] ?? 'Unknown',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

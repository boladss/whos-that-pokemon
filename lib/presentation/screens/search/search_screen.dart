import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_search_bar.dart';
import 'package:maya_flutter_hackathon/presentation/widgets/search/pokemon_card.dart';
import 'package:maya_flutter_hackathon/logic/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokédex'), centerTitle: true),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return PokemonSearchBar(
                  onChanged: (query) {
                    context.read<SearchBloc>().add(FilterPokemonEvent(query));
                  },
                );
              },
            ),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
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
                      return PokemonCard(name: state.filteredPokemon[index]);
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maya_flutter_hackathon/data/data_source/remote/pokemon_remote_data_source.dart';
import 'package:maya_flutter_hackathon/core/di/injection.dart';

// --- EVENTS ---
abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// --- EVENTS ---

class FilterPokemonEvent extends SearchEvent {
  final String query;
  FilterPokemonEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByTypeEvent extends SearchEvent {
  final String type;
  FilterByTypeEvent(this.type);
}

class SearchState extends Equatable {
  final List<Map<String, dynamic>> filteredPokemon;
  final List<String> selectedTypes;
  final String searchQuery;

  const SearchState({
    required this.filteredPokemon,
    this.selectedTypes = const ['All'], // Default to 'All'
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [filteredPokemon, selectedTypes, searchQuery];
}

// --- BLOC ---
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Backing store populated from pokeapi (100 pokemon)
  final List<Map<String, dynamic>> _pokemonList = [];

  SearchBloc() : super(const SearchState(filteredPokemon: [])) {
    on<FilterPokemonEvent>((event, emit) {
      _applyFilters(emit, newQuery: event.query);
    });

    on<FilterByTypeEvent>((event, emit) {
      List<String> currentTypes = List.from(state.selectedTypes);

      if (event.type == 'All') {
        // Fetch paginated list of EVERYBODY
        currentTypes = ['All'];
      } else {
        // On each update, need to fetch and filter each time :/
        // Need to consider multiple types
        currentTypes.remove('All');
        if (currentTypes.contains(event.type)) {
          currentTypes.remove(event.type);
        } else {
          currentTypes.add(event.type);
        }
      }

      _applyFilters(emit, newTypes: currentTypes);
    });

    // start loading the pokemon list
    _loadPokemonList();
  }

  void _loadPokemonList() async {
    try {
      final remote = sl<PokemonRemoteDataSource>();
      final list = await remote.getPokemonList(limit: 100, offset: 0);

      String capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

      for (final p in list) {
        _pokemonList.add({
          'name': capitalize(p.name),
          'types': p.types.map((t) => capitalize(t)).toList(),
          'imageUrl': p.imageUrl,
        });
      }

      // trigger filter to emit with loaded data
      add(FilterPokemonEvent(state.searchQuery));
    } catch (e) {
      print('Failed to load pokemon list: $e');
    }
  }

  void _applyFilters(
    Emitter<SearchState> emit, {
    String? newQuery,
    List<String>? newTypes,
  }) {
    final query = newQuery ?? state.searchQuery;
    var types = newTypes ?? state.selectedTypes;

    // All cannot be selected with others
    if (types.isEmpty) types = ['All'];

    final results = _pokemonList.where((p) {
      final matchesSearch = p['name'].toString().toLowerCase().contains(
        query.toLowerCase(),
      );

      final pokemonTypes = (p['types'] as List).map((t) => t.toString().toLowerCase()).toList();

      final matchesType = types.contains('All') || types.every((selected) => pokemonTypes.contains(selected.toLowerCase()));

      return matchesSearch && matchesType;
    }).toList();

    emit(
      SearchState(
        filteredPokemon: results,
        searchQuery: query,
        selectedTypes: types,
      ),
    );
  }
}

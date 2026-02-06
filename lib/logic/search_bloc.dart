import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
  // Mock data with types
  static final List<Map<String, dynamic>> _mockPokemon = [
    {
      'name': 'Bulbasaur',
      'types': ['Grass', 'Poison'],
    },
    {
      'name': 'Charmander',
      'types': ['Fire'],
    },
    {
      'name': 'Squirtle',
      'types': ['Water'],
    },
    {
      'name': 'Pikachu',
      'types': ['Electric'],
    },
    {
      'name': 'Gengar',
      'types': ['Ghost', 'Poison'],
    },
  ];

  SearchBloc() : super(SearchState(filteredPokemon: _mockPokemon)) {
    on<FilterPokemonEvent>((event, emit) {
      _applyFilters(emit, newQuery: event.query);
    });

    on<FilterByTypeEvent>((event, emit) {
      List<String> currentTypes = List.from(state.selectedTypes);

      if (event.type == 'All') {
        currentTypes = ['All'];
      } else {
        currentTypes.remove('All');
        if (currentTypes.contains(event.type)) {
          currentTypes.remove(event.type);
        } else {
          currentTypes.add(event.type);
        }
      }

      _applyFilters(emit, newTypes: currentTypes);
    });
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

    final results = _mockPokemon.where((p) {
      final matchesSearch = p['name'].toLowerCase().contains(
        query.toLowerCase(),
      );

      final pokemonTypes = p['types'] as List;

      final matchesType =
          types.contains('All') ||
          types.every((selected) => pokemonTypes.contains(selected));

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

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

// --- STATE ---
class SearchState extends Equatable {
  final List<Map<String, dynamic>> filteredPokemon;
  final String selectedType;
  final String searchQuery;

  const SearchState({
    required this.filteredPokemon,
    this.selectedType = 'All',
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [filteredPokemon, selectedType, searchQuery];
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

  static final List<String> _allTypes = [
    'All',
    'Grass',
    'Fire',
    'Water',
    'Electric',
    'Ghost',
    'Poison',
  ];

  SearchBloc() : super(SearchState(filteredPokemon: _mockPokemon)) {
    on<FilterPokemonEvent>((event, emit) {
      _applyFilters(emit, newQuery: event.query);
    });

    on<FilterByTypeEvent>((event, emit) {
      _applyFilters(emit, newType: event.type);
    });
  }

  void _applyFilters(
    Emitter<SearchState> emit, {
    String? newQuery,
    String? newType,
  }) {
    final query = newQuery ?? state.searchQuery;
    final type = newType ?? state.selectedType;

    final results = _mockPokemon.where((p) {
      final matchesSearch = p['name'].toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesType = type == 'All' || (p['types'] as List).contains(type);
      return matchesSearch && matchesType;
    }).toList();

    emit(
      SearchState(
        filteredPokemon: results,
        searchQuery: query,
        selectedType: type,
      ),
    );
  }
}

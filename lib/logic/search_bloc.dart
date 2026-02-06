import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maya_flutter_hackathon/data/data_source/remote/pokemon_remote_data_source.dart';
import 'package:maya_flutter_hackathon/core/di/injection.dart';

// --- EVENTS ---
abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class FilterPokemonEvent extends SearchEvent {
  final String query;
  const FilterPokemonEvent(this.query);
  @override
  List<Object> get props => [query];
}

class FilterByTypeEvent extends SearchEvent {
  final String type;
  const FilterByTypeEvent(this.type);
  @override
  List<Object> get props => [type];
}

// Internal event to update the master list after API call
class _PokemonLoadedInternal extends SearchEvent {
  final List<Map<String, dynamic>> pokemon;
  const _PokemonLoadedInternal(this.pokemon);
}

// --- STATE ---
class SearchState extends Equatable {
  final List<Map<String, dynamic>> allPokemon; // The master list
  final List<Map<String, dynamic>> filteredPokemon;
  final List<String> selectedTypes;
  final String searchQuery;
  final bool isLoading; // 👈 KEY: Tracks loading status

  const SearchState({
    this.allPokemon = const [],
    this.filteredPokemon = const [],
    this.selectedTypes = const ['All'],
    this.searchQuery = '',
    this.isLoading = false, // Default to false
  });

  SearchState copyWith({
    List<Map<String, dynamic>>? allPokemon,
    List<Map<String, dynamic>>? filteredPokemon,
    List<String>? selectedTypes,
    String? searchQuery,
    bool? isLoading,
  }) {
    return SearchState(
      allPokemon: allPokemon ?? this.allPokemon,
      filteredPokemon: filteredPokemon ?? this.filteredPokemon,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
    allPokemon,
    filteredPokemon,
    selectedTypes,
    searchQuery,
    isLoading,
  ];
}

// --- BLOC ---
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState(isLoading: true)) {
    // Start with isLoading: true

    // Handle API results
    on<_PokemonLoadedInternal>((event, emit) {
      emit(state.copyWith(allPokemon: event.pokemon, isLoading: false));
      _applyFilters(emit); // Refresh filtered list
    });

    on<FilterPokemonEvent>((event, emit) {
      _applyFilters(emit, newQuery: event.query);
    });

    on<FilterByTypeEvent>((event, emit) {
      List<String> currentTypes = List.from(state.selectedTypes);
      if (event.type == 'All') {
        currentTypes = ['All'];
      } else {
        currentTypes.remove('All');
        currentTypes.contains(event.type)
            ? currentTypes.remove(event.type)
            : currentTypes.add(event.type);
      }
      if (currentTypes.isEmpty) currentTypes = ['All'];
      _applyFilters(emit, newTypes: currentTypes);
    });

    _loadPokemonList();
  }

  void _loadPokemonList() async {
    try {
      final remote = sl<PokemonRemoteDataSource>();
      final list = await remote.getPokemonList(limit: 100, offset: 0);

      String capitalize(String s) =>
          s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

      final List<Map<String, dynamic>> loadedData = list
          .map(
            (p) => {
              'name': capitalize(p.name),
              'types': p.types.map((t) => capitalize(t)).toList(),
              'imageUrl': p.imageUrl,
            },
          )
          .toList();

      add(_PokemonLoadedInternal(loadedData));
    } catch (e) {
      print('Failed to load pokemon list: $e');
      add(const _PokemonLoadedInternal([])); // Finish loading even on error
    }
  }

  void _applyFilters(
    Emitter<SearchState> emit, {
    String? newQuery,
    List<String>? newTypes,
  }) {
    final query = (newQuery ?? state.searchQuery).toLowerCase();
    final types = newTypes ?? state.selectedTypes;

    final results = state.allPokemon.where((p) {
      final matchesSearch = p['name'].toString().toLowerCase().contains(query);
      final pTypes = (p['types'] as List)
          .map((t) => t.toString().toLowerCase())
          .toList();
      final matchesType =
          types.contains('All') ||
          types.every((sel) => pTypes.contains(sel.toLowerCase()));
      return matchesSearch && matchesType;
    }).toList();

    emit(
      state.copyWith(
        filteredPokemon: results,
        searchQuery: query,
        selectedTypes: types,
      ),
    );
  }
}

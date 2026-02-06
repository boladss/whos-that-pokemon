import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- EVENTS ---
abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterPokemonEvent extends SearchEvent {
  final String query;
  FilterPokemonEvent(this.query);
}

// --- STATES ---
class SearchState extends Equatable {
  final List<String> allPokemon;
  final List<String> filteredPokemon;

  const SearchState({required this.allPokemon, required this.filteredPokemon});

  @override
  List<Object> get props => [allPokemon, filteredPokemon];
}

// --- BLOC ---
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Mock data
  static const List<String> _mockData = [
    'Bulbasaur',
    'Ivysaur',
    'Venusaur',
    'Charmander',
    'Charmeleon',
    'Charizard',
    'Squirtle',
    'Pikachu',
  ];

  SearchBloc()
    : super(
        const SearchState(allPokemon: _mockData, filteredPokemon: _mockData),
      ) {
    on<FilterPokemonEvent>((event, emit) {
      final results = state.allPokemon
          .where((p) => p.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(SearchState(allPokemon: state.allPokemon, filteredPokemon: results));
    });
  }
}

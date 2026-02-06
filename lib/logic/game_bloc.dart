import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_random_pokemon.dart';

// Events
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class LoadNewPokemon extends GameEvent {}

class SubmitGuess extends GameEvent {
  final String guess;

  const SubmitGuess(this.guess);

  @override
  List<Object> get props => [guess];
}

class ShowHint extends GameEvent {}

class ShowAnswer extends GameEvent {}

// States
enum GuessStatus { none, correct, wrong }

class GameState extends Equatable {
  final Pokemon? pokemon;
  final bool isLoading;
  final String? error;
  final GuessStatus guessStatus;
  final bool isHintShown;
  final bool isAnswerShown;

  const GameState({
    this.pokemon,
    this.isLoading = false,
    this.error,
    this.guessStatus = GuessStatus.none,
    this.isHintShown = false,
    this.isAnswerShown = false,
  });

  factory GameState.initial() => const GameState();

  GameState copyWith({
    Pokemon? pokemon,
    bool? isLoading,
    String? error,
    GuessStatus? guessStatus,
    bool? isHintShown,
    bool? isAnswerShown,
  }) {
    return GameState(
      pokemon: pokemon ?? this.pokemon,
      isLoading: isLoading ?? this.isLoading,
      error:
          error, // If not provided, it means clear error or keep it? Use nullable wisely.
      guessStatus: guessStatus ?? this.guessStatus,
      isHintShown: isHintShown ?? this.isHintShown,
      isAnswerShown: isAnswerShown ?? this.isAnswerShown,
    );
  }

  @override
  List<Object?> get props => [
    pokemon,
    isLoading,
    error,
    guessStatus,
    isHintShown,
    isAnswerShown,
  ];
}

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetRandomPokemon getRandomPokemon;

  GameBloc({required this.getRandomPokemon}) : super(GameState.initial()) {
    on<LoadNewPokemon>(_onLoadNewPokemon);
    on<SubmitGuess>(_onSubmitGuess);
    on<ShowHint>(_onShowHint);
    on<ShowAnswer>(_onShowAnswer);
  }

  Future<void> _onLoadNewPokemon(
    LoadNewPokemon event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final pokemon = await getRandomPokemon();
      emit(
        GameState(
          pokemon: pokemon,
          isLoading: false,
          guessStatus: GuessStatus.none,
          isHintShown: false,
          isAnswerShown: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSubmitGuess(SubmitGuess event, Emitter<GameState> emit) {
    if (state.pokemon == null) return;

    final isCorrect =
        event.guess.trim().toLowerCase() == state.pokemon!.name.toLowerCase();

    if (isCorrect) {
      emit(
        state.copyWith(guessStatus: GuessStatus.correct, isAnswerShown: true),
      ); // Show image on correct guess
    } else {
      emit(state.copyWith(guessStatus: GuessStatus.wrong));
    }
  }

  void _onShowHint(ShowHint event, Emitter<GameState> emit) {
    emit(state.copyWith(isHintShown: true));
  }

  void _onShowAnswer(ShowAnswer event, Emitter<GameState> emit) {
    emit(
      state.copyWith(isAnswerShown: true, guessStatus: GuessStatus.none),
    ); // Treat giving up as not solved but revealed
  }
}

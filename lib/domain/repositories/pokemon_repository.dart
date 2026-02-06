import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Pokemon> getRandomPokemon();
}

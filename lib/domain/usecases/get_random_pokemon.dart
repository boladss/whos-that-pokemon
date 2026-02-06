import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetRandomPokemon {
  final PokemonRepository repository;

  GetRandomPokemon(this.repository);

  Future<Pokemon> call() async {
    return await repository.getRandomPokemon();
  }
}

import 'package:maya_flutter_hackathon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonModel> getRandomPokemon();
}
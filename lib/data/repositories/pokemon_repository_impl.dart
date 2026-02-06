import 'package:maya_flutter_hackathon/domain/entities/pokemon.dart';
import 'package:maya_flutter_hackathon/domain/repositories/pokemon_repository.dart';
import 'package:maya_flutter_hackathon/data/data_source/remote/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Pokemon> getRandomPokemon() async {
    return await remoteDataSource.getRandomPokemon();
  }
}
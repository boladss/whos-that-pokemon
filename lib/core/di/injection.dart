import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:maya_flutter_hackathon/data/data_source/remote/pokemon_remote_data_source.dart';
import 'package:maya_flutter_hackathon/data/repositories/pokemon_repository_impl.dart';
import 'package:maya_flutter_hackathon/domain/repositories/pokemon_repository.dart';
import 'package:maya_flutter_hackathon/domain/usecases/get_random_pokemon.dart';
import 'package:maya_flutter_hackathon/logic/game_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => GameBloc(getRandomPokemon: sl()));

  sl.registerLazySingleton(() => GetRandomPokemon(sl()));

  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton(() => http.Client());
}

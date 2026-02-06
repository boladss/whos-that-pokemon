import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:maya_flutter_hackathon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonModel> getRandomPokemon();
  Future<List<PokemonModel>> getPokemonList({int limit, int offset});
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getRandomPokemon() async {
    // Generate a random pokemon

    print("fecthing");
    final id = Random().nextInt(1000) + 1;

    // Fetch Pokemon Data
    final pokemonResponse = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'),
    );

    if (pokemonResponse.statusCode != 200) {
      throw Exception('Failed to load pokemon data');
    }

    final pokemonData = jsonDecode(pokemonResponse.body);

    print(pokemonData);

    // Fetch Species Data
    final speciesResponse = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id/'),
    );

    if (speciesResponse.statusCode != 200) {
      throw Exception('Failed to load species data');
    }

    final speciesData = jsonDecode(speciesResponse.body);

    return PokemonModel.fromJson(pokemonData, speciesData);
  }

  @override
  Future<List<PokemonModel>> getPokemonList({int limit = 100, int offset = 0}) async {
    // Fetch the list endpoint which returns name and url for each pokemon
    final listResponse = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset'),
    );

    if (listResponse.statusCode != 200) {
      throw Exception('Failed to load pokemon list');
    }

    final listData = jsonDecode(listResponse.body) as Map<String, dynamic>;
    final results = (listData['results'] as List).cast<Map<String, dynamic>>();

    // For each result, fetch the detailed pokemon and species data.
    final futures = results.map((r) async {
      final detailResp = await client.get(Uri.parse(r['url'] as String));
      if (detailResp.statusCode != 200) throw Exception('Failed to load pokemon detail');
      final pokemonData = jsonDecode(detailResp.body) as Map<String, dynamic>;

      // species url is provided in the pokemon detail
      final speciesUrl = (pokemonData['species'] as Map<String, dynamic>)['url'] as String;
      final speciesResp = await client.get(Uri.parse(speciesUrl));
      if (speciesResp.statusCode != 200) throw Exception('Failed to load species data');
      final speciesData = jsonDecode(speciesResp.body) as Map<String, dynamic>;

      return PokemonModel.fromJson(pokemonData, speciesData);
    }).toList();

    final list = await Future.wait(futures);
    return list;
  }
}

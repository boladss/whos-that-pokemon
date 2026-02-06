import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:maya_flutter_hackathon/data/models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonModel> getRandomPokemon();
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({required this.client});

  @override
  Future<PokemonModel> getRandomPokemon() async {
    // Generate a random pokemon
    final id = Random().nextInt(1000) + 1; 

    // Fetch Pokemon Data
    final pokemonResponse = await client.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'),
    );

    if (pokemonResponse.statusCode != 200) {
      throw Exception('Failed to load pokemon data');
    }

    final pokemonData = jsonDecode(pokemonResponse.body);

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
}
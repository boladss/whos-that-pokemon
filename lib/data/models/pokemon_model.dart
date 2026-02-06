import 'package:maya_flutter_hackathon/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.types,
    required super.description,
    required super.generation,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> pokemonData, Map<String, dynamic> speciesData) {
    // Extract sprite URL
    final String frontDefault = pokemonData['sprites']['front_default'] ?? '';

    // Extract pokemon type
    final List<String> types = (pokemonData['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();

    // Extract pokemon description
    final flavorText = (speciesData['flavor_text_entries'] as List)
        .firstWhere((entry) => entry['language']['name'] == 'en', orElse: () => {'flavor_text': 'No description available'})['flavor_text'];
    
    final cleanText = flavorText
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ');

    // Extract pokemon generation
    final String generation = speciesData['generation']['name'];

    return PokemonModel(
      id: pokemonData['id'],
      name: pokemonData['name'],
      imageUrl: frontDefault,
      types: types,
      description: cleanText,
      generation: generation,
    );
  }
}
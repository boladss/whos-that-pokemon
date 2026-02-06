import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final String description;
  final String generation;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.description,
    required this.generation,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, types, description, generation];
}

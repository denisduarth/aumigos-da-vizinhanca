// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Animal {
  final String id;
  final double age;
  final String name;
  final String? furColor;
  final String race;
  final String userId;
  final String species;
  final String image;

  Animal({
    required this.age,
    required this.name,
    required this.userId,
    required this.race,
    this.furColor,
    required this.species,
    required this.image
  }) : id = const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'age': age,
        'name': name,
        'furColor': furColor ?? '',
        'race': race,
        'userId': userId,
        'species': species,
        'image': image
      };

  factory Animal.fromMap(Map<String, dynamic> map) => Animal(
        name: map['name'] as String,
        age: ['age'] as double,
        furColor: map['furColor'] ?? '',
        userId: map['userId'] as String,
        species: map['species'] as String,
        race: map['race'] as String,
        image: map['image'] as String
      );

  factory Animal.fromJson(String source) =>
      Animal.fromMap(json.decode(source) as Map<String, dynamic>);
}

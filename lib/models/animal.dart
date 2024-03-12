// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../enums/all.dart';

class Animal {
  final String id;
  final int age;
  final String name;
  final String furColor;
  final dynamic race;
  final String ownerName;
  final String species;

  Animal({
    required this.age,
    required this.name,
    required this.ownerName,
    required this.race,
    required this.furColor,
    required this.species,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'age': age,
        'name': name,
        'furColor': furColor,
        'race': race,
        'ownerName': ownerName,
        'species': species
      };

  factory Animal.fromMap(Map<String, dynamic> map) => Animal(
        name: map['name'] as String,
        age: ['age'] as int,
        furColor: map['furColor'] as String,
        ownerName: map['ownerName'] as String,
        species: map['species'] as String,
        race: map['species'] == 'dog'
            ? map['race'] as DogRaces
            : map['race'] as CatRaces,
      );

  factory Animal.fromJson(String source) =>
      Animal.fromMap(json.decode(source) as Map<String, dynamic>);
}

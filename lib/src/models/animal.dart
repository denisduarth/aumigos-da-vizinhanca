// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Animal {
  String id, name, race, userId, species, image, lastFeedingDate, street;
  String? furColor;
  bool wasFed;
  double latitude, longitude, age;
  int feedingInterval;

  Animal({
    required this.age,
    required this.name,
    required this.userId,
    required this.race,
    required this.species,
    required this.image,
    required this.wasFed,
    required this.street,
    required this.latitude,
    required this.longitude,
    this.furColor,
  })  : id = const Uuid().v4(),
        lastFeedingDate = DateTime.now().toIso8601String(),
        feedingInterval = 4;

  Map<String, dynamic> toMap() => {
        'id': id,
        'age': age,
        'name': name,
        'furColor': furColor ?? '',
        'race': race,
        'userId': userId,
        'species': species,
        'image': image,
        'wasFed': wasFed,
        'lastFeedingDate': lastFeedingDate,
        'street': street,
        'latitude': latitude,
        'longitude': longitude,
        'feedingInterval': feedingInterval
      };

  factory Animal.fromMap(Map<String, dynamic> map) => Animal(
        name: map['name'] as String,
        age: ['age'] as double,
        furColor: map['furColor'] ?? '',
        userId: map['userId'] as String,
        species: map['species'] as String,
        race: map['race'] as String,
        image: map['image'] as String,
        wasFed: map['wasFed'] as bool,
        street: map['street'] as String,
        latitude: map['latitude'] as double,
        longitude: map['longitude'] as double,
      );

  factory Animal.fromJson(String source) =>
      Animal.fromMap(json.decode(source) as Map<String, dynamic>);
}

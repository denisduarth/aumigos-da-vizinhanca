import '../models/enums/cat-races.dart';
import '../models/animal.dart';

class Cat extends Animal {
  String ownerName, furColor;
  final CatRaces race;

  Cat({
    required age,
    required name,
    required this.ownerName,
    required this.furColor,
    required this.race
  }) : super(age: age, name: name);

  @override
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'name': name,
      'ownerName': ownerName,
      'furColor': furColor,
      'race': race
    };
  }
}

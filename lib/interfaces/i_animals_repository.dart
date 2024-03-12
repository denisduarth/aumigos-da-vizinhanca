import '../models/animal.dart';

abstract class IAnimalsRepository {
  Future<dynamic> getAnimals();
  Future<void> addAnimal(Animal animal);
  Future<void> deleteAnimal(String id);
  Future<void> updateAnimal(String id, Animal animal);
}

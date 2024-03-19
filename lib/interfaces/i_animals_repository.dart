import '../models/animal.dart';

abstract class IAnimalsRepository {
  Stream<List<Map<String, dynamic>>> getAnimals();
  Future<void> addAnimal(Animal animal);
  Future<void> deleteAnimal(String id);
  Future<void> updateAnimal(String id, Animal animal);
  Stream<List<Map<String, dynamic>>> getAnimalsByName(String name);
}

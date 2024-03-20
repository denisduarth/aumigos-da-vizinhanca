import '../models/animal.dart';

abstract class IAnimalsRepository {
  Stream<List<Map<String, dynamic>>> getAnimals();
  Stream<List<Map<String, dynamic>>> getAnimalsByName(String name);
  Stream<List<Map<String, dynamic>>> getAnimalsByUserId(String userId);
  Stream<List<Map<String, dynamic>>> getAnimalsByStreet(String street);
  Future<void> addAnimal(Animal animal);
  Future<void> deleteAnimal(String id);
  Future<void> updateAnimal(String id, Animal animal);
}

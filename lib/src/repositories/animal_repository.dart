import 'package:aumigos_da_vizinhanca/src/repositories/database.dart';

import '../interfaces/i_animals_repository.dart';
import '../models/animal.dart';

class AnimalRepository extends Database implements IAnimalsRepository {
  @override
  Future<void> addAnimal(Animal animal) async {
    await db.from('animals').insert(animal.toMap());
  }

  @override
  Future<void> deleteAnimal(String id) async {
    await db.from('animals').delete().eq('id', id);
  }

  @override
  Stream<List<Map<String, dynamic>>> getAnimals() =>
      db.from('animals').select().asStream();

  @override
  Stream<List<Map<String, dynamic>>> getAnimalsByName(String name) =>
      db.from('animals').select().textSearch('name', name).asStream();

  @override
  Stream<List<Map<String, dynamic>>> getAnimalsByUserId(String userId) =>
      db.from('animals').select().textSearch('userId', userId).asStream();

  @override
  Stream<List<Map<String, dynamic>>> getAnimalsByStreet(String street) =>
      db.from('animals').select().textSearch('street', street).asStream();

  @override
  Future<void> updateAnimal(String id, Animal animal) async {
    await db.from('animals').upsert(animal.toMap()).eq('id', id);
  }
}

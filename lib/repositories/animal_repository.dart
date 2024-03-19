import '../interfaces/i_animals_repository.dart';
import '../models/animal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnimalRepository implements IAnimalsRepository {
  late SupabaseClient db;

  AnimalRepository() : db = Supabase.instance.client;

  @override
  Future<void> addAnimal(Animal animal) async {
    await db.from('animals').insert(animal.toMap());
  }

  @override
  Future<void> deleteAnimal(String id) async {
    await db.from('animals').delete().eq('id', id);
  }

  @override
  Stream<List<Map<String, dynamic>>> getAnimals() {
    return db.from('animals').select().asStream();
  }

  @override
  Stream<List<Map<String, dynamic>>> getAnimalsByName(String name) {
    final animalData =
        db.from('animals').select().textSearch('name', name).asStream();

    return animalData;
  }

  @override
  Future<void> updateAnimal(String id, Animal animal) async {
    await db.from('animals').upsert(animal.toMap()).eq('id', id);
  }
}

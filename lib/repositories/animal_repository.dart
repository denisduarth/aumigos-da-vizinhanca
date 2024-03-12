import '../interfaces/i_animals_repository.dart';
import '../models/animal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnimalRepository implements IAnimalsRepository {
  late SupabaseClient db;

  AnimalRepository() {
    db = Supabase.instance.client;
  }

  @override
  Future<void> addAnimal(Animal animal) async {
    await db.from('animals').insert(animal.toMap());
  }

  @override
  Future<void> deleteAnimal(String id) async {
    await db.from('animals').delete().eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> getAnimals() async {
    var response = await db.from('animals').select();
    return response;
  }

  @override
  Future<void> updateAnimal(String id, Animal animal) async {
    await db.from('animals').upsert(animal.toMap()).eq('id', id);
  }
}

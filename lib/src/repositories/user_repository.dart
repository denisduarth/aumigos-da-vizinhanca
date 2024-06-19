import 'dart:async';

import 'package:aumigos_da_vizinhanca/src/interfaces/i_user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository implements IUserRepository {
  late SupabaseClient db;

  UserRepository() : db = Supabase.instance.client;

  @override
  Future<AuthResponse> login(String? email, String? password) async {
    return await db.auth
        .signInWithPassword(email: email ?? '', password: password ?? '');
  }

  @override
  Future<void> logout() async {
    await db.auth.signOut();
  }

  User? get getCurrentUser => db.auth.currentUser;
}

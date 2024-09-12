import 'dart:async';

import 'package:aumigos_da_vizinhanca/src/interfaces/i_user_repository.dart';
import 'package:aumigos_da_vizinhanca/src/repositories/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository extends Database implements IUserRepository {
  @override
  Future<AuthResponse> login(String? email, String? password) async =>
      await db.auth
          .signInWithPassword(email: email ?? '', password: password ?? '');

  @override
  Future<void> logout() async {
    await db.auth.signOut();
  }

  User? get getCurrentUser => db.auth.currentUser;
}

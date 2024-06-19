import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IUserRepository {
  Future<AuthResponse> login(String? email, String? password);
  Future<void> logout();
}

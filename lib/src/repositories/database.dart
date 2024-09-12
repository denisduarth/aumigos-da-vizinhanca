import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Database {
  @protected
  late SupabaseClient db;

  Database() {
    db = Supabase.instance.client;
  }

  Future<void> dispose() async {
    await db.dispose();
  }
}

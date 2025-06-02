import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnon,
  );
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabaseAnon => _get('SUPABASE_ANON_KEY');
  static String get stripePk => _get('STRIPE_PK');

  static Future<void> load() async {
    await dotenv.load();
  }

  static String _get(String key) {
    final val = dotenv.env[key];
    if (val == null || val.isEmpty) {
      throw StateError('Missing env var $key');
    }
    return val;
  }
}

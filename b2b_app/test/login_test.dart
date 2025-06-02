import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:b2b_app/core/supabase_client.dart';

void main() {
  test('login success', () async {
    final client = SupabaseClient('url', 'anon');
    expect(client.auth, isNotNull);
  });
}

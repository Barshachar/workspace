import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:b2b_app/features/auth/presentation/login_page.dart';
import 'package:b2b_app/core/router/app_router.dart';

class FakeSupabase extends SupabaseClient {
  FakeSupabase() : super('url', 'key');
  bool verified = false;
  @override
  Future<AuthResponse> signInWithOtp({required String email, String? password, Map<String, dynamic>? data, AuthOptions? options}) async {
    return AuthResponse(user: null, session: null);
  }
  @override
  Future<AuthResponse> verifyOTP({required String token, required OtpType type, String? email, String? phone, String? password, Map<String, dynamic>? data, AuthOptions? options}) async {
    verified = true;
    return AuthResponse(user: User(id: '1', appMetadata: {}, userMetadata: {}, aud: '', createdAt: ''), session: Session(accessToken: '', tokenType: '', user: User(id: '1', appMetadata: {}, userMetadata: {}, aud: '', createdAt: ''), refreshToken: '', providerRefreshToken: null, providerToken: null, expiresIn: 3600));
  }
}

void main() {
  testWidgets('auth flow', (tester) async {
    final fake = FakeSupabase();
    Supabase.instance.initialize(url: 'u', anonKey: 'k');
    Supabase.instance.client = fake;
    await tester.pumpWidget(ProviderScope(child: MaterialApp.router(routerConfig: router)));
    await tester.enterText(find.byType(TextField).first, 'a@b.com');
    await tester.tap(find.text('שלח קוד'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).last, '1234');
    await tester.tap(find.text('אמת'));
    await tester.pumpAndSettle();
    expect(fake.verified, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/router/app_router.dart';
import '../../../core/notification_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _codeSent = false;

  Future<void> _login() async {
    final email = _emailController.text;
    await Supabase.instance.client.auth.signInWithOtp(email: email);
    setState(() => _codeSent = true);
  }

  Future<void> _verify() async {
    final token = _tokenController.text;
    final resp = await Supabase.instance.client.auth.verifyOTP(
      email: _emailController.text,
      token: token,
      type: OtpType.email,
    );
    final user = resp.user;
    if (user != null) {
      final profile = await Supabase.instance.client
          .from('customers')
          .select('role')
          .eq('id', user.id)
          .single();
      final role = profile.data?['role'] as String? ?? 'buyer';
      await NotificationService.subscribeTopic('customer_${user.id}');
      if (role == 'sales_rep') {
        await NotificationService.subscribeTopic('rep_${user.id}');
      }
      if (mounted) router.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('כניסה')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'אימייל'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('שלח קוד')),
            if (_codeSent) ...[
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(labelText: 'קוד אימות'),
              ),
              ElevatedButton(onPressed: _verify, child: const Text('אמת')),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'app.dart';
import 'core/supabase_client.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const App());
}

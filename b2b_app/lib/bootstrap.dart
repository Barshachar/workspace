import 'package:flutter/material.dart';
import 'app.dart';
import 'core/supabase_client.dart';
import 'core/env.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();
  Stripe.publishableKey = Env.stripePk;
  await Hive.initFlutter();
  await initSupabase();
  await NotificationService.init();
  runApp(const App());
}

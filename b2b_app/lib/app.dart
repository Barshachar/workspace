import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        locale: const Locale('he'),
        supportedLocales: const [Locale('he')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: router,
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}

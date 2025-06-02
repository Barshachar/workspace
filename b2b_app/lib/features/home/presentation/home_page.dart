import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('דף הבית')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => router.go('/catalog'),
              child: const Text('קטלוג'),
            ),
            ElevatedButton(
              onPressed: () => router.go('/cart'),
              child: const Text('עגלה'),
            ),
          ],
        ),
      ),
    );
  }
}

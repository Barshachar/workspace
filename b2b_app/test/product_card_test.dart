import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:b2b_app/features/catalog/presentation/catalog_page.dart';

void main() {
  testWidgets('product card renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CatalogPage()));
    expect(find.text('מוצר א'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:b2b_app/features/checkout/presentation/checkout_page.dart';
import 'package:b2b_app/features/orders/data/order_repository.dart';

void main() {
  testWidgets('stripe payment success', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderRepositoryProvider.overrideWithValue(OrderRepository()),
          createPaymentIntentProvider.overrideWithValue((_, __) async => {'client_secret': 'secret'}),
        ],
        child: const MaterialApp(home: CheckoutPage(orderId: '1', amount: 10)),
      ),
    );
    await tester.tap(find.text('שלם'));
    await tester.pump();
    expect(find.text('שולם'), findsOneWidget);
  });
}

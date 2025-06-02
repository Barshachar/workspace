import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:b2b_app/features/recommendations/presentation/recommendations_carousel.dart';
import 'package:b2b_app/features/recommendations/logic/recommendation_notifier.dart';
import 'package:b2b_app/core/models/product.dart';

class FakeRepo extends RecommendationRepository {
  @override
  Future<List<Product>> fetchForCustomer(String customerId) async {
    return [const Product(id: '1', name: 'מוצר', price: 10)];
  }
}

void main() {
  testWidgets('shows recommendation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recommendationRepositoryProvider.overrideWithValue(FakeRepo()),
        ],
        child: const MaterialApp(
          home: RecommendationsCarousel(customerId: '1'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('מוצר'), findsOneWidget);
  });
}

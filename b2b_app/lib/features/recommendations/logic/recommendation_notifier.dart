import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/recommendation_repository.dart';
import '../../../core/models/product.dart';

final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) => RecommendationRepository());

final recommendationProvider = FutureProvider.family
    .autoDispose<List<Product>, String>((ref, customerId) async {
  final repo = ref.read(recommendationRepositoryProvider);
  return repo.fetchForCustomer(customerId);
});

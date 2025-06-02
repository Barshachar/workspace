import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/recommendation_notifier.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class RecommendationsCarousel extends ConsumerWidget {
  final String customerId;
  const RecommendationsCarousel({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRec = ref.watch(recommendationProvider(customerId));
    return asyncRec.when(
      data: (products) {
        for (final p in products) {
          FirebaseAnalytics.instance.logEvent(
            name: 'view_recommendation',
            parameters: {'product_id': p.id},
          );
        }
        return SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final p = products[index];
            return Column(
              children: [
                CachedNetworkImage(
                  imageUrl: p.imageUrl ?? '',
                  width: 100,
                  height: 100,
                ),
                GestureDetector(
                  onTap: () => FirebaseAnalytics.instance.logEvent(
                    name: 'click_recommendation',
                    parameters: {'product_id': p.id},
                  ),
                  child: Text(p.name),
                ),
              ],
            );
          },
        ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}

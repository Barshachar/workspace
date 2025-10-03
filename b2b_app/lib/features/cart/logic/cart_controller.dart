import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/order_item.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

final cartUserIdProvider = Provider<String>((ref) {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    throw StateError('No authenticated user found');
  }
  return user.id;
});

final cartControllerProvider =
    AsyncNotifierProvider<CartController, List<OrderItem>>(CartController.new);

class CartController extends AsyncNotifier<List<OrderItem>> {
  late final CartRepository _repo;
  StreamSubscription<List<OrderItem>>? _subscription;
  String get userId => ref.read(cartUserIdProvider);

  @override
  Future<List<OrderItem>> build() async {
    _repo = ref.read(cartRepositoryProvider);
    _subscription?.cancel();
    final currentUserId = ref.read(cartUserIdProvider);
    final completer = Completer<List<OrderItem>>();

    _subscription = _repo.watch(currentUserId).listen(
      (event) {
        state = AsyncData(event);
        if (!completer.isCompleted) {
          completer.complete(event);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return completer.future;
  }

  Future<void> addItem(OrderItem item) async {
    await _repo.add(userId, item);
  }

  Future<void> updateQty(String id, int qty) async {
    await _repo.updateQty(id, qty);
  }

  Future<void> removeItem(String id) async {
    await _repo.remove(id);
  }

  Future<String?> checkout(double total) async {
    final orderId = await _repo.checkout(userId, total);
    return orderId;
  }
}

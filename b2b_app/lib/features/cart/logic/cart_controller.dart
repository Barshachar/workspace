import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/cart_repository.dart';
import '../../../core/models/order_item.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

final cartControllerProvider =
    AsyncNotifierProvider<CartController, List<OrderItem>>(CartController.new);

class CartController extends AsyncNotifier<List<OrderItem>> {
  late final CartRepository _repo;
  StreamSubscription<List<OrderItem>>? _subscription;
  String? _userId;
  bool _disposeRegistered = false;

  String get _resolvedUserId {
    final id = _userId ?? Supabase.instance.client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('No authenticated user available for cart operations');
    }
    return id;
  }

  @override
  Future<List<OrderItem>> build() async {
    _repo = ref.read(cartRepositoryProvider);
    _userId = Supabase.instance.client.auth.currentUser?.id;
    if (_userId == null) {
      return const <OrderItem>[];
    }

    final stream = _repo.watch(_userId!);
    await _subscription?.cancel();
    _subscription = stream.listen(
      (event) => state = AsyncData(event),
      onError: (error, stackTrace) => state = AsyncError(error, stackTrace),
    );

    if (!_disposeRegistered) {
      ref.onDispose(() async {
        await _subscription?.cancel();
      });
      _disposeRegistered = true;
    }

    return stream.first;
  }

  Future<void> addItem(OrderItem item) async {
    await _repo.add(_resolvedUserId, item);
  }

  Future<void> updateQty(String id, int qty) async {
    await _repo.updateQty(id, qty);
  }

  Future<void> removeItem(String id) async {
    await _repo.remove(id);
  }

  Future<String?> checkout(double total) async {
    final orderId = await _repo.checkout(_resolvedUserId, total);
    return orderId;
  }
}

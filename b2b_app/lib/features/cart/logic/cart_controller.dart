import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/cart_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/order_item.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

final cartControllerProvider =
    AsyncNotifierProvider<CartController, List<OrderItem>>(CartController.new);

class CartController extends AsyncNotifier<List<OrderItem>> {
  late final CartRepository _repo;
  String get userId => Supabase.instance.client.auth.currentUser!.id;

  @override
  Future<List<OrderItem>> build() async {
    _repo = ref.read(cartRepositoryProvider);
    _repo.watch(userId).listen((event) => state = AsyncData(event));
    return _repo.watch(userId).first;
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

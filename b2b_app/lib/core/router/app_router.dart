import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/catalog/presentation/catalog_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/orders/presentation/order_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'catalog',
          builder: (context, state) => const CatalogPage(),
        ),
        GoRoute(
          path: 'cart',
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: 'orders/:id',
          builder: (context, state) => OrderPage(orderId: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

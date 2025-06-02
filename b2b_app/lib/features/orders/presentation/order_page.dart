import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  final String orderId;
  const OrderPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('הזמנה $orderId')),
      body: Center(child: Text('פרטי הזמנה $orderId')),
    );
  }
}

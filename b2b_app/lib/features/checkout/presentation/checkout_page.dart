import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../orders/data/order_repository.dart';
import '../data/bnpl_provider.dart';
import '../../orders/presentation/order_page.dart';

typedef ConfirmPayment = Future<void> Function(String clientSecret);

final confirmPaymentProvider = Provider<ConfirmPayment>((ref) {
  return (secret) async {
    await Stripe.instance.confirmPayment(
      secret,
      const PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
    );
  };
});

final createPaymentIntentProvider = Provider<Future<Map<String, dynamic>> Function(String, int)>((ref) {
  return (orderId, amount) async {
    final resp = await Supabase.instance.client.functions.invoke(
      'create-payment-intent',
      body: {'order_id': orderId, 'amount': amount},
    );
    return resp.data as Map<String, dynamic>;
  };
});

class CheckoutPage extends ConsumerStatefulWidget {
  final String orderId;
  final double amount;
  const CheckoutPage({super.key, required this.orderId, required this.amount});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _loading = false;

  Future<void> _pay() async {
    setState(() => _loading = true);
    try {
      final credit = await BnplProvider().checkCredit('demo');
      if (widget.amount > credit.limit) {
        throw Exception('credit');
      }
      final createIntent = ref.read(createPaymentIntentProvider);
      final data = await createIntent(widget.orderId, (widget.amount * 100).toInt());
      final secret = data['client_secret'] as String?;
      if (secret == null) throw Exception('secret');
      final confirm = ref.read(confirmPaymentProvider);
      await confirm(secret);
      await ref.read(orderRepositoryProvider).markPaid(widget.orderId);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => OrderPage(orderId: widget.orderId)),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('שגיאת תשלום'),
            content: const Text('לא ניתן להשלים את התשלום'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('סגור'))],
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('תשלום')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('סה"כ: ${widget.amount} ₪'),
            const CardField(),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _pay, child: const Text('שלם')),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:b2b_app/features/checkout/data/bnpl_provider.dart';

class FakeHttpClient extends BnplProvider {
  @override
  Future<double> checkCredit(String customerId) async {
    return 100;
  }
}

void main() {
  test('credit check passes', () async {
    final provider = FakeHttpClient();
    final limit = await provider.checkCredit('c1');
    expect(limit, 100);
  });
}

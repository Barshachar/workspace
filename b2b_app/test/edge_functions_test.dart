import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
  test('edge functions invocation', () async {
    final client = MockFunctionsClient();
    when(() => client.invoke('recommend-products', body: any(named: 'body')))
        .thenAnswer((_) async => FunctionsResponse(data: []));
    final resp = await client.invoke('recommend-products', body: {'customer_id': '1'});
    expect(resp.data, isList);
  });
}

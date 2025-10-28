import 'package:b2b_app/core/services/logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('logger handles errors without throwing', () {
    expect(() => Logger.log('boom'), returnsNormally);
  });
}

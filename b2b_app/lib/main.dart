import 'dart:async';

import 'package:flutter/foundation.dart';

import 'bootstrap.dart';
import 'core/services/logger.dart';

void main() {
  runZonedGuarded(() async {
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    };

    await bootstrap();
  }, (error, stack) {
    Logger.log(error, stack);
  });
}

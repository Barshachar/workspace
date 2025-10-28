import 'package:flutter/foundation.dart';

abstract class Logger {
  static void log(Object error, [StackTrace? st]) {
    debugPrint('[ERR] $error');
    if (st != null) {
      debugPrint(st.toString());
    }
  }
}

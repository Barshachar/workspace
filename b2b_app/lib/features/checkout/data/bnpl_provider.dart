import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

class CreditResult {
  final double limit;
  final String status;
  const CreditResult(this.limit, this.status);
}

class BnplProvider {
  Future<CreditResult> checkCredit(String customerId) async {
    int retries = 0;
    while (true) {
      try {
        final resp = await http.post(
          Uri.parse('https://bnpl.example.com/check-credit'),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'customerId': customerId}),
        );
        if (resp.statusCode != 200) {
          developer.log(
            'BNPL credit check failed with status ${resp.statusCode}: ${resp.body}',
            name: 'BnplProvider',
          );
          throw HttpException('status ${resp.statusCode}');
        }
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return CreditResult(
          (data['limit'] as num).toDouble(),
          data['status'] as String? ?? 'unknown',
        );
      } catch (_) {
        if (retries++ >= 2) rethrow;
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }
}

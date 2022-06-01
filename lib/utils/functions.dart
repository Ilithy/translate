import 'dart:convert';

import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '/providers.dart';

Future<void> translate(BuildContext context, String sourceKey, String targetKey, String query, WidgetRef ref) async {
  if (query.isNotEmpty) {
    ref.read(outputProvider.notifier).state = null;
    try {
      final http.Response response = await http.get(
        Uri.https(
          'lingva.ml',
          '/api/v1/$sourceKey/$targetKey/$query',
        ),
      );
      if (response.statusCode == 200) {
        // ignore: avoid_dynamic_calls
        final String? translation = json.decode(response.body)['translation'] as String?;
        if (translation != null) {
          ref.read(outputProvider.notifier).state = translation;
        } else {
          showArnaSnackbar(
            context: context,
            message: 'Something went wrong!',
          );
          ref.read(outputProvider.notifier).state = '';
        }
      } else {
        showArnaSnackbar(
          context: context,
          message: 'Something went wrong! Error code: ${response.statusCode}',
        );
        ref.read(outputProvider.notifier).state = '';
      }
    } catch (_) {}
  }
}

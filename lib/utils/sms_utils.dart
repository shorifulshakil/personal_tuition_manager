import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches default SMS app to send payment receipt confirmation to student.
Future<void> sendPaymentSms({
  required BuildContext context,
  required String mobile,
  required String studentName,
  required int amount,
  required DateTime paymentDate,
  String currencySymbol = 'Tk',
}) async {
  final cleanMobile = mobile.trim();
  if (cleanMobile.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student has no valid mobile number.')),
    );
    return;
  }

  final formattedDate = DateFormat('dd MMM yyyy').format(paymentDate);
  final message =
      'Dear $studentName, thank you for your payment of $currencySymbol $amount received on $formattedDate.';

  final Uri smsUri = Uri(
    scheme: 'sms',
    path: cleanMobile,
    queryParameters: <String, String>{
      'body': message,
    },
  );

  try {
    final launched = await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open SMS application.')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open SMS app: $e')),
      );
    }
  }
}

/// Helper to send a direct SMS message.
Future<void> sendDirectSms({
  required BuildContext context,
  required String mobile,
  String? body,
}) async {
  final cleanMobile = mobile.trim();
  if (cleanMobile.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No phone number available.')),
    );
    return;
  }

  final Map<String, String> queryParams = {};
  if (body != null && body.isNotEmpty) {
    queryParams['body'] = body;
  }

  final Uri smsUri = Uri(
    scheme: 'sms',
    path: cleanMobile,
    queryParameters: queryParams.isNotEmpty ? queryParams : null,
  );

  try {
    final launched = await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open SMS application.')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch SMS app: $e')),
      );
    }
  }
}

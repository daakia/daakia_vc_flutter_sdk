import 'package:flutter/material.dart';

// Enum for Consent Status
enum ConsentStatus {
  accept,
  reject,
  pending
}

// Parse function from String
ConsentStatus parseConsentStatus(String? value) {
  switch (value?.toLowerCase()) {
    case 'accept':
      return ConsentStatus.accept;
    case 'reject':
      return ConsentStatus.reject;
    case 'pending':
      return ConsentStatus.pending;
    default:
      return ConsentStatus.pending;
  }
}

// Extension for icon, text, and resend check
extension ConsentStatusExtension on ConsentStatus {
  Icon get icon {
    switch (this) {
      case ConsentStatus.accept:
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      case ConsentStatus.reject:
        return const Icon(Icons.cancel, color: Colors.red, size: 16);
      case ConsentStatus.pending:
        return const Icon(Icons.hourglass_bottom, color: Colors.orange, size: 16);
    }
  }

  String get label {
    switch (this) {
      case ConsentStatus.accept:
        return 'Accepted';
      case ConsentStatus.reject:
        return 'Rejected';
      case ConsentStatus.pending:
        return 'Pending';
    }
  }

  Color get labelColor {
    switch (this) {
      case ConsentStatus.accept:
        return Colors.green;
      case ConsentStatus.reject:
        return Colors.red;
      case ConsentStatus.pending:
        return Colors.orange;
    }
  }

  bool get shouldShowResend => this != ConsentStatus.accept;
}

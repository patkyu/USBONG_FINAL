

import '../common.dart';

extension ptEtx on PaymentStatus {
  String get getName {
    switch (this) {
      case PaymentStatus.pending:
        return "pending";
      case PaymentStatus.processing:
        return "processing";
      case PaymentStatus.on_hold:
        return "on-hold";
      case PaymentStatus.completed:
        return "completed";
      case PaymentStatus.cancelled:
        return "cancelled";
      case PaymentStatus.refunded:
        return "refunded";
      case PaymentStatus.failed:
        return "failed";
    }
  }
}

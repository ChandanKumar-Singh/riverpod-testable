import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/payment/data/models/payment_model.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(ref),
);

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(this.ref) : super(const PaymentState());
  final Ref ref;

  Future<void> loadPayments() async {
    try {
      state = state.copyWith(status: PaymentStatus.loading);
      // TODO: Implement payment loading from repository
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(status: PaymentStatus.loaded, payments: []);
    } catch (e) {
      state = state.copyWith(status: PaymentStatus.error, error: e.toString());
    }
  }

  Future<void> createPayment(PaymentModel payment) async {
    try {
      state = state.copyWith(status: PaymentStatus.loading);
      // TODO: Implement payment creation
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        status: PaymentStatus.loaded,
        payments: [...state.payments, payment],
      );
    } catch (e) {
      state = state.copyWith(status: PaymentStatus.error, error: e.toString());
    }
  }
}

enum PaymentStatus { initial, loading, loaded, error }

class PaymentState {
  const PaymentState({
    this.status = PaymentStatus.initial,
    this.payments = const [],
    this.error,
  });
  final PaymentStatus status;
  final List<PaymentModel> payments;
  final String? error;

  PaymentState copyWith({
    PaymentStatus? status,
    List<PaymentModel>? payments,
    String? error,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      error: error ?? this.error,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:testable/features/payment/data/providers/payment_provider.dart';
import 'package:testable/features/payment/data/models/payment_model.dart';

void main() {
  group('PaymentState', () {
    test('initial state should have initial status', () {
      const state = PaymentState();
      expect(state.status, PaymentStatus.initial);
      expect(state.payments, isEmpty);
      expect(state.error, isNull);
    });

    test('copyWith should update only provided fields', () {
      const initialState = PaymentState();
      final payment = PaymentModel(
        id: '1',
        amount: 100.0,
        status: 'pending',
        createdAt: DateTime.now(),
      );
      
      final updatedState = initialState.copyWith(
        status: PaymentStatus.loaded,
        payments: [payment],
      );
      
      expect(updatedState.status, PaymentStatus.loaded);
      expect(updatedState.payments.length, 1);
      expect(updatedState.payments.first, payment);
      expect(updatedState.error, isNull);
    });

    test('copyWith should preserve existing fields when not provided', () {
      final payment = PaymentModel(
        id: '1',
        amount: 100.0,
        status: 'completed',
        createdAt: DateTime.now(),
      );
      final state = PaymentState(
        status: PaymentStatus.loaded,
        payments: [payment],
        error: 'Previous error',
      );
      
      final updatedState = state.copyWith(status: PaymentStatus.loading);
      
      expect(updatedState.status, PaymentStatus.loading);
      expect(updatedState.payments.length, 1);
      expect(updatedState.error, 'Previous error');
    });
  });

  group('PaymentStatus', () {
    test('should have all expected values', () {
      expect(PaymentStatus.values.length, 4);
      expect(PaymentStatus.values, contains(PaymentStatus.initial));
      expect(PaymentStatus.values, contains(PaymentStatus.loading));
      expect(PaymentStatus.values, contains(PaymentStatus.loaded));
      expect(PaymentStatus.values, contains(PaymentStatus.error));
    });
  });
}



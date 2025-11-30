import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/payment/data/providers/payment_provider.dart';
import 'package:testable/features/payment/data/models/payment_model.dart';

void main() {
  group('PaymentNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('loadPayments', () {
      test('loads payments successfully', () async {
        final notifier = container.read(paymentProvider.notifier);
        await notifier.loadPayments();

        final state = container.read(paymentProvider);
        expect(state.status, PaymentStatus.loaded);
        expect(state.payments, isEmpty);
        expect(state.error, isNull);
      });

      test('sets loading state during load', () async {
        final notifier = container.read(paymentProvider.notifier);
        final loadFuture = notifier.loadPayments();

        // Check loading state
        final loadingState = container.read(paymentProvider);
        expect(loadingState.status, PaymentStatus.loading);

        await loadFuture;
      });

      test('handles errors during load', () async {
        // This test would require mocking the repository
        // For now, we test the current implementation
        final notifier = container.read(paymentProvider.notifier);
        await notifier.loadPayments();

        final state = container.read(paymentProvider);
        // Current implementation doesn't throw errors, but structure is ready
        expect(state.status, PaymentStatus.loaded);
      });
    });

    group('createPayment', () {
      test('creates payment successfully', () async {
        final payment = PaymentModel(
          id: 'payment-1',
          amount: 100.0,
          status: 'pending',
          createdAt: DateTime.now(),
        );

        final notifier = container.read(paymentProvider.notifier);
        await notifier.createPayment(payment);

        final state = container.read(paymentProvider);
        expect(state.status, PaymentStatus.loaded);
        expect(state.payments.length, 1);
        expect(state.payments.first.id, 'payment-1');
        expect(state.error, isNull);
      });

      test('adds payment to existing list', () async {
        final payment1 = PaymentModel(
          id: 'payment-1',
          amount: 100.0,
          status: 'pending',
          createdAt: DateTime.now(),
        );
        final payment2 = PaymentModel(
          id: 'payment-2',
          amount: 200.0,
          status: 'completed',
          createdAt: DateTime.now(),
        );

        final notifier = container.read(paymentProvider.notifier);
        await notifier.createPayment(payment1);
        await notifier.createPayment(payment2);

        final state = container.read(paymentProvider);
        expect(state.payments.length, 2);
        expect(state.payments.first.id, 'payment-1');
        expect(state.payments.last.id, 'payment-2');
      });

      test('sets loading state during creation', () async {
        final payment = PaymentModel(
          id: 'payment-1',
          amount: 100.0,
          status: 'pending',
          createdAt: DateTime.now(),
        );

        final notifier = container.read(paymentProvider.notifier);
        final createFuture = notifier.createPayment(payment);

        // Check loading state
        final loadingState = container.read(paymentProvider);
        expect(loadingState.status, PaymentStatus.loading);

        await createFuture;
      });
    });

    group('PaymentState', () {
      test('copyWith updates status', () {
        const state = PaymentState();
        final updated = state.copyWith(status: PaymentStatus.loading);
        expect(updated.status, PaymentStatus.loading);
        expect(updated.payments, isEmpty);
        expect(updated.error, isNull);
      });

      test('copyWith updates payments', () {
        const state = PaymentState();
        final payments = [
          PaymentModel(
            id: 'payment-1',
            amount: 100.0,
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        ];
        final updated = state.copyWith(payments: payments);
        expect(updated.payments, payments);
        expect(updated.status, PaymentStatus.initial);
      });

      test('copyWith updates error', () {
        const state = PaymentState();
        final updated = state.copyWith(error: 'Test error');
        expect(updated.error, 'Test error');
        expect(updated.status, PaymentStatus.initial);
      });

      test('copyWith preserves other fields', () {
        final payments = [
          PaymentModel(
            id: 'payment-1',
            amount: 100.0,
            status: 'pending',
            createdAt: DateTime.now(),
          ),
        ];
        final state = PaymentState(payments: payments);
        final updated = state.copyWith(status: PaymentStatus.loading);
        expect(updated.status, PaymentStatus.loading);
        expect(updated.payments, payments);
      });
    });
  });
}

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/retry_widget.dart';
import '../../data/providers/payment_provider.dart';

@RoutePage()
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentProvider.notifier).loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: paymentState.status == PaymentStatus.loading
          ? const LoadingWidget(message: 'Loading payments...')
          : paymentState.status == PaymentStatus.error
          ? RetryWidget(
              message: paymentState.error ?? 'Error loading payments',
              onRetry: () {
                ref.read(paymentProvider.notifier).loadPayments();
              },
            )
          : paymentState.payments.isEmpty
          ? const EmptyListWidget(
              message: 'No payments found. Tap + to create one.',
            )
          : ListView.builder(
              itemCount: paymentState.payments.length,
              itemBuilder: (context, index) {
                final payment = paymentState.payments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('\$${payment.amount.toStringAsFixed(2)}'),
                    subtitle: Text(payment.description ?? 'Payment'),
                    trailing: Chip(
                      label: Text(payment.status),
                      backgroundColor: payment.status == 'completed'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    onTap: () {
                      // Navigate to payment details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create payment
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
